Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E309F4F68CE;
	Tue, 13 Oct 2026 12:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895923; cv=none; b=lhFWEty16O/6Zs/iM8/Ym0y45o9mi671VKO/Zh1R9SHq3WwACYr/98M3wv41ay3eMyJNzOMqNg3TluB1f3YtS0upwzmPTcGCB2tp8MIqySefipP9G7k0+mSYQJn4G8g/CKYAPtZUQgfquVpGD6aN4EdV169258L9W3b5DsLSDUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895923; c=relaxed/simple;
	bh=hjRE2kMEwYoLEwjWRF2353J/9Yv27qcWo+V9fR08o9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m95dtVF2mEpbIaCvmzq2tjHn3Ala6Wy9ByvdEin6WDk1C/PRA6E5XIS5FgD9zl+DD2RPd+/55BXQt+e8gjQIR2IbnLq95jExz3IXOtAN6PxF0/0QUM/z13ZdocT4tuJhLVCiDfZxepf04MyJvkgh5vTTwBlKVvOA8r1/z/xlzII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwwCNb0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwwCNb0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4345C1F000FF;
	Tue, 13 Oct 2026 12:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895922;
	bh=PcD76DqjTSWUv3N71we6GCEcgh3itR1XHrgGq01k8Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwwCNb0Ei3L1z17XkUGjQgda0Ctl7sf6BQ9HyDGPyUAmSoKh5E5igDrqo/sL2Gpnr
	 O2B3G0m/3PFfhY0PmKXPQHN6kNsRbeRNf31qClq0TL9NZJ+6nEwjk76oQOPDcyZonq
	 nvtpscwdFzwHNZFdRtV3S42sgi3pxjprngAwBFEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 438/497] namespace: dont copy an unmounted mount tree
Date: Tue, 13 Oct 2026 13:40:05 +0200
Message-ID: <20261013112918.280003606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 8bacbf6be959973b28b691713a872c12eae69eec upstream.

may_copy_tree() accepts a mount whose root is an nsfs or pidfs file
before it checks whether that mount is mounted. This exception exists
for nsfs and pidfs mounts. They are part of no mount namespace so
neither check_mnt() nor is_mounted() would let them through and
bind-mounting a nsfsfd or a pidfd wouldn't work.

Problem is that exception also admits a bind mount of such a file when
it was lazily unmounted and is only kept alive by a file descriptor:

  mount --bind /proc/self/ns/net /tmp/x
  exec 3< /tmp/x
  umount -l /tmp/x
  mount --rbind /proc/self/fd/3 /tmp/y

With MS_REC or AT_RECURSIVE copy_tree() doesn't stop at the unmounted
mount. It copies every mount that stayed attached to it as well. So if
you have a bunch of overmounts over the nsfsfd or the pidfd the whole
unmounted stack is copied. That's a bug.

So refuse to walk an unmounted tree. Copying its root alone stays
possible. So a bind mount of a namespace that is gone can still be
recreated from a file descriptor on the old one. The file descriptor
pins that mount and its root and __has_locked_children() only reads the
direct children which don't leave the parent's list without
namespace_sem. The internal mounts carry MNT_NS_INTERNAL instead of NULL
and are still walked. Copying an unmounted tree recursively fails with
EINVAL.

Fixes: e149ed2b805f ("take the targets of /proc/*/ns/* symlinks to separate fs")
Fixes: ef4144ac2dec ("pidfs: allow bind-mounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-4-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2792,6 +2792,9 @@ static struct mount *__do_loopback(struc
 	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
 		return mnt;
 
+	if (recurse && !old->mnt_ns)
+		return ERR_PTR(-EINVAL);
+
 	if (!recurse && __has_locked_children(old, old_path->dentry))
 		return mnt;
 



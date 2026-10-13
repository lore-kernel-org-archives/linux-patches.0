Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CCC4F4CE6;
	Tue, 13 Oct 2026 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893158; cv=none; b=iHqIA1r8uDmcFq1eypbKQAFqsdb39rzexx4jtmN4rzbO2N83btseaRqrkBNJl3DIa/hewLTU3r7BV0ZHUjb2jCz7m4QZDzguXeeNypAH3EYvwSsDMApmNdqogC49DGcwC0/5wi1FfmKxoccyrcqb21rydSoGfIhy3sNG8YBMl2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893158; c=relaxed/simple;
	bh=kw3ONHATmKg6xBZV9yBttzDepo0B738/wqooBLpdcOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnhoEo7QMSWETBmQR/SwSdzZNSbnxdpGst2sIiliyr1Bh1J8XN40gvimN+wYVNyeOTAanWCvBLg23epZFMY+B4yfM2qx5KVqzHa+cWC6NuPGWe0wzZ7TMO8sOweL3hXobM9vJFpoRuLMXUeV2fYgKm4ZE+6uK07wXlXCCCmFJ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShKBwUA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShKBwUA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01E71F00893;
	Tue, 13 Oct 2026 12:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893157;
	bh=YW32ZZX8EgxgHkuo5c+jJJwrThNZbXbZlI4ZP0t5bKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShKBwUA3wtd1v0jG0chBKCdEj6et91QQ/zN7skP7o+uoyu1feuqXfNVrr+4m3vciz
	 jGiYA0SWQcF5aAaDxFJzfPWKg8SUwslHggj1fHJmJL4z8jMtYoOUkTflBpIpK9pOaU
	 aRDQ4a4mmQ0swSDe1JaMCyk+KqTJtn09HNBl4YH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 132/621] namespace: dont copy an unmounted mount tree
Date: Tue, 13 Oct 2026 13:32:07 +0200
Message-ID: <20261013112923.991580343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2967,6 +2967,9 @@ static struct mount *__do_loopback(const
 	if (!may_copy_tree(old_path))
 		return ERR_PTR(-EINVAL);
 
+	if (recurse && !old->mnt_ns)
+		return ERR_PTR(-EINVAL);
+
 	if (!recurse && __has_locked_children(old, old_path->dentry))
 		return ERR_PTR(-EINVAL);
 



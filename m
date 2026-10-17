Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D122EA15C;
	Sat, 17 Oct 2026 17:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257604; cv=none; b=IXs0fTBcl1Btkes8gZyZvqE0tNm38U3KAd0buKLdsDtiWkiloylK0EeFAZYUorM7B4z+XFfBQ3ph9aPilwqyrpRNgusl1SUgP+ZJzuMMNylY0XOs+BKQW3TwlEAGZ5IUoynw76Cyz4VG2rEGzSlY+koVT0BQLzqH6YiBPOZIV2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257604; c=relaxed/simple;
	bh=BpET8Xe9q87optbkDNDvZwU3TFUI2uCQHVCpL2kPLsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdlkFPSce+eRHAwtDA59ZYdkc7Xs6rxvbA5myiA1cJ6Jy8vd13pAbWzfye0jU4qTEw16vKwHVq72xD0HIgmqnbToYlHa3ATDJBkoGNidbDyZKNMHxA8USO49tVkT9am6MM4L0sAPomnVCcpoOWCRGS9F73WLOVWykWz9w/lfW3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRZ41r3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRZ41r3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6631F000C4;
	Sat, 17 Oct 2026 17:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257603;
	bh=EO6lyDZ76D5gwdIIvz8LK1fblZSwzx6w1W43oudI5Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRZ41r3a/fTvnPFTGYcrs6umeLAU8uE8rHL9tD6cdrpncLWXxavDnfnRznNnp7Pcj
	 IlZqxKkS3EeV4yfExtlk2gABcAPOSHs0dKXV1pcE4WUOHzpAx9STBbCTR2UDY0sujC
	 jbJ4v6S+Ct6iKWlKMnGmQBFDm/FM5Zz1jbVnYIE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0610/1674] namespace: dont copy an unmounted mount tree
Date: Sat, 17 Oct 2026 17:48:02 +0200
Message-ID: <20261017160446.742532091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 8bacbf6be959973b28b691713a872c12eae69eec ]

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
[ sashal: Adjusted context for existing inline permission checks and has_locked_children(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index c1d2ee1885536..70f59ac913b76 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2621,6 +2621,9 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
 		return mnt;
 
+	if (recurse && !old->mnt_ns)
+		return ERR_PTR(-EINVAL);
+
 	if (!recurse && has_locked_children(old, old_path->dentry))
 		return mnt;
 
-- 
2.53.0




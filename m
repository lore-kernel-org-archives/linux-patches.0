Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211647;
	b=34dP10k1NRAwwVIUtnE3EyEcsgrPyrDavEQPLqI3fvo5/gIg0UGYxe7S1Tn60xtQoBmz
	 g03CtKafZuftDlQmBDfWwBHMkl95qZ9FWcSt/QBWiNFH4+OEve2x+wbLhrMbtd7GcZMk5
	 tm+P5nPRvlxmX8Kd288v5ZNKu/SMMImff2lV3RTu/1/MngTrZB3/fdjXjIk+GvxX4ver1
	 gNqA0m3jNzwjhqQzj9Tn19KT2LswDzKr9H1HI2EgQjiWe+2+YRrLynMOCVZcRQA49ADj2
	 VBPi9FAVW7rA2N5ydIEnb5UDFjjiNeTz4ro/yeH3hWRhAZyyiARilMqj6lzKv9nTR2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xua8xv1u7tOdiBYSWNbjWp/TzJ0E8uN2bIfHDz40s8E=;
	b=DT9ZdAhb3ETE52RaB56IoF24NyaQJA2jXU68ozfcuY6z4bMhqm22K5CqCRBuvRGBSgPO
	 k5AMIAbt0fGd7ZErTXKbH3ihaja91u9DZ3OxzCRhbdKftgI0+ik+F5GBu/Z0PDJ9hkkfJ
	 RZFX3PSnMkVgHeKED7lkqbfLtlQyiuqrneg23dlXLFf+qUPPNDHFljlH1zj4WSWrorcId
	 h+7O2Fmqnx/LYSgR/EIGgxA7TZBfQlin2LOcZk7Ni1onYuhJyGwp426cvasKRq0s1Gpw1
	 s0sASrKuXXWlYxq8VcAjRg05wxWAONKX7FyFJo6gyeY3zBRPj0D2aS0UrB0Flvir2tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGL7jeEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E066B606A31A;
	Wed, 28 Oct 2026 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGL7jeEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B00A1F01825;
	Wed, 28 Oct 2026 18:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211646;
	bh=xua8xv1u7tOdiBYSWNbjWp/TzJ0E8uN2bIfHDz40s8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGL7jeEqqlpp4ookUW0Vf5sUgkdi2gRiE/M4nHpbWJHGCIOOnKZdVBXZvsgJ/u5vN
	 UvmxZA3G5uHy0U1FM1Z6XWMKsP5jnzfw0OyP9mRzuKHb0VoQ7Rv4ulpyuLdmQvdVDU
	 wgIXi8fx3oTbnuCLyk7SIcHUwTbt7itS7pzCs8RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/571] namespace: check the target before walking it in do_mount_setattr()
Date: Wed, 28 Oct 2026 17:59:57 +0100
Message-ID: <20261028170018.705928929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 08f4288a37ef4b3d19b4a9599ec3048219cac828 ]

When mount_setattr() changes the propagation type to MS_SHARED
do_mount_setattr() takes namespace_sem and calls invent_group_ids()
which walks the whole target tree with next_mnt() and allocates a peer
group id for every mount that doesn't have one.

Whether the caller may touch the target at all is only checked
afterwards under mount_lock. If it may not, cleanup_group_ids() walks
the tree a second time on the way out to free the ids again.

A detached tree that a file descriptor keeps alive, a mount in another
mount namespace or a mount below the root of an anonymous mount
namespace does a bunch of allocation work that is completely useless
because it will fail and revert right after.

Do the right thing and check the target right after taking namespace_sem
instead. A mount leaves its namespace only under namespace_sem so the
mount stays stable. The check under mount_lock stays for the case where
no propagation change is requested and namespace_sem isn't taken.
Callers get the same EINVAL as before.

Fixes: 2a1867219c7b ("fs: add mount_setattr()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-5-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Replaced anon_ns_root() with existing mount eligibility checks guarded by is_mounted(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3c20771eabfff..1b79364c27bf5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4074,6 +4074,7 @@ static struct mount *mount_setattr_prepare(struct mount_kattr *kattr,
 {
 	struct mount *m = mnt, *last = NULL;
 
+	/* Checked under namespace_sem already if the propagation changes. */
 	if (!is_mounted(&m->mnt)) {
 		*err = -EINVAL;
 		goto out;
@@ -4183,6 +4184,13 @@ static int do_mount_setattr(struct path *path, struct mount_kattr *kattr)
 		 * propagation.
 		 */
 		namespace_lock();
+		/* invent_group_ids() walks the tree, only walk a mounted one */
+		if (!is_mounted(&mnt->mnt) ||
+		    !(mnt_has_parent(mnt) ? check_mnt(mnt) :
+		      is_anon_ns(mnt->mnt_ns))) {
+			namespace_unlock();
+			return -EINVAL;
+		}
 		if (kattr->propagation == MS_SHARED) {
 			err = invent_group_ids(mnt, kattr->recurse);
 			if (err) {
-- 
2.53.0




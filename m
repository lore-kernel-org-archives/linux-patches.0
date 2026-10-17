Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9836356A12;
	Sat, 17 Oct 2026 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257607; cv=none; b=CmhA5vCEpkUkECPrWf61stG79KS/J1DSYJm6wAOLWpB7AGZf4ksDwkhifBpnKRqvMjOnZzNVbINZMn9nqgO0zYqNQD14CZswKHm6PH9kbvyAjgePAZuh9PysNOdwC7yw2nswwynjbpJ+W18F+OeP+oe25Hi8sUPM9gNP51X4KIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257607; c=relaxed/simple;
	bh=JPmYer9e4pV4U+KQBmGdMwfuXExBc2BKmoK5pGeVDys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do3/EOSEFrfPjypDJe/WDg2yYgdwm6SKiHCf+WdoFn/WlWaOum9yUlG8xTzIzw6/6Q7m0xD1EToQo1h42U66bZBE7AAHpq1iuERqlgmytbFl5MmgGukJrA/21y7epE9pMFslvVr0yZv6gI9o185F5VktkKhO9SEHGI79BXlg5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEraGBa2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEraGBa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313941F000C4;
	Sat, 17 Oct 2026 17:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257606;
	bh=ADZxpXbUGP6Tly82ANvVsM8YR3MklE1OqOs48Sp8yMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEraGBa2Tjl8LA5jmETq4Ti53VIXvkj8qEBV+F5GY+bszuACqH5wzXp2j0FtaTbxU
	 lh2H4gI9eUod0PJY3M7DPRDnwkJWHbFX8tP7Ra+0UsLXMjEc2VSVwdvIGj5sp4Ia8I
	 hzWDtxfkX2iG3HIM4ABmW5wPiKGJDh4W5oD47U0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0611/1674] namespace: check the target before walking it in do_mount_setattr()
Date: Sat, 17 Oct 2026 17:48:03 +0200
Message-ID: <20261017160446.767628066@linuxfoundation.org>
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
[ sashal: replaced anon_ns_root() with explicit checks using is_mounted(), mnt_has_parent(), and is_anon_ns() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 70f59ac913b76..c0d32896981fc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4535,6 +4535,13 @@ static int do_mount_setattr(struct path *path, struct mount_kattr *kattr)
 		 * propagation.
 		 */
 		namespace_lock();
+		/* invent_group_ids() walks the tree, only walk a mounted one */
+		if (!is_mounted(&mnt->mnt) ||
+		    ((mnt_has_parent(mnt) || !is_anon_ns(mnt->mnt_ns)) &&
+		     !check_mnt(mnt))) {
+			namespace_unlock();
+			return -EINVAL;
+		}
 		if (kattr->propagation == MS_SHARED) {
 			err = invent_group_ids(mnt, kattr->recurse);
 			if (err) {
@@ -4547,6 +4554,7 @@ static int do_mount_setattr(struct path *path, struct mount_kattr *kattr)
 	err = -EINVAL;
 	lock_mount_hash();
 
+	/* Checked under namespace_sem already if the propagation changes. */
 	/* Ensure that this isn't anything purely vfs internal. */
 	if (!is_mounted(&mnt->mnt))
 		goto out;
-- 
2.53.0




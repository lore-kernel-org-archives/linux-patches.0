Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034906;
	b=1LrdlfVVRQbK5nDl8S86dyigFmHnFAuneM2VG1v5rwHqNUek3kKREHq9aiR5C2muCQAF
	 p8+iobCU9oLG42fObNx9lQW55eNPk5XBVhZyQgjb5mwJvqthW42z79q29pGqN7/SwlzXb
	 v5qjvaNYzo1FFVVv3+CC5NM6ckSK4KnLctnJumqJZb8YOG9x7Cl3j4XnWfzoFhu7nLQQf
	 PpC+mu7IGdv3+a5wdycpe303j9P1MbZmHnFFmJdXGIq4ywHR5426uumg5UtRIrIJHHZe+
	 HYtTIEpwU6r7E1hFlOTI6mL+lDOaR+gfcikZDb6EecMyeZwh94J93sW6yyKX3xdeQ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q+y0oQxdIGL132iAiSbHyJ+VUyWuBb1w9NN/fc7rnhs=;
	b=ppdc9CsrdhuAfIXG1Q/XtzAb+iXEJQtZeN5ZXgSDRlGQKclJGdOowFSCJA3v9vpyq5UJ
	 sCGELTzQpsGPdo7aJ5zb7AH0IQdIxC0hx9+L7gklbBO2SOflOcxbyGAWxD84mjGHx7J70
	 wLC9UNROacni2w7hpJk453N2AKdjXs6g3Ww2ICYMp0ASYaYPJ4c4XWW/fF675UBAQFKuU
	 doquyDw1H9YV83mrNNAF50v3jMMMPmFL9iYpbTaGI5iORztOCWnOZsbA17TsJGz03XJs0
	 cnIRB8KtsjM82LwaxGauLrZtLejn3ZKtfIy4qyEXElWxLgp/mDWZ0Y68I6EdCfoSLDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M521Lr8B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775DF606A320;
	Wed, 18 Nov 2026 20:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M521Lr8B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2331F000C4;
	Wed, 18 Nov 2026 20:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034906;
	bh=q+y0oQxdIGL132iAiSbHyJ+VUyWuBb1w9NN/fc7rnhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M521Lr8BgDLbbtt+ioSavo/y26v90hAW1LjnNUsBRuno8F9Fzg/shd0sjvMFcE83b
	 puNCWdsEzqSPA3MgpiZAZCkZS1rJFErPLFaSmSpKZYu+lZnBZAroPietZ1omSQyW12
	 UP1pRb6uWyQn8uwPuKd67/wj4f3P7kAarDzKNtX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0533/3318] namespace: never expire a locked mount
Date: Wed, 18 Nov 2026 15:19:15 +0100
Message-ID: <20261118150333.230607249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit f78ddcc872248c7aa1d7e904928441a0be4c6d5d ]

Locked mounts are special. They protect the underlying files and
directories from being revealed. do_umount() refuses to unmount locked
mounts but shrink_submounts() doesn't.

A shrinkable mount can become locked once the owner of a user namespace
puts it beneath a locked mount with MOVE_MOUNT_BENEATH. The locked
property now moves to the mount at the bottom making it possible to
unmount the top mount.

So umount() of an unlocked ancestor now expires the bottom mount first
and the covered directory is revealed:

  move_mount(c -> x/hidden, MOVE_MOUNT_BENEATH) = 0
  the cover after the lock moved:  umount2(x/hidden) = 0
  the holder of the lock:          umount2(x/hidden) = EINVAL
  the root of the copy, busy:      umount2(x) = EBUSY
  reads x/hidden/secret: "covered-by-root"

So leave a locked mount alone as it dies together with its parent. A
plain umount() of an unlocked mount with a locked one below it is EBUSY
from now on. It's the same for any other locked child. A lazy umount
still takes the whole tree.

mark_mounts_for_expiry() never sees a locked mount. lock_mnt_tree()
leaves a mount on an expiry list alone and nothing else puts a locked
one on such a list. Add an assert for this.

Fixes: 5ff9d8a65ce8 ("vfs: Lock in place mounts from more privileged users")
Fixes: c62a4766937e ("move_mount: transfer MNT_LOCKED")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-8-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Dropped the VFS_WARN_ON_ONCE() assert hunk in mark_mounts_for_expiry() because its context check and helper are missing here; the shrink_submount() fix is unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 449c52d0611df..7b6366a807e6e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3556,7 +3556,8 @@ EXPORT_SYMBOL_GPL(mark_mounts_for_expiry);
  */
 static bool shrink_submount(struct mount *mnt)
 {
-	if (propagate_mount_busy(mnt, 1))
+	/* not the kernel's to remove either */
+	if (IS_MNT_LOCKED(mnt) || propagate_mount_busy(mnt, 1))
 		return false;
 	touch_mnt_namespace(mnt->mnt_ns);
 	umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
-- 
2.53.0




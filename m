Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021583;
	b=X9bQcBo/0+izZfseYF3Tkatl9OvjjIvG5LtEnLGQ/mUL03ncAXaN8otkNwAN2bY6SExn
	 uk0VBINkrab3tYvoDqGSHoeguDDe/4UAxVmHBNLq47DsO+kNrPQWhVNcN6nvdL24QqdZn
	 B9dPfxOU1Oh+OKxzWsENHv3+tjHLvooix89VDG7miF3sVGJ0cQvBiUwV3/Edd/jmWF34i
	 m5TFD6uCekZIjC/cOj6uAoU09nnjYjtpkQxq0SygNlmmMu09dN80irOkG0TSpxrCesGry
	 HQwbDAPQ8n+vA03MdrEyj17vmVotcZGFTysl8WtmF2nJpnR8JffLPzTQuAjqvYfR4nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z+8xUHPL0tRgZEEEe+SXrx0naTNxq3KowzfjAvU3+bw=;
	b=smO5aeqCDML1DmAR4vRi7S74BTKRPFwwiZIShWIEnA5Jf1AvepgfzNxwSk4ErrzGMzTj
	 SuryrFbNVlVOZ4w9D1I9Ad1r3/toX0wyRea/Veb5PSoynSHdVDIDglxdOb9uPR4iGwpUY
	 sY2QIom99frFdVRZYqggyaqd/V2smvxIkuXydhZSIpVrtAoImwl4E1tvMk9VEbJTaGoif
	 Z7wk1CxvbqWgbPbZKchAV1D50N4lX2YdK6RoJkNR3MUOuD20dwVKssy2ubhDuVCIyPwjc
	 i0E0PNxcs5cEgi5MMiWHzzZb0j95Pn7urqCF64Cbfx9QtgNhJUszMZ9Wxa5VOwJIGwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F3AMv28/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAFC606A339;
	Wed, 18 Nov 2026 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3AMv28/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9581F000C7;
	Wed, 18 Nov 2026 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021583;
	bh=Z+8xUHPL0tRgZEEEe+SXrx0naTNxq3KowzfjAvU3+bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3AMv28/394Rjln4qeQzGDOE/MUvWLFcLAGqVttSZoIYYocSN1XUQQh5qugJ7+ADX
	 LPhjIqxCDSwHJVQw1N1FCSE8LXEPSxBNgoSpATTrq+zs0WKzKvB3cOxmYLfTA6r2L+
	 nXq0tTG4abXnj6l/dOa+jEywVI5QbpAQLFMeObnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2357/2651] fs: fix ramfs_fs_info leak when rootfs is unmounted
Date: Wed, 18 Nov 2026 15:59:57 +0100
Message-ID: <20261118150410.425340974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit c60f9fe1988dd6f96b4b1d4f25fe7474340c7b87 ]

When rootfs is a ramfs, for example with root= on the command line, its
superblock carries a struct ramfs_fs_info from ramfs_init_fs_context().
ramfs_kill_sb() frees it, but rootfs_fs_type uses kill_anon_super().

Before commit 576ee5dfd459 ("fs: add immutable rootfs") rootfs could not
be unmounted. Since then prepare_namespace() pivots into the real root
and unmounts rootfs. When the superblock is destroyed, the structure is
leaked. kmemleak on an SH7785LCR board:

  unreferenced object 0x8100a720 (size 32):
    comm "swapper/0", pid 0, jiffies 4294892299
    backtrace (crc c8bfd23b):
      ...
      ramfs_init_fs_context+0x16/0x48
      rootfs_init_fs_context+0x16/0x2c
      alloc_fs_context+0x98/0x114
      fs_context_for_mount+0x16/0x24
      ...

Call ramfs_kill_sb() when rootfs is a ramfs. tmpfs frees its own data
in put_super and keeps kill_anon_super().

Fixes: 576ee5dfd459 ("fs: add immutable rootfs")
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20261009055546.85279-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/do_mounts.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 95e0b3a0f711b..b088021b1546d 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -503,10 +503,18 @@ static int rootfs_init_fs_context(struct fs_context *fc)
 	return ramfs_init_fs_context(fc);
 }
 
+static void rootfs_kill_sb(struct super_block *sb)
+{
+	if (IS_ENABLED(CONFIG_TMPFS) && is_tmpfs)
+		kill_anon_super(sb);
+	else
+		ramfs_kill_sb(sb);
+}
+
 struct file_system_type rootfs_fs_type = {
 	.name		= "rootfs",
 	.init_fs_context = rootfs_init_fs_context,
-	.kill_sb	= kill_anon_super,
+	.kill_sb	= rootfs_kill_sb,
 };
 
 void __init init_rootfs(void)
-- 
2.53.0




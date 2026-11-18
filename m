Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016259;
	b=ocgg4cmoujTSQF//+pnapjpJuj7gHH7NL6WlA0f4i7FzbKiSZhbwX3srMxm1Xa0emDev
	 jEp5jLawI5f4yskM/WoaVE+6jJV5F37lBOhsGQMJE/pNRaOH0exJ+4HUip8ngI4DALFx5
	 j13lz9hELkdBZleUClZyXkvPOp0lAM07WVNP/FrBEk3JF6nekDx5gIPrhHGV+nsuiLwOj
	 SqlXv/pwfl+FvLQ2oasQqqMROmN8dAIt3F7Q4ew5Zu29Ot6LP/zkbz5bUdpb5CTlQw3Nm
	 0/3SyI49JoI4uYn3x1Dp+Gi8eL9n2AtNl4Cakb4rkdJUIVDV7aLYBAxPtjHvgyd+hKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnMO3YxvsJddAWthpFhNpg5cd0yHOY1DC1DqZiekiDg=;
	b=z8gAAwOJ7WySHNvQomJ6SoaaYN8Gaem1cTqxMAYQKf3MKxX42NIE2s8PASsEPFR4v3XM
	 D0Lhty5H01vwmXfCb4cr1HWO+xb/RRdadHjk6F1ziH2kYKeS3up7mLzUmrhqHT/ooPpsj
	 3GcDE3vznwX3eYyN9fOK8Pk2IX+KlTgYQAqf9SThcANycgZeG9NwvQYKmqp8QSenJJ9/m
	 8phjETe+FoZ5b5wUXuDxRQ08EVT4o+e0HnVqo878T24E1HYxz/I/5i7FQlTZO9nwtwPra
	 eBFKAIt6MWIXUGr+yKsawsjp6wWlpwvL0KKAJ1/BAx+qF9Z0aNolwdCwh6EkusHftbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKC2zBSB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFC3606A320;
	Wed, 18 Nov 2026 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKC2zBSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBB91F000CA;
	Wed, 18 Nov 2026 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016258;
	bh=BnMO3YxvsJddAWthpFhNpg5cd0yHOY1DC1DqZiekiDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKC2zBSBf7kNp3FzHUi2wbuPLOa4kHnJKI9POxE73OSB7NRFb+DBBLUj8gY2ohzre
	 spNldt8JpN7ZSzwo3e96Psdt7Eic/ZOuL51iB+FlW4ggyothXkM1c2uOt1KqTbZiQQ
	 +vKf0pkORJf4QiJCNxYhgD3HPQOszT5lJ6ZI5zIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <jnhuang95@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0464/2651] f2fs: quota: fix stale lock holder on remount failure
Date: Wed, 18 Nov 2026 15:28:24 +0100
Message-ID: <20261118150304.503029752@linuxfoundation.org>
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

From: Jianan Huang <jnhuang95@gmail.com>

[ Upstream commit 3f140a60c92a5e2e9885adac70cd3686ba4ee19a ]

F2FS remount can fail while duplicating a journalled quota file name.

f2fs_remount()
- sbi->umount_lock_holder = current
- kstrdup(F2FS_OPTION(sbi).s_qf_names[i])
  : fails
- free previously duplicated names
- return -ENOMEM

The direct return leaves umount_lock_holder pointing at the failed
remount context.  A later checkpoint may then wrongly treat another
context as the s_umount lock holder.

Add a restore_holder cleanup path and use it before returning -ENOMEM.

Fixes: eb85c2410d6f ("f2fs: quota: fix to avoid warning in dquot_writeback_dquots()")
Signed-off-by: Jianan Huang <jnhuang95@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index b18ea09bcbe2c..17e00d5003b02 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2864,7 +2864,8 @@ static int __f2fs_remount(struct fs_context *fc, struct super_block *sb)
 			if (!org_mount_opt.s_qf_names[i]) {
 				for (j = 0; j < i; j++)
 					kfree(org_mount_opt.s_qf_names[j]);
-				return -ENOMEM;
+				err = -ENOMEM;
+				goto restore_holder;
 			}
 		} else {
 			org_mount_opt.s_qf_names[i] = NULL;
@@ -3125,6 +3126,7 @@ static int __f2fs_remount(struct fs_context *fc, struct super_block *sb)
 	sbi->mount_opt = org_mount_opt;
 	sb->s_flags = old_sb_flags;
 
+restore_holder:
 	sbi->umount_lock_holder = NULL;
 	return err;
 }
-- 
2.53.0




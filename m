Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029599;
	b=ukHf32GgEDXWHw8A2Ik+YsGoaQnLj3feyaG4CCmrLUlx1rZIfmKdv2a47g8k0ttl32It
	 x+ODgbJRytWDVH/Tg+Q4RhM5iY4z0IFz2iWUmZrO85loRP7v+oPRnaGlIYIt9k1Dzbe0O
	 EEbUoPBdgFxljNKlynZbVCBSTR7S+cZ9NnnXDkx5DpSmWzMHw75uTvZDEax8nYjOw8COh
	 VrUT849LF4pE61c95v1MQ22LR9s/Jr1446vSFD8AC7ZRdihdoo15z2k+eareEk5w9TvZ8
	 nTqRmHsAxiiGb4SXDIuvwLqYLhSigPFJh3C4DWcq/r/FGjy0mDmhECDH8u/j4YXacBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tMvkiKjKby36wslfwVIzz1yOrbwFn8ZOqSTRCxPspCM=;
	b=bqFHyRdDFvyrn2hl1Co0iOiVWm0yitPviZs8P9ZJRCRGYld3X9oVwCapJaDATqNIZ+AY
	 ZC18BZlFipWBarsVY7GC/ia3I3LMggnUWkeQo7xxGkgE6UvLh4+ONMt8p6akh0DDOnviL
	 CIEf66FSf0bnhxNVv+FZnje7NgB3dorCVvmT9r320xHx7dMPKniaWW1EM1a0Om+Y766y7
	 amZGDk0a4AKlWExUHoZOF07L/dy4yanKNf15lcTI/AVHStx1EYwOaQ9/P30jWUq01EzWK
	 YgZZNIohUc4WIMPdSZOfZywBbfQ8HzZn0q3Nf1TfOq4X0Gq0yOfejXg6uPLZqSgLSZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1S1Y2GO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4711F606A332;
	Wed, 18 Nov 2026 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1S1Y2GO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123721F000C4;
	Wed, 18 Nov 2026 19:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029598;
	bh=tMvkiKjKby36wslfwVIzz1yOrbwFn8ZOqSTRCxPspCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1S1Y2GOJ5d6GFNQjZwb4TQH8vF7cQnWGuFEe99jy0y5B0AbjFMbsjgVucmu77kJv
	 SbHmaJ+GlC1EHSedW2wEbTuIPC2hkrPMO7PiXAXwHI85MQ6rWmADLK7CjYTD4O/yKs
	 bniClk8GdW+MTSddY+Dnf77n96fkkyzKK88tW6P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <jnhuang95@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0406/1756] f2fs: quota: fix stale lock holder on remount failure
Date: Wed, 18 Nov 2026 15:42:13 +0100
Message-ID: <20261118150024.928114856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index facf7647b5095..7f81ac832a858 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2381,7 +2381,8 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 			if (!org_mount_opt.s_qf_names[i]) {
 				for (j = 0; j < i; j++)
 					kfree(org_mount_opt.s_qf_names[j]);
-				return -ENOMEM;
+				err = -ENOMEM;
+				goto restore_holder;
 			}
 		} else {
 			org_mount_opt.s_qf_names[i] = NULL;
@@ -2645,6 +2646,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	sbi->mount_opt = org_mount_opt;
 	sb->s_flags = old_sb_flags;
 
+restore_holder:
 	sbi->umount_lock_holder = NULL;
 	return err;
 }
-- 
2.53.0




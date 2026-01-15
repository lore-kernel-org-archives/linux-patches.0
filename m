Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C74337C117;
	Thu, 15 Jan 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496651; cv=none; b=iXDCzZ8q0yL2pvTdGLXryvsAXrBNRMhayqRAf7ZMAXfFsksLYvS5B0IS90UIR7sTZDyEgeqkoNQqVWkKBei29xKJijnrASoxLPWdORRyxI+plvhY0HatGGucrdsR+FYR37WNMFc2hadICJfateduClRBdd0/2a51Hp5MUK4SisU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496651; c=relaxed/simple;
	bh=G5SiDd4L0LPoj3oO3UIekDeXxyY3L3BkqnI5BwJEOWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhxxE3zWQbFlUUl7lteQd4nUBLywRDayjo77l2Hzb6U8a7awFJg5yP09lFMB00YDTaejj4WnGb9/ktysjmayq2ZMDF99bXB+3fJeAEpuO0p3O7M8ohGyGj/0vmIklo5psdIFRcA4qL/Tts2qyCTVi81T5rtl85VtYGWHIpZ0ZtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoECP6v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoECP6v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1176EC116D0;
	Thu, 15 Jan 2026 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496651;
	bh=G5SiDd4L0LPoj3oO3UIekDeXxyY3L3BkqnI5BwJEOWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SoECP6v3cxEfs7a1ONJ3t6udwKKYCX2+AdX5ZbL0nhl2WTTfpSDC0yRSHmvjicJql
	 8rCCOtCOCww44x51jlHpnhGPIoZGWOU9cWXThJFS3TCls3sgRZQyoJ9AdP5lqzWoyz
	 sBHxp9vjFyQWtL0F4wDAnEaFs33cfqaFmXfQVWHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/119] erofs: fix file-backed mounts no longer working on EROFS partitions
Date: Thu, 15 Jan 2026 17:48:22 +0100
Message-ID: <20260115164155.089639501@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 7893cc12251f6f19e7689a4cf3ba803bddbd8437 ]

Sheng Yong reported [1] that Android APEX images didn't work with commit
072a7c7cdbea ("erofs: don't bother with s_stack_depth increasing for
now") because "EROFS-formatted APEX file images can be stored within an
EROFS-formatted Android system partition."

In response, I sent a quick fat-fingered [PATCH v3] to address the
report.  Unfortunately, the updated condition was incorrect:

         if (erofs_is_fileio_mode(sbi)) {
-            sb->s_stack_depth =
-                file_inode(sbi->dif0.file)->i_sb->s_stack_depth + 1;
-            if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
-                erofs_err(sb, "maximum fs stacking depth exceeded");
+            inode = file_inode(sbi->dif0.file);
+            if ((inode->i_sb->s_op == &erofs_sops && !sb->s_bdev) ||
+                inode->i_sb->s_stack_depth) {

The condition `!sb->s_bdev` is always true for all file-backed EROFS
mounts, making the check effectively a no-op.

The real fix tested and confirmed by Sheng Yong [2] at that time was
[PATCH v3 RESEND], which correctly ensures the following EROFS^2 setup
works:
    EROFS (on a block device) + EROFS (file-backed mount)

But sadly I screwed it up again by upstreaming the outdated [PATCH v3].

This patch applies the same logic as the delta between the upstream
[PATCH v3] and the real fix [PATCH v3 RESEND].

Reported-by: Sheng Yong <shengyong1@xiaomi.com>
Closes: https://lore.kernel.org/r/3acec686-4020-4609-aee4-5dae7b9b0093@gmail.com [1]
Fixes: 072a7c7cdbea ("erofs: don't bother with s_stack_depth increasing for now")
Link: https://lore.kernel.org/r/243f57b8-246f-47e7-9fb1-27a771e8e9e8@gmail.com [2]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index f0b83beec6b24..bc968cf812bac 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -652,7 +652,8 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 */
 		if (erofs_is_fileio_mode(sbi)) {
 			inode = file_inode(sbi->dif0.file);
-			if ((inode->i_sb->s_op == &erofs_sops && !sb->s_bdev) ||
+			if ((inode->i_sb->s_op == &erofs_sops &&
+			     !inode->i_sb->s_bdev) ||
 			    inode->i_sb->s_stack_depth) {
 				erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
 				return -ENOTBLK;
-- 
2.51.0




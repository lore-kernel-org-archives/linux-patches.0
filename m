Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FDE24C098;
	Tue, 29 Apr 2025 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945485; cv=none; b=A6XQrUdn9VILrjPj2G0DSyv8q0vNtUF7wLmeJaxiMB2Xsnm2+Fkz9k6hbl87fFkkV4T6bQrcwh/I9VC06uoJiE4B/6QAEFAKZ6P0fJUFIMTqfNvuNbp7nkPNm8QqW9UIc0T08HL1y5LCU53BIMDFtrmy9bYHG5vDyaem7RcW1HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945485; c=relaxed/simple;
	bh=ALIXlGWH/0VgRKXXNWE+r5ycZGXEaGHJAwvElIdQBoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTG3l2RTzY4DuvgzlqJ+9W6cfn4Ujjd4iRFm0zB6Ef698DwWxpBuvY/yEU1Iv6nHdwPfyTNYCG9zVhDGP0QYGFQI4KviyU4mmHctADvhreJv0JgZjzgsC6nbMDO/CqcBgpKAxoydsBsnq8rFcnpOJiMMOIyzIEbSbb7/2lOzPhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfR+NrU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfR+NrU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351A7C4CEE9;
	Tue, 29 Apr 2025 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945485;
	bh=ALIXlGWH/0VgRKXXNWE+r5ycZGXEaGHJAwvElIdQBoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfR+NrU3x09g0VnQtmNC/5t4LXkVn5ESPj0FSLlGofQ3UGj+Uuu06KP7fGIvz31ii
	 87C8jrlNjMasPdMSQxZA/VkphkRUt8n77BhoPcq1tMD6YKePKMR9/dqTZiYKF3WDpN
	 uDLWdS99s9V7E2szXD72FbNiuqCI/WNkOxP5HBsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengguang Xu <cgxu519@mykernel.net>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/179] ext4: code cleanup for ext4_statfs_project()
Date: Tue, 29 Apr 2025 18:41:10 +0200
Message-ID: <20250429161054.611448291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit a08fe66e4a0e12a3df982b28059f3a90e0f1b31e ]

Calling min_not_zero() to simplify complicated prjquota
limit comparison in ext4_statfs_project().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Link: https://lore.kernel.org/r/20200210082445.2379-1-cgxu519@mykernel.net
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: f87d3af74193 ("ext4: don't over-report free space or inodes in statvfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8675b4dcc899d..332849e17b2bd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5680,10 +5680,8 @@ static int ext4_statfs_project(struct super_block *sb,
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = dquot->dq_dqb.dqb_bsoftlimit;
-	if (dquot->dq_dqb.dqb_bhardlimit &&
-	    (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
-		limit = dquot->dq_dqb.dqb_bhardlimit;
+	limit = min_not_zero(dquot->dq_dqb.dqb_bsoftlimit,
+			     dquot->dq_dqb.dqb_bhardlimit);
 	limit >>= sb->s_blocksize_bits;
 
 	if (limit && buf->f_blocks > limit) {
@@ -5695,11 +5693,8 @@ static int ext4_statfs_project(struct super_block *sb,
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = dquot->dq_dqb.dqb_isoftlimit;
-	if (dquot->dq_dqb.dqb_ihardlimit &&
-	    (!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
-		limit = dquot->dq_dqb.dqb_ihardlimit;
-
+	limit = min_not_zero(dquot->dq_dqb.dqb_isoftlimit,
+			     dquot->dq_dqb.dqb_ihardlimit);
 	if (limit && buf->f_files > limit) {
 		buf->f_files = limit;
 		buf->f_ffree =
-- 
2.39.5




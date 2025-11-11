Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36094262FEC;
	Tue, 11 Nov 2025 01:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824408; cv=none; b=VbWO2v1Z1H9oTD72phhRlRcA5o4y4aCcd04kSlzhbSy/D0OqHhbW41csGr2jfWvFQ3z7epIHycjTHhl+qJi8ydGIk7XYod3YuBMeQeXI9xhTQjCpkamieEaOMpvIoc2yesNVBEygkZ3kFQ4apXT1FfLzOA3D1hQugVYLl+n4FwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824408; c=relaxed/simple;
	bh=uAyiYIfBEcEIaw7Xk7TWT+4tpUHPT28ZQtDD6LoOWS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJlfeYoYm1AynCh1IdhV/A3vJBAlHPeIbh8Ft3kXqZAM4cqTTqFnKmj09gnYRDUgVHWF0O7xGhTLPX6id0ne/GqOiIVQSIp//etwLp0/HnEwUWFBKCFpaY2GdXcU+lQgbmlsImxss1Jkfl8yqFjmcBLvzpneQiKQXa2eZHSJPkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Rgvv8jQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Rgvv8jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2730C19421;
	Tue, 11 Nov 2025 01:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824408;
	bh=uAyiYIfBEcEIaw7Xk7TWT+4tpUHPT28ZQtDD6LoOWS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Rgvv8jQhRmDNPbaNQXUctnYDOCgZrjYhLimjUFsQ8qynIdurRW7Ce75FmUF0hwWL
	 4lHkbKLUxLqmTKRjlrYvH4Fext7LdHRCojnAlnurmR9J2Gt0Sf0wlqgToCLs/4JDfn
	 t4bKd4cLeLctJ5wOgckse+6cG7iwZgRQdW7TAuz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 489/849] f2fs: fix wrong layout information on 16KB page
Date: Tue, 11 Nov 2025 09:40:59 +0900
Message-ID: <20251111004548.263015750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit a33be64b98d0723748d2fab0832b926613e1fce0 ]

This patch fixes to support different block size.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index f736052dea50a..902ffb3faa1ff 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1723,12 +1723,15 @@ static int __maybe_unused disk_map_seq_show(struct seq_file *seq,
 	seq_printf(seq, " Main          : 0x%010x (%10d)\n",
 			SM_I(sbi)->main_blkaddr,
 			le32_to_cpu(F2FS_RAW_SUPER(sbi)->segment_count_main));
-	seq_printf(seq, " # of Sections : %12d\n",
-			le32_to_cpu(F2FS_RAW_SUPER(sbi)->section_count));
+	seq_printf(seq, " Block size    : %12lu KB\n", F2FS_BLKSIZE >> 10);
+	seq_printf(seq, " Segment size  : %12d MB\n",
+			(BLKS_PER_SEG(sbi) << (F2FS_BLKSIZE_BITS - 10)) >> 10);
 	seq_printf(seq, " Segs/Sections : %12d\n",
 			SEGS_PER_SEC(sbi));
 	seq_printf(seq, " Section size  : %12d MB\n",
-			SEGS_PER_SEC(sbi) << 1);
+			(BLKS_PER_SEC(sbi) << (F2FS_BLKSIZE_BITS - 10)) >> 10);
+	seq_printf(seq, " # of Sections : %12d\n",
+			le32_to_cpu(F2FS_RAW_SUPER(sbi)->section_count));
 
 	if (!f2fs_is_multi_device(sbi))
 		return 0;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6426E3043CD;
	Tue, 11 Nov 2025 01:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823856; cv=none; b=MgJ8Yl+HTq+0bBog/YSjqBd8j9fYPHROHQoVQnlD3g4AfdhX8iugSfi1q/i+5ngpkkZAyWLHOegQOGQ9evX4OlWPERarSI4Mr5l0tsMl5z/wqBs/r6lzCIX1CwH5foUTMlu0GHfwyCn51k4Hh+6rb5cvN4QUaUC2KvrQfOteQsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823856; c=relaxed/simple;
	bh=vRRlQZzaLxiowKK6nPmemeLZxI7aMYpZm/sTYx2w0eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0U2DqEGVJd9k4cwjdZ2zK2FD9ssa8iQ2nEmr+7336uUlmQg3T0eZeYuYUZ/95+MJnsEm8SiTBP49r4lESxlvfxU8TQOYx0u/4JIwL6q5CwCT3OU8nIaIknZ93WskQPJSNBMZF1vhsJbpz8lDUzhiIeQM1pYGPwRNp3Zg1Jlfa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deNIwrM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deNIwrM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040A2C16AAE;
	Tue, 11 Nov 2025 01:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823856;
	bh=vRRlQZzaLxiowKK6nPmemeLZxI7aMYpZm/sTYx2w0eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deNIwrM0NWRbFr5qkj1GlCrQmbma1XZ0OocctFAjIq5GpTaOK9UKPwBX41rZnrkd7
	 gmNf0CU0aj/7rhh+IZzeQMdF3XxNEUInp1EP8bMt1VPplocioNo0RO6ksSsOylDi//
	 kcBypWNYlUq9H+XXhG3PbYmooYxou+Vt+sgZEAMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/565] f2fs: fix wrong layout information on 16KB page
Date: Tue, 11 Nov 2025 09:42:56 +0900
Message-ID: <20251111004534.085893959@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index eb84b9418ac11..b3c04ecc3a271 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1623,12 +1623,15 @@ static int __maybe_unused disk_map_seq_show(struct seq_file *seq,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14188196C82;
	Thu,  6 Jun 2024 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682914; cv=none; b=Q5v/V04BF6Ytt3vJoBEv2Xjr/sZjM4Jdrz6O59XvtccNzZI3sYxMXdLrLMpP5vB/DcE5ozbmc09/KpRm6Zh64uKq6ryUPWrAACAHaUi5OtPsUGND+RNy/2U5hcc8A8AGZS2WSD/cPn5FIA+TKp+q/LsYF+Rse0+1bAiohbdGb20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682914; c=relaxed/simple;
	bh=sC12CiwjT8nBssSBMWZpY35a2mZaj7WOEI6RJR6+n+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjmcKy/GcPzi4GyuctaBkLeUTJYdwoO8vpu4pemcaZi42LyH7ZK3cnn2XUAJXF5q4is3licUF4M9uOaV35hybnjaMO6QOSmbOnjZKJpRBfYIeaEySIKy0h6ASPOwpBj6wBqJ5n/i4k8MRECugtCoRSoB+9YWqzHD9koNQbIc4uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6mngphV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6mngphV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D3AC2BD10;
	Thu,  6 Jun 2024 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682914;
	bh=sC12CiwjT8nBssSBMWZpY35a2mZaj7WOEI6RJR6+n+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6mngphV/kMCXVD+1XwA+F66EWQkYlAyJzgtLr39CyXmQ39ALIaoUBFmIbw/oCuxG
	 /nMFXTJ/qZWq801E8cIJsL4ZuXvbXmNT06XGJZBxXL8pHBtl6CHjMT98wauBARaz76
	 OoJBoVFRtwkKSs1IWZ2ApnjdNbmwhK6eS29suKTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 044/374] f2fs: write missing last sum blk of file pinning section
Date: Thu,  6 Jun 2024 16:00:23 +0200
Message-ID: <20240606131653.288826677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit b084403cfc3295b59a1b6bcc94efaf870fc3c2c9 ]

While do not allocating a new section in advance for file pinning area, I
missed that we should write the sum block for the last segment of a file
pinning section.

Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 4fd76e867e0a2..6474b7338e811 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3559,6 +3559,8 @@ int f2fs_allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	if (segment_full) {
 		if (type == CURSEG_COLD_DATA_PINNED &&
 		    !((curseg->segno + 1) % sbi->segs_per_sec)) {
+			write_sum_page(sbi, curseg->sum_blk,
+					GET_SUM_BLOCK(sbi, curseg->segno));
 			reset_curseg_fields(curseg);
 			goto skip_new_segment;
 		}
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494811E52C;
	Wed,  2 Oct 2024 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878876; cv=none; b=dZVdq2irYIE/SQjIoKD6i70LMovRC7tXUzKGQf7+oqXAJovW5vEh8rvhZwpHudcmuW9QdH5otNodOCsSYDSvffIzpXUCLxK8oZA3lZUvVlErStSnwEB2WBvQ7uMPnvOJfEiScKm/qSgI+s8XxCVZ9VggDz44AAeDkODjo8E8BfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878876; c=relaxed/simple;
	bh=iYVpp+ZGtTkqmvBeW/EsUNA1tvF/3bbbBfkwQjUOHS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUkDBssu8q5Ds835lmNPOs7lzuNCR3ZAaG+RlNWLbOYnCmq+3SJnNDpJn3H4jAq+TNzjPzFZZmyMEMRlaJ0xE2tIXo9xxebcLi0kU+GpfoMfWgu/RAn8Y96T18rZYjSW7fs9cHDylvmOctX+DtJCDiTQsQLFXeJ306AqqsDPrvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0a4v4hX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0a4v4hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B72C4CEC5;
	Wed,  2 Oct 2024 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878876;
	bh=iYVpp+ZGtTkqmvBeW/EsUNA1tvF/3bbbBfkwQjUOHS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0a4v4hXRMi7gcPdX+hHgjGb+sd7AhqzGL5YQaz4y7kGRWBLCseg0HYJpwpGTnkg/
	 P2clAQnfN1xVblP2q8nSQIZry71uryz4TqdAkNd9c/cbwHVNhucCW2ogcUVhfuGA+7
	 YePuWpNnRAUDab7oEAvnfOMXm4Xm18LRiRiOJJPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.10 562/634] f2fs: avoid potential int overflow in sanity_check_area_boundary()
Date: Wed,  2 Oct 2024 15:01:02 +0200
Message-ID: <20241002125833.299014000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 50438dbc483ca6a133d2bce9d5d6747bcee38371 upstream.

While calculating the end addresses of main area and segment 0, u32
may be not enough to hold the result without the danger of int
overflow.

Just in case, play it safe and cast one of the operands to a
wider type (u64).

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: fd694733d523 ("f2fs: cover large section in sanity check of super")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3366,9 +3366,9 @@ static inline bool sanity_check_area_bou
 	u32 segment_count = le32_to_cpu(raw_super->segment_count);
 	u32 log_blocks_per_seg = le32_to_cpu(raw_super->log_blocks_per_seg);
 	u64 main_end_blkaddr = main_blkaddr +
-				(segment_count_main << log_blocks_per_seg);
+				((u64)segment_count_main << log_blocks_per_seg);
 	u64 seg_end_blkaddr = segment0_blkaddr +
-				(segment_count << log_blocks_per_seg);
+				((u64)segment_count << log_blocks_per_seg);
 
 	if (segment0_blkaddr != cp_blkaddr) {
 		f2fs_info(sbi, "Mismatch start address, segment0(%u) cp_blkaddr(%u)",



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192C317B421;
	Wed,  2 Oct 2024 13:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877098; cv=none; b=nIC3k6SdpJzq89d3AW1V1vE3tFvYOHJCZxWrTZbSWkuZFCZvv4DuupeMCZTvBxUmMUdz6Oshi9vU4Ck2fijhFuIZqN6jXMnS+MoVLgOo9SLu3XA8wyTNEqLNH4LSRjdu/iYzYqIsK5hWELLQAPO1V5vjFmLdiznoI5/PKhdL/2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877098; c=relaxed/simple;
	bh=TamZZkQbnRrTGmx7ByxEAP7uCrU/iMKlvm7sC0T3KIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZV8JoHB2mma3v6LYrMQc0+MpTOvrfJJAY3Bz+FtljLU7+F7E8muih/zGP7L+/H2gnv4YTSdPclM3v+RxMgug0y9smBb3PKmvQVl5KWwdHwV2mJjivxWKq5v7vZynozDQjkcW8tExMjAW34kJ5Yv3O5lEgEDI4rT5kya9d44dc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+dipPkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+dipPkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44297C4CEC2;
	Wed,  2 Oct 2024 13:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877097;
	bh=TamZZkQbnRrTGmx7ByxEAP7uCrU/iMKlvm7sC0T3KIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+dipPkWwvESkSJcKdzrwKVX0wyB7s4g6rgzJ9wgSKcYFD+ZEboegLUqliEhnqDcG
	 hg512pE81o3B35dpeUD9qcQcqVIqQ6Wm61h5cukxNYeu6qgJNTZ/2RXEgPCzfYeXUb
	 Fhc/EfGB81xQnhCeNsIWe2ZUfz1bGLEjbqLTa0aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.11 632/695] f2fs: avoid potential int overflow in sanity_check_area_boundary()
Date: Wed,  2 Oct 2024 15:00:30 +0200
Message-ID: <20241002125847.742144133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3356,9 +3356,9 @@ static inline bool sanity_check_area_bou
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



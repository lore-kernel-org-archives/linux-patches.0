Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CEA1D0492;
	Tue, 15 Oct 2024 11:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993195; cv=none; b=t1lB6M7soM8r+NveMVIxvRBzZwyvuG4iswTNRFswU1FD/cet07EMgy8HqpB9LgFqzzjyoZCZdB+hqiDnlR7i2iQ+gRtqZPRUPoldi2cCHMksEFcUSStTS8kxcH0FbogaMNhhMpycuacvip9dF8fVlmMA/HkgEeKaOyQpUjXy85c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993195; c=relaxed/simple;
	bh=QfogUwaODumDAFbfKEEsCyR8sjhs1wta9X7oEku4R84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqUWIyGjofjoZJVqJGnnGZZhU1j0BmcLP7tjgIhM/maD0Gzak4FoLvy0omlpSH/TOqdFsjFIHC7AiCT5CGkDL/BQe63ULQ6FK7dHQJzujMTEbOwITIPLRA0HrO43lsOy3k7C7yvyh+bGGaFRNGKUPNtnVknfjbQ4Cjy55vUk4rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNfXkCun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNfXkCun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB73C4CECE;
	Tue, 15 Oct 2024 11:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993195;
	bh=QfogUwaODumDAFbfKEEsCyR8sjhs1wta9X7oEku4R84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNfXkCunBV3lga2Z8KsjDjxnbq5Cajd2ghTgkrvJNtIlw+whZNiVqHetoNh2LM++G
	 0Rq8clsFMNW2Wahx4aaTTnyLE9XIXoYM3pRHfRCvHTMZZND5tdg7qByLKyDjFzxwhL
	 ZkZDJ/HLopdPpsGT7VkhC2HQgEQdN1JETaWMtn3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 339/691] f2fs: avoid potential int overflow in sanity_check_area_boundary()
Date: Tue, 15 Oct 2024 13:24:47 +0200
Message-ID: <20241015112453.796148028@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3181,9 +3181,9 @@ static inline bool sanity_check_area_bou
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



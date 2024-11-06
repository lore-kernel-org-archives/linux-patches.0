Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EC31D416E;
	Wed,  6 Nov 2024 12:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895136; cv=none; b=BoZGOKUpe3Yl+ycLMxbi5WsRhIGNTCcXsZ7RPAEliLh4NLbe3Yo9H/FBzLg0b3pbgbvmFHD54LEcZvmpGhp8F5bZTKTBZRfHhmLe6z0unjSCB39IlpcrJVrrPFIxf0MJS9JDmPWItkueICPCo4+H7GPocH2ofguQgsE8SKU0PJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895136; c=relaxed/simple;
	bh=IeWew+qQvgLVcBZWKph6PRVUfCZUPe14uvDLUMmwFj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVMsMARb2Nox9iQk02p0DbNgcWCbbMXi9wXCQfnfKSmaSsNv78T994nLNyBYwWXABweLiJmhkBEu/i3loTv7fdeX39W+dslCFmZbhwANrXMRyyfOwvjKlXOTOUnd2zdNAYm+lpqR5Sm/b1HpjB8dj35T2aA6+O6Yoz6exbAcgVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zk3Vd3IF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zk3Vd3IF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00B2C4CECD;
	Wed,  6 Nov 2024 12:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895136;
	bh=IeWew+qQvgLVcBZWKph6PRVUfCZUPe14uvDLUMmwFj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zk3Vd3IF1bphXJgo2sx21bLahHePkJjkifavyY5FterFAfElmcMGZNXm/Vh0RFat0
	 hD0Xco29yxdwdsuhpbSv/0uSlNfm/bl5V97pxe5CDU/L7JeVX4uwoxf2zS2FWSGo9X
	 Z4mtnzTiOWX0j7LPGH3NEUAJjKBk4X7PLxmLuGsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 117/350] f2fs: avoid potential int overflow in sanity_check_area_boundary()
Date: Wed,  6 Nov 2024 13:00:45 +0100
Message-ID: <20241106120323.795025870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2116,9 +2116,9 @@ static inline bool sanity_check_area_bou
 	u32 segment_count = le32_to_cpu(raw_super->segment_count);
 	u32 log_blocks_per_seg = le32_to_cpu(raw_super->log_blocks_per_seg);
 	u64 main_end_blkaddr = main_blkaddr +
-				(segment_count_main << log_blocks_per_seg);
+				((u64)segment_count_main << log_blocks_per_seg);
 	u64 seg_end_blkaddr = segment0_blkaddr +
-				(segment_count << log_blocks_per_seg);
+				((u64)segment_count << log_blocks_per_seg);
 
 	if (segment0_blkaddr != cp_blkaddr) {
 		f2fs_msg(sb, KERN_INFO,



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D2334167B;
	Tue, 16 Dec 2025 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888430; cv=none; b=kck/S8p6tT+Nfh+psbhqdgOV0Op+NOtuEvQVsOQ2pEWv8i+ecLgIJM2nuIyKJyW+bExhACFxnTVsyZQgjPASkW8FOpKaTcebx97E1jUbECpbDuAxnsBAUxRaaQ4D++uDiTog0dwtcWdAYun+8Ut3m52jzWuCEfMsNpZ+aqIKc+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888430; c=relaxed/simple;
	bh=JpBgv/w2jiHxZLqQ/EIwgwyGFkHyu4q35xsUVTjwyOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKhN8kWibRbg2ZcGSK7BiC6IDP71XtELMMJj+olWlWAC4ABsxCHoBB8a38TH+Z6aKZIXaMFaFzH8S5dQFcUpooFELGrBn9o6HAINTIifbiAWwKvs7xb93AnjzGGWcjdv9DuqBEroXW4qCu8mINDkG0cOxfmufA95yEfLOZtsMjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggkdF2Fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggkdF2Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0125CC4CEF1;
	Tue, 16 Dec 2025 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888430;
	bh=JpBgv/w2jiHxZLqQ/EIwgwyGFkHyu4q35xsUVTjwyOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggkdF2Fwvu1j++4ehtgrSKu1G+H+XRgPeZpD6gCb/w5/k9HSvBTFpfS82UHKZiNp8
	 qlixBoE88CwE0tsFUQG4dTXkE2QBiTLrnuF/4cC1hf/pEcB3oo3GizcYpJ2j8t+tg6
	 OccE+pO2y5wqed2nGaTLou4tWKjosiJtLXSE0BEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 525/614] exfat: fix divide-by-zero in exfat_allocate_bitmap
Date: Tue, 16 Dec 2025 12:14:52 +0100
Message-ID: <20251216111420.397652317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit d70a5804c563b5e34825353ba9927509df709651 ]

The variable max_ra_count can be 0 in exfat_allocate_bitmap(),
which causes a divide-by-zero error in the subsequent modulo operation
(i % max_ra_count), leading to a system crash.
When max_ra_count is 0, it means that readahead is not used. This patch
load the bitmap without readahead.

Fixes: 9fd688678dd8 ("exfat: optimize allocation bitmap loading time")
Reported-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/balloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 2d2d510f2372c..0b6466b3490a0 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -106,7 +106,7 @@ static int exfat_allocate_bitmap(struct super_block *sb,
 		(PAGE_SHIFT - sb->s_blocksize_bits);
 	for (i = 0; i < sbi->map_sectors; i++) {
 		/* Trigger the next readahead in advance. */
-		if (0 == (i % max_ra_count)) {
+		if (max_ra_count && 0 == (i % max_ra_count)) {
 			blk_start_plug(&plug);
 			for (j = i; j < min(max_ra_count, sbi->map_sectors - i) + i; j++)
 				sb_breadahead(sb, sector + j);
-- 
2.51.0




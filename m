Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018D5149E1A;
	Fri,  6 Dec 2024 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498549; cv=none; b=V6Ibse/p+kqSt1bnstwGwnAxNfRDP5IMUmjEKzQ56EW+W/YaNFnRix4t1A9Jx/QiCcCHwVItyL0MSUd+Zo/7UulIdIigKixjksqbSCbKTPxpkuOWSzdEqgA2GCp9x6o1R9ji7u1wN0nexx8xI7P9k+IF+0w2vaNRapJO3oluuWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498549; c=relaxed/simple;
	bh=oB8hr/c2KMd6tzO0LEl5NF/p1Fo1NA7CZyCrumZJyhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q21L8P8kJlTHJNLFrXIwD5NJNhicDjlVolTX4DCsnbr0g6Ds2927/3NLXoGpamZ2B3Eg85//wLQ23rcd0sqDGVM5Zzg4HYmcId0OpZe165W5uVNKLj/qRkHEQF9xIj0lxrS/CCeczXIAJvaj9LLu6YxpiOAi3EJ+hRN+3dvAsCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cR6Nk5Xi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cR6Nk5Xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64001C4CED1;
	Fri,  6 Dec 2024 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498548;
	bh=oB8hr/c2KMd6tzO0LEl5NF/p1Fo1NA7CZyCrumZJyhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cR6Nk5Xi+ko5UVFYDRXF4eJRDmBVAi6xL+A2swLMgwnXmZcc5RH9iAKgptrNuWDZF
	 h+mbR8z11ks/eXtywor58xrf1CePUhQWtsEDSutmXbIxS8ZMqTMnzajswE0OY8Tfxs
	 acQmFhHSaMzqJEr6aPIFsGVYCy+2AswsUr2UPtNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 616/676] media: verisilicon: av1: Fix reference video buffer pointer assignment
Date: Fri,  6 Dec 2024 15:37:15 +0100
Message-ID: <20241206143717.432917298@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

commit 672f24ed6ebcd986688c6674a6d994a265fefc25 upstream.

Always get new destination buffer for reference frame because nothing
garantees the one set previously is still valid or unused.

Fixes this chromium test suite:
https://chromium.googlesource.com/chromium/src/media/+/refs/heads/main/test/data/test-25fps.av1.ivf

Fixes: 727a400686a2 ("media: verisilicon: Add Rockchip AV1 decoder")
Cc: <stable@vger.kernel.org>
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil: fix typo and add link to chromium test suite]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu981_hw_av1_dec.c
@@ -161,8 +161,7 @@ static int rockchip_vpu981_av1_dec_frame
 		av1_dec->frame_refs[i].timestamp = timestamp;
 		av1_dec->frame_refs[i].frame_type = frame->frame_type;
 		av1_dec->frame_refs[i].order_hint = frame->order_hint;
-		if (!av1_dec->frame_refs[i].vb2_ref)
-			av1_dec->frame_refs[i].vb2_ref = hantro_get_dst_buf(ctx);
+		av1_dec->frame_refs[i].vb2_ref = hantro_get_dst_buf(ctx);
 
 		for (j = 0; j < V4L2_AV1_TOTAL_REFS_PER_FRAME; j++)
 			av1_dec->frame_refs[i].order_hints[j] = frame->order_hints[j];



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D79A4B7A4C;
	Thu, 17 Sep 2026 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660459; cv=none; b=pG1HiyE2gOqg2L+hUEj9ZunFxLy4GKPYBm9a+loJ+3eSg4AhA0G0xgEMxZbUzj8ZssJSZWX8ao30JvCObJeo88TuvxCqUDh417FRqj7gW2rCSF5HtXQ1xWexlexWu/bFxIweqIDWR7fjujfCWXS/gDkc13xhTcvYA0VH/YjE72Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660459; c=relaxed/simple;
	bh=fN5cCiFtCZyhpa+skmRr6QN7Ux0GgDp1lLWSh0Pl0bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naRvcLYuWkwbinp1ACRBb3+YL2Sxd7YkCOQiwaXORdkeGVagXF/86U6lSIWJCGhjwfn2UJX0gpiVCoVpmDxVr2gflCVoGd48kmJ04Xa7lfOivnBFkzA2DGRu9BeeiijZGBfEU7O8f4xLqZ9U63j7OFNCbdzZ5vVlAJIjYN7IFoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnliZum9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnliZum9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936C91F000FF;
	Thu, 17 Sep 2026 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660458;
	bh=IOWZga2PE0Ak7HzReu6peehVAamoSYkwIim8/DeQQkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnliZum9eYo1Lh3za6Kq9tjyxuZcTdw7DPQPRaJg0F4b7i1o6huUnmF+b0yICEwtT
	 hFnclfoQ6RYannNGYQnbeGuoxxzokV8p0Hxlk1+tnbtASvBT7gWZDZYsDUxIGmkWpr
	 TfEPxp2sGZX3W1VSrPUVw4CBj5DP7G+QnoDP4n64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 599/733] media: mediatek: vcodec: bound AV1 tile-start copy to the array capacity
Date: Thu, 17 Sep 2026 16:15:07 +0100
Message-ID: <20260917151407.385949737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 37bef2170d4c88fc3d708eecf3ef0f4032bc1372 upstream.

vdec_av1_slice_setup_tile() copies tile_cols + 1 / tile_rows + 1 entries
into mi_col_starts[] / mi_row_starts[] from the bitstream tile_info. Bound
the copy to the array capacity.

Fixes: 0934d3759615 ("media: mediatek: vcodec: separate decoder and encoder")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
@@ -1299,11 +1299,12 @@ static void vdec_av1_slice_setup_tile(st
 	tile->uniform_tile_spacing_flag =
 		BIT_FLAG(ctrl_tile, V4L2_AV1_TILE_INFO_FLAG_UNIFORM_TILE_SPACING);
 
-	for (i = 0; i < tile->tile_cols + 1; i++)
+	/* Bound the copy to the mi_col_starts[]/mi_row_starts[] capacity. */
+	for (i = 0; i < tile->tile_cols + 1 && i < V4L2_AV1_MAX_TILE_COLS + 1; i++)
 		tile->mi_col_starts[i] =
 			ALIGN(ctrl_tile->mi_col_starts[i], BIT(mib_size_log2)) >> mib_size_log2;
 
-	for (i = 0; i < tile->tile_rows + 1; i++)
+	for (i = 0; i < tile->tile_rows + 1 && i < V4L2_AV1_MAX_TILE_ROWS + 1; i++)
 		tile->mi_row_starts[i] =
 			ALIGN(ctrl_tile->mi_row_starts[i], BIT(mib_size_log2)) >> mib_size_log2;
 }



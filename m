Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BB44B44AE;
	Thu, 17 Sep 2026 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671130; cv=none; b=mM4OeeW+rin5Oj80DVPREofGnQ9TwjS2ZYLCH8Lpa1/GozfdsYkTe2ZwbnRKrB8tqMaTszseKZWihq+AzPOxNYkd9tEHn6ZgDiYkaMsrC/zZ5op0l4Xn8GZMafHx/naIsaZbZWWoavkueNR4oAmGqNQx0RBcLLCAepTWEiaPGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671130; c=relaxed/simple;
	bh=GZSKZbHTrwI+ojyEILcigQR1wSThe+jvrVhX9SgjIgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHN6LQx7bI76v2BTQXYQ5vIdcNTjGDIRncrQX/qebk0kcLUsSNQfIrBPCZskwUPdHGp7x0GlCVnds/vWF5hRCLOgYuuRqPdpXbIpmLNqXMS6AdKgnvEzV62lQ3wxUuNx96plCNbl0e7IrtJiG8no/IKIYtjulYP6NwGuBd5SRSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j23re8/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j23re8/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECD01F00893;
	Thu, 17 Sep 2026 18:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671129;
	bh=CKfvkvIvGXz8l+9wBoUlbVkRBXOhRrm7igqyxEEMJ9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j23re8/szGrnFRpwlXeNpHObxKI2rzEvbtGBMXvOJfslmbgGQjWAN0u59H4pZdSUN
	 m3mp2qDT3Tgj15hEeStBOsBO/nfbAm52xPp0mPwBwt+zG/xDYgnBV5tch03o7qc5cf
	 WXlldPNgN79/wqBRayzY7SV6VLskbysIdVWXoT8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0876/1102] media: mediatek: vcodec: bound AV1 tile-start copy to the array capacity
Date: Thu, 17 Sep 2026 16:13:39 +0100
Message-ID: <20260917151602.555294843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



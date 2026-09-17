Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C444B44D2;
	Thu, 17 Sep 2026 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666516; cv=none; b=X0Wil+XAS/h9g1vh3aKW9DQMtM6tE23HXqZimTmfbqNp1Hb17SpcU4EMXEGA/PrwqRJARwGjmkcO8YUOR9saj/THkoEMtSRRDNoMpMdFtUTHRIweH+/thq+VAjWMlOt91cJTUWCXfxa+4pkbyl7j6AvnSJNVOQ2bQhkJ9pDhthc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666516; c=relaxed/simple;
	bh=q8Dp5XAgd/2Z5rcFpjz5TOJn/dnqn7spjuYIxe21PF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcudBAu7xPRhIIQFyaxmRuff+erKxjZxakcaLAGVp+3ljOpRodpnctnRnvVdGBLDGYD1FAFognSpbr7gB80qG7pVy6Uew66RRRBdSe2NS3GjdScSto98z3RKaGuNgncIAhz3tQWRb4633XXWEuHnRLAca/6OkRFO96/3FFOTyZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKHgJ61Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKHgJ61Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5E21F000FF;
	Thu, 17 Sep 2026 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666515;
	bh=VOkarU040Fh0XVfowLAkjvFRHEqJL/Ot1a5QNZQ4wPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKHgJ61Z2NSo8/RgqcRKSp/gOe9eobkHWqirqNaaDcOmAQXLFuj9chOY50E5k6FBu
	 of663FHWqSC70xjNkv9xqk1mARKNQVnsPOlOD2WSBjzY8zZj7fBPDEf7wuCahFdTEN
	 wQTNzyokRDchGrJqpL8CjMLsjni+CtVL6bvAvLU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 1061/1250] media: verisilicon: hantro: bound G2 HEVC tile loop to the buffer capacity
Date: Thu, 17 Sep 2026 16:14:16 +0100
Message-ID: <20260917151620.879709204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 06236b094c899c22c12ac5097935eb6719293de8 upstream.

prepare_tile_info_buffer() writes one entry per tile into the tile_sizes
DMA buffer, sized for a grid equal to the PPS uAPI array capacity. Use the
bounded v4l2_hevc_pps_num_tile_columns() / v4l2_hevc_pps_num_tile_rows()
helpers so the loops stay inside the buffer.

Fixes: cb5dd5a0fa51 ("media: hantro: Introduce G2/HEVC decoder")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
+++ b/drivers/media/platform/verisilicon/hantro_g2_hevc_dec.c
@@ -5,6 +5,8 @@
  * Copyright (C) 2020 Safran Passenger Innovations LLC
  */
 
+#include <media/v4l2-hevc.h>
+
 #include "hantro_hw.h"
 #include "hantro_g2_regs.h"
 
@@ -15,8 +17,8 @@ static void prepare_tile_info_buffer(str
 	const struct v4l2_ctrl_hevc_pps *pps = ctrls->pps;
 	const struct v4l2_ctrl_hevc_sps *sps = ctrls->sps;
 	u16 *p = (u16 *)((u8 *)ctx->hevc_dec.tile_sizes.cpu);
-	unsigned int num_tile_rows = pps->num_tile_rows_minus1 + 1;
-	unsigned int num_tile_cols = pps->num_tile_columns_minus1 + 1;
+	unsigned int num_tile_rows = v4l2_hevc_pps_num_tile_rows(pps);
+	unsigned int num_tile_cols = v4l2_hevc_pps_num_tile_columns(pps);
 	unsigned int pic_width_in_ctbs, pic_height_in_ctbs;
 	unsigned int max_log2_ctb_size, ctb_size;
 	bool tiles_enabled, uniform_spacing;



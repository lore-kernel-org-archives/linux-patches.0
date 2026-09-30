Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFA43D333C;
	Wed, 30 Sep 2026 19:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795692; cv=none; b=odQk8Zw1NieD8BLvcuAreb1BeWSfIikTFsbv2h/vtyB9qnLgKnxnq0A2IrooBt2yxyfUgCUuTCyMqCA8bKiD6TBaFgB0lvEIGi0SVwrpywimf4nqJDpF/Wh+9EWI/cjFMLeOKBQlgzRyerOE8UWFLXt/5xBtuubRMiZTfdrsazg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795692; c=relaxed/simple;
	bh=bzW1mMOPt3g1iXWuoSt/QRuOWVEzD0sOpZdGCnif4zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncdb8FOQFIcy5MLyzhjKcU7DJ6Z6aHtyOFBYiuVUYYcsezZt14AxO9cuu6uLU09ltD68bnJIEmWXCn+ikg5f1La73sq+aoHlVgFebxGdq+5TwKK3d0ajJyD+5AB6cdXmJ9JIbpYWt0fBX1MCiqIKArg4BqokqTJJ2tX4TJ6d4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TipEhkM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TipEhkM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086E91F000FF;
	Wed, 30 Sep 2026 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795691;
	bh=9mim+3gDY/uJNikZ5SGVHUdRr9CG+YDxysZrfS1mOwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TipEhkM1Y9aVqQJfZsre1RzzyPm9nzpPBlWQPi4fJ1V/9kVM3I5F2KxSvZHwvx1vl
	 a2tb+V+nyKoWZHsECntjpa8DnKlBJH8RBkmcqTJvC+zfMLg8YIA+qjUb5+QahCB4ET
	 OeGirRO/5O2feTAE0ZlEiMC+xVsRQJDl1obikY8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0649/1193] media: verisilicon: hantro: bound G2 HEVC tile loop to the buffer capacity
Date: Wed, 30 Sep 2026 17:22:13 +0200
Message-ID: <20260930152448.665261443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



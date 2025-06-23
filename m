Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BCB22257E;
	Mon, 23 Jun 2025 21:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713504; cv=none; b=P7x4kde4SAgNizZWP1dWWIq1G6uGCwhHolYl/NJTOdB/tpJiT67wOFVnNqXGaz3gV/fjEtftclDjGpzt19iLMgxzRfsdnASudU5Tii2YYemVnsXvUoSv48Z2i9QaBZcZGxdYzKihL5RLUJ3O9+kpqYNo+BxOrUhDFuBfQ4XqDgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713504; c=relaxed/simple;
	bh=zs0f2cevaVHNV0z9+hvP0+BrXBt7EerfeBZc9MUVYW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc1PO1Hxlot8qgu1d+DHhsj33FAnv2KsyE4IayAHSOrGCIz1kjifo6TOVwKHH8mqyZ6h8BOvEP5CmAd+rFwbwnzpFJjjt7CoYqmM1IDWRfqVP1ZEEKButdYj8fApu7u/OnfFYewJ4byIQJDDr2aPRxO9bchR3YaApgYl+yfGao0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBW/BK3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBW/BK3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25F4C4CEED;
	Mon, 23 Jun 2025 21:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713504;
	bh=zs0f2cevaVHNV0z9+hvP0+BrXBt7EerfeBZc9MUVYW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBW/BK3ZELJ/qHFcWQvcxzeQelpy9/0sKVPTctoH1fpMPbNi44A9enan7cgPfKtEN
	 NtyFgJ1NyriqSgwVty8LxQRykeV4x1/IXF+GTCYmJqB+vJmiTSZ5ypguSwggqwT3K8
	 B2nGklbUwjzXZgskgicLiTPnWXJ2Sdt2Hl14cCYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 067/414] media: imx-jpeg: Reset slot data pointers when freed
Date: Mon, 23 Jun 2025 15:03:24 +0200
Message-ID: <20250623130643.746926380@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Qian <ming.qian@oss.nxp.com>

commit faa8051b128f4b34277ea8a026d02d83826f8122 upstream.

Ensure that the slot data pointers are reset to NULL and handles are
set to 0 after freeing the coherent memory. This makes he function
mxc_jpeg_alloc_slot_data() and mxc_jpeg_free_slot_data() safe to be
called multiple times.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -758,16 +758,22 @@ static void mxc_jpeg_free_slot_data(stru
 	dma_free_coherent(jpeg->dev, sizeof(struct mxc_jpeg_desc),
 			  jpeg->slot_data.desc,
 			  jpeg->slot_data.desc_handle);
+	jpeg->slot_data.desc = NULL;
+	jpeg->slot_data.desc_handle = 0;
 
 	/* free descriptor for encoder configuration phase / decoder DHT */
 	dma_free_coherent(jpeg->dev, sizeof(struct mxc_jpeg_desc),
 			  jpeg->slot_data.cfg_desc,
 			  jpeg->slot_data.cfg_desc_handle);
+	jpeg->slot_data.cfg_desc_handle = 0;
+	jpeg->slot_data.cfg_desc = NULL;
 
 	/* free configuration stream */
 	dma_free_coherent(jpeg->dev, MXC_JPEG_MAX_CFG_STREAM,
 			  jpeg->slot_data.cfg_stream_vaddr,
 			  jpeg->slot_data.cfg_stream_handle);
+	jpeg->slot_data.cfg_stream_vaddr = NULL;
+	jpeg->slot_data.cfg_stream_handle = 0;
 
 	jpeg->slot_data.used = false;
 }



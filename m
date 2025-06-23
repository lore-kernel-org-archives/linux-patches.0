Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B2824BC07;
	Mon, 23 Jun 2025 13:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684484; cv=none; b=uwkYcSkBpcFVu4S6f5UpJ9ZE+bde91dvM4d97Gvw9lVp2Ckrq5bw5HfvZisaB2yBLefkWeJWdOuXCs7jM3dhkB9MoE2rQBorhzdBcMYPl3pY8Z99wf3qFNvnoLDUcJbTizzzUYC4+ySLIsXnrkEIyLEIrGi+HL+1aqG3xtjMnf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684484; c=relaxed/simple;
	bh=ZKoKDfc12niSpfoZu5yICu6cXkI7FLYfNprjYGbiKD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js+/21VjKi7LkR3nfklpYG471dzP+9/yAzBwNgwWLUQ5yPBpPr3/1BrTAnm2pyoBe8oaOmh7rRZFsFEK0vR/vO0pivlrv7FGNVUTKeB7B9NFIDeZfIl67m6mBEW4X9KG+uCG/lXXdHgSlikSx5KJn5aeTxNkF9Hx+Hz0v3nASr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FE7qaOmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FE7qaOmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD29BC4CEEA;
	Mon, 23 Jun 2025 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684484;
	bh=ZKoKDfc12niSpfoZu5yICu6cXkI7FLYfNprjYGbiKD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FE7qaOmE0vlb3aHzCFuu+FcyB4DjH1waGbvhMP+rmNN3ZOu44H5i9NXxLYLbdrVeG
	 RtZS1iDK4G3CDTgD/6KQZmjAUnzvL7kePo1x4CA2FLDq7uPNR1aUKz9m4qZCoK/fOq
	 qsjRHhB02Cdbts40fiPRZRnXgP+WT6Mj9x7rNx/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 087/592] media: imx-jpeg: Reset slot data pointers when freed
Date: Mon, 23 Jun 2025 15:00:45 +0200
Message-ID: <20250623130702.347557938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



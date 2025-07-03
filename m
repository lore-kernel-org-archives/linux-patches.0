Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677F315442C;
	Thu,  3 Jul 2025 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556003; cv=none; b=RdVtsaPdmbZEIia5/G1knA6rePcK096eaDMiU6PR4p/18LnQMLAWxA8H+340+Tq7Xbug4LuIKBO64ybhyQHpAIZle0VjE0XQMeegI87Wu66RVq6FaTHEpXIMG1zDfp+5wCElkK/tTAe/uS8vxKNBwYiwKBhiF1t3weAk7UP+5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556003; c=relaxed/simple;
	bh=N6a6dQwtF2MB1NfDqpXcKl61IHWm4KDJju5om5L8sXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOwIIAJwT2tGD6OjRNZwHsKCwTrRlV6MGwVaChXVmDLZ5CKmnR6HYc6VQgGO9K1a7xrK79Z8CVeYbHfTvBhJWou/Gp1j7kZwLqYoIEvOMmPSkybteXl8PbeDFBcEU92U9Kqh2MLhVp7xT5oauZlvxmw6EJ0itZ0KX+9f2AdmZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANwNz2hL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANwNz2hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99FAC4CEF2;
	Thu,  3 Jul 2025 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556003;
	bh=N6a6dQwtF2MB1NfDqpXcKl61IHWm4KDJju5om5L8sXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANwNz2hL7xi/ILg1B/qA9elFDExQFk7OZBv9H/ZmgrcX5XOUUqoV64bUzDRJZxEu5
	 KfePHtKAAvoTTTcnk1NvMwu8pOS01fZ2jmV+DczMkahVM5Qwj4Q+sY6bGgWS5sWQZ4
	 C6agZcsMkx7iFP0+JqeDwM9BMr0yoq3yZaN0faKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/132] media: imx-jpeg: Reset slot data pointers when freed
Date: Thu,  3 Jul 2025 16:42:14 +0200
Message-ID: <20250703143941.194401457@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit faa8051b128f4b34277ea8a026d02d83826f8122 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index bfab38eec3e64..3602324b254a6 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -491,16 +491,22 @@ static void mxc_jpeg_free_slot_data(struct mxc_jpeg_dev *jpeg)
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
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2458171B7
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C588CC433D2;
	Mon, 22 May 2023 19:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784364;
	bh=3RQ3NpkUvKvMX1Q9TThOfZqbeNUdpgUUkq+Yf3PtgjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEKofzya2y0//CGS7y1tSd0rpcnyLpzADU8AUsg4zii3xxAP01FnmM2Z26FnyGPMI
	 sHqsuvVe6ccZ3MNrXgh/nvhgy91ZTYxg7wiOD3I54bhTZw/OL+FJRwYjyzPS20IpA2
	 6hsOc1Yysi5kwHQVbM71o+UqUdg/npksBMca9Ez4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirela Rabulea <mirela.rabulea@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Kees Cook <keescook@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 057/364] media: imx-jpeg: Bounds check sizeimage access
Date: Mon, 22 May 2023 20:06:02 +0100
Message-Id: <20230522190414.222626164@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 474acc639fc8671fa4c1919d9e03253c82b6d321 ]

The call of mxc_jpeg_get_plane_size() from mxc_jpeg_dec_irq() sets
plane_no argument to 1. The compiler sees that it's possible to end up
with an access beyond the bounds of sizeimage, if mem_planes was too
large:

        if (plane_no >= fmt->mem_planes)        // mem_planes = 2+
                return 0;

        if (fmt->mem_planes == fmt->comp_planes) // comp_planes != mem_planes
                return q_data->sizeimage[plane_no];

        if (plane_no < fmt->mem_planes - 1)     // mem_planes = 2
                return q_data->sizeimage[plane_no];

comp_planes == 0 or 1 is safe. comp_planes > 2 would be out of bounds.

(This isn't currently possible given the contents of mxc_formats, though.)

Silence the warning by bounds checking comp_planes for future
robustness. Seen with GCC 13:

In function 'mxc_jpeg_get_plane_size',
    inlined from 'mxc_jpeg_dec_irq' at ../drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c:729:14:
../drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c:641:42: warning: array subscript 2 is above array bounds of 'u32[2]' {aka 'unsigned int[2]'} [-Warray-bounds=]
  641 |                 size += q_data->sizeimage[i];
      |                         ~~~~~~~~~~~~~~~~~^~~
In file included from ../drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h:112,
                 from ../drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c:63:
../drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h: In function 'mxc_jpeg_dec_irq':
../drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h:84:41: note: while referencing 'sizeimage'
   84 |         u32                             sizeimage[MXC_JPEG_MAX_PLANES];
      |                                         ^~~~~~~~~

Cc: Mirela Rabulea <mirela.rabulea@nxp.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index f085f14d676ad..c898116b763a2 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -637,6 +637,11 @@ static u32 mxc_jpeg_get_plane_size(struct mxc_jpeg_q_data *q_data, u32 plane_no)
 		return q_data->sizeimage[plane_no];
 
 	size = q_data->sizeimage[fmt->mem_planes - 1];
+
+	/* Should be impossible given mxc_formats. */
+	if (WARN_ON_ONCE(fmt->comp_planes > ARRAY_SIZE(q_data->sizeimage)))
+		return size;
+
 	for (i = fmt->mem_planes; i < fmt->comp_planes; i++)
 		size += q_data->sizeimage[i];
 
-- 
2.39.2




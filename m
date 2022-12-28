Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17841863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D61C433D2;
	Wed, 28 Dec 2022 15:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242301;
	bh=vRLkE86fpirHqul2CUIg/o2NFoI2q2mrfmZebt6V5PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7bXHWWqUbVLlrlMwMJVwhKiUj+oEEotG54caWtIuNwj1gaW+0P9t/I0Xl4MwUp0D
	 Eng03XwBuyJ/JQeEOb09+WEJcHuN/qse2Telf3yJ2NPLASm0ed3hCU7YTNni8MNygG
	 CjFHTwMGwvRplFEvO0XMq/8xJ0G7RG44GHKtAvcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0352/1146] media: amphion: add lock around vdec_g_fmt
Date: Wed, 28 Dec 2022 15:31:31 +0100
Message-Id: <20221228144339.724260199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 8480dd5fb3c82b5887d456b3fbe4201d99231814 ]

the capture format may be changed when
sequence header is parsed,
it may be read and write in the same time,
add lock around vdec_g_fmt to synchronize it

Fixes: 6de8d628df6e ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index 84c90ce265f2..b27e6bed85f0 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -286,6 +286,7 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	struct vpu_format *cur_fmt;
 	int i;
 
+	vpu_inst_lock(inst);
 	cur_fmt = vpu_get_format(inst, f->type);
 
 	pixmp->pixelformat = cur_fmt->pixfmt;
@@ -303,6 +304,7 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	f->fmt.pix_mp.xfer_func = vdec->codec_info.transfer_chars;
 	f->fmt.pix_mp.ycbcr_enc = vdec->codec_info.matrix_coeffs;
 	f->fmt.pix_mp.quantization = vdec->codec_info.full_range;
+	vpu_inst_unlock(inst);
 
 	return 0;
 }
-- 
2.35.1




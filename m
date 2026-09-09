Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255B52ED5E;
	Wed,  9 Sep 2026 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962784; cv=none; b=kRX1LtB35OIFoLuXmFS0n2Hf9nCWBMzzX0hk3DHh/HXOCbov3QpxdcDGK4BuIVEb6QzVSmXBJbNmMq2WHP6u+JGoaJYBsT+vDkKej94kPMoPxH6q4nXWOsAfUinPoPdN2YzXsaRVH2SvYRlm/aAGVWPXS7gOeC1mJXfEB+Q7i5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962784; c=relaxed/simple;
	bh=y2tu61VKYrcedNXnU/BaVEq+qTAILJ+himfvAoHt/N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSUBexRXs8Px43BdgEXNFCgG/GIVwYiYJVYHLLTiD6OGJIDGLCjKP05PxG9nRV9JzgL9KUV2RiigQH+0v0vM/+UdE4BkgNdA2PllIl51LUJDJhULFrERZ5CggON1pDxc80MFs72eUQlf27khGYAK2lOYpl3Lieah8kQp90vt4Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwhYWKOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwhYWKOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B80A1F00A3A;
	Wed,  9 Sep 2026 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962783;
	bh=WSaxmkAnYW0eqOkvgtL6TZrHwq2YdncUnKYfmgO1IHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwhYWKOCmULvnJ6ZNkP/E4xeqOzWCLOuhJ5GI29uuLQKXGjhFqxVFG3A/6nzhWepb
	 JDUpxcCLSREd0my+3LeUM1caF+i90+4kyfzP1J26H04KbBEPO2Nuh2gPr5+Hjy2mq6
	 RMWi/2FEW3sjnet8dlhTEliUTpmg0d8tvG3F7isc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 410/556] media: chips-media: wave5: Set inst->std during default format initialization
Date: Wed,  9 Sep 2026 15:41:30 +0200
Message-ID: <20260909134245.039261168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

commit cfcefc5a996f6a00b310c963b5f811430f28a30a upstream.

When the encoder is opened, wave5_set_default_format() sets up the
default capture format (e.g. H.264) but does not initialize inst->std.
As a result, inst->std remains zero, which does not match any valid
encoder codec.

If STREAMON is called before the user explicitly calls S_FMT on the
capture queue — as v4l2-compliance does in testBlockingDQBuf — the
codec/product check in wave5_vpu_enc_init_seq() fails with
"Unsupported encoder-codec & product combination" because inst->std
is neither W_HEVC_ENC nor W_AVC_ENC, returning -EOPNOTSUPP.

Fix this by setting inst->std via wave5_to_vpu_std() in
wave5_set_default_format(), so that the codec type is always consistent
with the default capture pixel format from the moment the instance is
opened.

Fixes: 9707a6254a8a ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -1494,7 +1494,8 @@ static const struct vb2_ops wave5_vpu_en
 	.stop_streaming = wave5_vpu_enc_stop_streaming,
 };
 
-static void wave5_set_default_format(struct v4l2_pix_format_mplane *src_fmt,
+static void wave5_set_default_format(struct vpu_instance *inst,
+				     struct v4l2_pix_format_mplane *src_fmt,
 				     struct v4l2_pix_format_mplane *dst_fmt)
 {
 	src_fmt->pixelformat = enc_fmt_list[VPU_FMT_TYPE_RAW][0].v4l2_pix_fmt;
@@ -1506,6 +1507,7 @@ static void wave5_set_default_format(str
 	wave5_update_pix_fmt(dst_fmt, VPU_FMT_TYPE_CODEC,
 			     W5_DEF_ENC_PIC_WIDTH, W5_DEF_ENC_PIC_HEIGHT,
 			     &enc_frmsize[VPU_FMT_TYPE_CODEC]);
+	inst->std = wave5_to_vpu_std(dst_fmt->pixelformat, inst->type);
 }
 
 static int wave5_vpu_enc_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
@@ -1770,7 +1772,7 @@ static int wave5_vpu_open_enc(struct fil
 	inst->v4l2_fh.ctrl_handler = v4l2_ctrl_hdl;
 	v4l2_ctrl_handler_setup(v4l2_ctrl_hdl);
 
-	wave5_set_default_format(&inst->src_fmt, &inst->dst_fmt);
+	wave5_set_default_format(inst, &inst->src_fmt, &inst->dst_fmt);
 	inst->conf_win.width = inst->dst_fmt.width;
 	inst->conf_win.height = inst->dst_fmt.height;
 	inst->colorspace = V4L2_COLORSPACE_REC709;



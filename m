Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D02C2737EE;
	Fri,  9 Jan 2026 12:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961283; cv=none; b=S74xHKEBsS6zPnti2g6EEazGmlKX+Kbxa3M5SzpApAawkTzHQTMFi/dkTpVNcB28q9LzaJl5GagyJn40myigCYa2OKjh1RYhJCYzi9vc01x11jJXRzVG3khOOnd3BYVgEj99FDQf3HADPnMsYSrC4Ky9B2NEcBPmN4/VYO5rF0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961283; c=relaxed/simple;
	bh=Y7bSiZwuobBDURrpGrrupi0/pqtVStPXHdVxFcfQNtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnXIczgDm0t8+NAk/Srde29OAbvJx1QwKWoz0FClptJ5mKFvqIvaIEwHXgHVLur+nrbNtv2T60LYvjb10q+sw1oAJWyqUI/jInWavoLV/aYYpSDtgCMk354TPoRVSwYouSyX8+vIMRNv8NM++v7APRwjY8jYkxUFGSMJ4FfLPp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcRsqCH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcRsqCH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFA9C4CEF1;
	Fri,  9 Jan 2026 12:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961283;
	bh=Y7bSiZwuobBDURrpGrrupi0/pqtVStPXHdVxFcfQNtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcRsqCH+BmTXFRJlEVP6X/M3HSxlc1y6XBhZ1ykdfwHMhjW6Km1sZ/7XiY/bvc4BE
	 xfx9UrQLHLf/2i6Yn2qiylSiTw9gqGl0HzNfVS+oiQCG9Auf0Tl6Q+d40SegMPuE3r
	 mRcYNaOWMzaQiMP2YBYvc/F8QZFATe/e3oFzcWZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 698/737] media: amphion: Add a frame flush mode for decoder
Date: Fri,  9 Jan 2026 12:43:57 +0100
Message-ID: <20260109112200.325850774@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit 9ea16ba6eaf93f25f61855751f71e2e701709ddf ]

By default the amphion decoder will pre-parse 3 frames before starting
to decode the first frame. Alternatively, a block of flush padding data
can be appended to the frame, which will ensure that the decoder can
start decoding immediately after parsing the flush padding data, thus
potentially reducing decoding latency.

This mode was previously only enabled, when the display delay was set to
0. Allow the user to manually toggle the use of that mode via a module
parameter called low_latency, which enables the mode without
changing the display order.

Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: 634c2cd17bd0 ("media: amphion: Remove vpu_vb_is_codecconfig")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/vpu_malone.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -25,6 +25,10 @@
 #include "vpu_imx8q.h"
 #include "vpu_malone.h"
 
+static bool low_latency;
+module_param(low_latency, bool, 0644);
+MODULE_PARM_DESC(low_latency, "Set low latency frame flush mode: 0 (disable) or 1 (enable)");
+
 #define CMD_SIZE			25600
 #define MSG_SIZE			25600
 #define CODEC_SIZE			0x1000
@@ -1567,7 +1571,15 @@ static int vpu_malone_input_frame_data(s
 
 	vpu_malone_update_wptr(str_buf, wptr);
 
-	if (disp_imm && !vpu_vb_is_codecconfig(vbuf)) {
+	/*
+	 * Enable the low latency flush mode if display delay is set to 0
+	 * or the low latency frame flush mode if it is set to 1.
+	 * The low latency flush mode requires some padding data to be appended to each frame,
+	 * but there must not be any padding data between the sequence header and the frame.
+	 * This module is currently only supported for the H264 and HEVC formats,
+	 * for other formats, vpu_malone_add_scode() will return 0.
+	 */
+	if ((disp_imm || low_latency) && !vpu_vb_is_codecconfig(vbuf)) {
 		ret = vpu_malone_add_scode(inst->core->iface,
 					   inst->id,
 					   &inst->stream_buffer,



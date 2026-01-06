Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869883016E5;
	Tue,  6 Jan 2026 17:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721519; cv=none; b=BGdeK3McDJ9xGcogLvySzqm3Q6HrzTo2uTcYj+ADxJr8+aPxVWNsCItps6NTIJxU8BiQ4DJGtBfeuyIqFL0mNB8AQJ/5ueQwRISqtgzWWgcLP+wLBDn8Rsa1biiLrUqdk2m3gV8yoC7Vh1QjcTZJTbUZ7DCdvTGVkoUgg6Hi2IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721519; c=relaxed/simple;
	bh=qMlUb3TXj2TRCMh6uljErXMye0aUvB3o8z9mR3U0DHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyWsve93CdvlwgUlLd3IcypQ6S9qlMvJ9yrqFV0OOlT0hualTOY+/J2V9mAPMm15c0r7eNZfXau7Hp++5MyHfVYJ9vnzOgheB6JgUJUTCNxe8qpE5ICGr8BSpS6UqM2WIDZApGfBvC7z0EfhVhAN1HPJtDzdp7aaF74mHF+u/a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+jMCkX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+jMCkX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3FEC116C6;
	Tue,  6 Jan 2026 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721519;
	bh=qMlUb3TXj2TRCMh6uljErXMye0aUvB3o8z9mR3U0DHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+jMCkX5waFBmS+1jDXajN1/G5yRRzPX0bILbOiyJBICg/Xh1EHn2/CsXRnT+xoZx
	 AwO+T93bTswsQ3hckkAelNRDQjJeFM3Y0buM4WxwJ2IFzNgB32Cuvklkd8pMQzYAuw
	 /CbeLLgRcLAgR9l3uoAJvP8bWjPynf3V8KDgON1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 559/567] media: amphion: Add a frame flush mode for decoder
Date: Tue,  6 Jan 2026 18:05:41 +0100
Message-ID: <20260106170512.105229061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -1562,7 +1566,15 @@ static int vpu_malone_input_frame_data(s
 
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



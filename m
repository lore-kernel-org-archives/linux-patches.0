Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E64813DDB8;
	Thu, 25 Jul 2024 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918734; cv=none; b=VMUpdhwaJkPVkHOyzwRNSwDHT6ezkmGhvztazGXJWx/1oHlJacD7Zspkogu4l/8l+dhyBkRVfPLObxcFg/azLaIlzXCdk4f9kd3u3sMouygtXgcaJwFSBO97MPsKVn4i7NDe/qC43T0095hY/S0BjxaIVA8C7lIdzQGzYEDHsAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918734; c=relaxed/simple;
	bh=txv3UrAJZqFkVRHhbOMcAXp1m/n+6Qw5cpYQ8RSUUS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JugM6aFV6LRINea3eK1+xKe09c47NZKl7hGbcZ9XjqejcF0LKGE3en0oCfcMH7E8vfooPplRz1l3fknjnWKXR6O3wCO2DKlsG9RXPgrCXAnRsuU0Fz6clMFFsxkwJAU3hJLLIObvZM+b+5TdovP0/oy7IuNTLLAVIuoG1OSJ7Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkDJCwDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkDJCwDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66E0C116B1;
	Thu, 25 Jul 2024 14:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918734;
	bh=txv3UrAJZqFkVRHhbOMcAXp1m/n+6Qw5cpYQ8RSUUS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkDJCwDRONo2b38k6VxoaJXLVYqgYoFihqGMqLxM8HHODR5bdY3EZdve05/fwr8Bs
	 1hly9G051dlCuqZI0FWFjkxobu1X8lm0QuppdzIXH546d++MbPmdlc0RJL5Cr3V+Zc
	 9A4EHgG1Wo8occjMXCihUCVQq1FPmmZSWJTQmhP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 06/16] usb: gadget: midi2: Fix incorrect default MIDI2 protocol setup
Date: Thu, 25 Jul 2024 16:37:19 +0200
Message-ID: <20240725142729.144193372@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Takashi Iwai <tiwai@suse.de>

commit 3eb27d3e32c78badbc4db6ae76614b5961e32291 upstream.

The MIDI2 gadget driver handled the default MIDI protocol version
incorrectly due to the confusion of the protocol version passed via
configfs (either 1 or 2) and UMP protocol bits (0x100 / 0x200).
As a consequence, the default protocol always resulted in MIDI1.

This patch addresses the misunderstanding of the protocol handling.

Fixes: 29ee7a4dddd5 ("usb: gadget: midi2: Add configfs support")
Cc: stable <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240708095719.25627-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_midi2.c b/drivers/usb/gadget/function/f_midi2.c
index c765f54e613d..38e8ed3144f0 100644
--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -150,6 +150,9 @@ struct f_midi2 {
 
 #define func_to_midi2(f)	container_of(f, struct f_midi2, func)
 
+/* convert from MIDI protocol number (1 or 2) to SNDRV_UMP_EP_INFO_PROTO_* */
+#define to_ump_protocol(v)	(((v) & 3) << 8)
+
 /* get EP name string */
 static const char *ump_ep_name(const struct f_midi2_ep *ep)
 {
@@ -564,8 +567,7 @@ static void reply_ump_stream_ep_config(struct f_midi2_ep *ep)
 		.status = UMP_STREAM_MSG_STATUS_STREAM_CFG,
 	};
 
-	if ((ep->info.protocol & SNDRV_UMP_EP_INFO_PROTO_MIDI_MASK) ==
-	    SNDRV_UMP_EP_INFO_PROTO_MIDI2)
+	if (ep->info.protocol == 2)
 		rep.protocol = UMP_STREAM_MSG_EP_INFO_CAP_MIDI2 >> 8;
 	else
 		rep.protocol = UMP_STREAM_MSG_EP_INFO_CAP_MIDI1 >> 8;
@@ -627,13 +629,13 @@ static void process_ump_stream_msg(struct f_midi2_ep *ep, const u32 *data)
 		return;
 	case UMP_STREAM_MSG_STATUS_STREAM_CFG_REQUEST:
 		if (*data & UMP_STREAM_MSG_EP_INFO_CAP_MIDI2) {
-			ep->info.protocol = SNDRV_UMP_EP_INFO_PROTO_MIDI2;
+			ep->info.protocol = 2;
 			DBG(midi2, "Switching Protocol to MIDI2\n");
 		} else {
-			ep->info.protocol = SNDRV_UMP_EP_INFO_PROTO_MIDI1;
+			ep->info.protocol = 1;
 			DBG(midi2, "Switching Protocol to MIDI1\n");
 		}
-		snd_ump_switch_protocol(ep->ump, ep->info.protocol);
+		snd_ump_switch_protocol(ep->ump, to_ump_protocol(ep->info.protocol));
 		reply_ump_stream_ep_config(ep);
 		return;
 	case UMP_STREAM_MSG_STATUS_FB_DISCOVERY:
@@ -1065,7 +1067,8 @@ static void f_midi2_midi1_ep_out_complete(struct usb_ep *usb_ep,
 		group = midi2->out_cable_mapping[cable].group;
 		bytes = midi1_packet_bytes[*buf & 0x0f];
 		for (c = 0; c < bytes; c++) {
-			snd_ump_convert_to_ump(cvt, group, ep->info.protocol,
+			snd_ump_convert_to_ump(cvt, group,
+					       to_ump_protocol(ep->info.protocol),
 					       buf[c + 1]);
 			if (cvt->ump_bytes) {
 				snd_ump_receive(ep->ump, cvt->ump,
@@ -1375,7 +1378,7 @@ static void assign_block_descriptors(struct f_midi2 *midi2,
 			desc->nNumGroupTrm = b->num_groups;
 			desc->iBlockItem = ep->blks[blk].string_id;
 
-			if (ep->info.protocol & SNDRV_UMP_EP_INFO_PROTO_MIDI2)
+			if (ep->info.protocol == 2)
 				desc->bMIDIProtocol = USB_MS_MIDI_PROTO_2_0;
 			else
 				desc->bMIDIProtocol = USB_MS_MIDI_PROTO_1_0_128;
@@ -1552,7 +1555,7 @@ static int f_midi2_create_card(struct f_midi2 *midi2)
 		if (midi2->info.static_block)
 			ump->info.flags |= SNDRV_UMP_EP_INFO_STATIC_BLOCKS;
 		ump->info.protocol_caps = (ep->info.protocol_caps & 3) << 8;
-		ump->info.protocol = (ep->info.protocol & 3) << 8;
+		ump->info.protocol = to_ump_protocol(ep->info.protocol);
 		ump->info.version = 0x0101;
 		ump->info.family_id = ep->info.family;
 		ump->info.model_id = ep->info.model;
-- 
2.45.2




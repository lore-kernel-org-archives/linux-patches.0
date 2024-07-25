Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8332919A29C;
	Thu, 25 Jul 2024 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918369; cv=none; b=Y9bVfosCXu2HYcnIeEa305RbxyKTl31954nrsePSUtw6nBLBAcERnO7G8kj57/ueA21hvY8G4xiueyHuVKJ+rtmbxHOVaMwTSELI+v9GAhBGQUG285OnWwNv0Kbq41BWIDz3f4lyyRA37dP+yyrq56gtqiv1v3QARD1o3alrWlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918369; c=relaxed/simple;
	bh=2dnrj1htSEe0YyV953l2J76yIf0VcovrNhmY+pK8AxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1LEn2303jqKin+0N09E1DL7a4NiG9fV0uRzqbfxYBWN8OkXhat00DdWRkYS9eBCyLEtw3MEbYocOWKDWFpAzX8rccBhNmxBCrKkJK6pCI9n3zhTfbl0H6BR7oG0W+uWAAXOVzRJKVnJxl0rnT4SmQzQSh4SEZcUt8QIwAStBoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDHYbavg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDHYbavg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D58C116B1;
	Thu, 25 Jul 2024 14:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918369;
	bh=2dnrj1htSEe0YyV953l2J76yIf0VcovrNhmY+pK8AxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDHYbavgocRIMJvII2vaFTtIydBnCBZMR8Fqx/NdtkNRVStCDT++9ss45u5yonZWT
	 esY79m81JaBQY+7Bhd+gi85WU4xwVPeveCRcGPQOjFqpmEfuWqiZhJgegrfc9Lal/k
	 5ExpijvUWOFvd8JBhavSoynX+5wu9HU+scIBeIGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 07/29] usb: gadget: midi2: Fix incorrect default MIDI2 protocol setup
Date: Thu, 25 Jul 2024 16:36:23 +0200
Message-ID: <20240725142732.094747026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/gadget/function/f_midi2.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

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
@@ -564,8 +567,7 @@ static void reply_ump_stream_ep_config(s
 		.status = UMP_STREAM_MSG_STATUS_STREAM_CFG,
 	};
 
-	if ((ep->info.protocol & SNDRV_UMP_EP_INFO_PROTO_MIDI_MASK) ==
-	    SNDRV_UMP_EP_INFO_PROTO_MIDI2)
+	if (ep->info.protocol == 2)
 		rep.protocol = UMP_STREAM_MSG_EP_INFO_CAP_MIDI2 >> 8;
 	else
 		rep.protocol = UMP_STREAM_MSG_EP_INFO_CAP_MIDI1 >> 8;
@@ -627,13 +629,13 @@ static void process_ump_stream_msg(struc
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
@@ -1065,7 +1067,8 @@ static void f_midi2_midi1_ep_out_complet
 		group = midi2->out_cable_mapping[cable].group;
 		bytes = midi1_packet_bytes[*buf & 0x0f];
 		for (c = 0; c < bytes; c++) {
-			snd_ump_convert_to_ump(cvt, group, ep->info.protocol,
+			snd_ump_convert_to_ump(cvt, group,
+					       to_ump_protocol(ep->info.protocol),
 					       buf[c + 1]);
 			if (cvt->ump_bytes) {
 				snd_ump_receive(ep->ump, cvt->ump,
@@ -1375,7 +1378,7 @@ static void assign_block_descriptors(str
 			desc->nNumGroupTrm = b->num_groups;
 			desc->iBlockItem = ep->blks[blk].string_id;
 
-			if (ep->info.protocol & SNDRV_UMP_EP_INFO_PROTO_MIDI2)
+			if (ep->info.protocol == 2)
 				desc->bMIDIProtocol = USB_MS_MIDI_PROTO_2_0;
 			else
 				desc->bMIDIProtocol = USB_MS_MIDI_PROTO_1_0_128;
@@ -1552,7 +1555,7 @@ static int f_midi2_create_card(struct f_
 		if (midi2->info.static_block)
 			ump->info.flags |= SNDRV_UMP_EP_INFO_STATIC_BLOCKS;
 		ump->info.protocol_caps = (ep->info.protocol_caps & 3) << 8;
-		ump->info.protocol = (ep->info.protocol & 3) << 8;
+		ump->info.protocol = to_ump_protocol(ep->info.protocol);
 		ump->info.version = 0x0101;
 		ump->info.family_id = ep->info.family;
 		ump->info.model_id = ep->info.model;



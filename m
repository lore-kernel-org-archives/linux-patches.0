Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D236114A08E;
	Thu,  5 Sep 2024 09:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529959; cv=none; b=RM8TjrOf8NdHYg4csA1tydwsZj0BWsc1A38x2m0ZWqqV9b9SSHoEvEfcXyjYPZFHYqkPW1d19r0sXboA5tFci9UydFUPmTHfXPx+DkukHJvRromWSfSIfezZGBRn62r3k2gOaxZMlP+CqdSQbSGvd3MLUN+Y8j2Ks4i97fSawxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529959; c=relaxed/simple;
	bh=StwANbkozm9hiQ2FdN/TzthSFIhW+uUgtLWZjqEFhD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOIz6LWY1POZIgAUTHKGNPMm9mBiNJnkLn9EIUKsuZNjbaV7YJ8mwp52YliSDAxLPVNyHZ/v0IF5edvHrvL9qnfiKmXjvHQPrfvquvelra2dj7E3is7/AUJEnkailFRDYBx2T0s+kxbqXxCS+umoiQTB1gVy7uvdRXeZOzJ1KUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfH3XxB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfH3XxB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2C2C4CEC3;
	Thu,  5 Sep 2024 09:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529959;
	bh=StwANbkozm9hiQ2FdN/TzthSFIhW+uUgtLWZjqEFhD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfH3XxB64Pyp1AXSGjCyRkR85BOVkQcHmlkQ/EOv+WaWtuvlVl0cQ33oToTfXdh0w
	 awufYmeqwdmGHvXRatXQ1+DqjDbOR6RKx1gJyCmTJ4igDf9rSzO6r3D81Dx+UaK8kc
	 9vRcF+FH9AA2ErKsK1Y//GpHWVQG2KpI5LvAMjyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/132] ALSA: seq: ump: Transmit RPN/NRPN message at each MSB/LSB data reception
Date: Thu,  5 Sep 2024 11:39:58 +0200
Message-ID: <20240905093722.674468849@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

[ Upstream commit a4ff92ff0bdd731eca9f0b50b1cbb5aba89be4b2 ]

Just like the core UMP conversion helper, we need to deal with the
partially-filled RPN/NRPN data in the sequencer UMP converter as
well.

Link: https://patch.msgid.link/20240731130528.12600-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 74 +++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index b1bc6d122d92d..7ca62667f28d3 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -790,27 +790,39 @@ static int paf_ev_to_ump_midi2(const struct snd_seq_event *event,
 }
 
 /* set up the MIDI2 RPN/NRPN packet data from the parsed info */
-static void fill_rpn(struct ump_cvt_to_ump_bank *cc,
-		     union snd_ump_midi2_msg *data,
-		     unsigned char channel)
+static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
+		    union snd_ump_midi2_msg *data,
+		    unsigned char channel,
+		    bool flush)
 {
+	if (!(cc->cc_data_lsb_set || cc->cc_data_msb_set))
+		return 0; // skip
+	/* when not flushing, wait for complete data set */
+	if (!flush && (!cc->cc_data_lsb_set || !cc->cc_data_msb_set))
+		return 0; // skip
+
 	if (cc->rpn_set) {
 		data->rpn.status = UMP_MSG_STATUS_RPN;
 		data->rpn.bank = cc->cc_rpn_msb;
 		data->rpn.index = cc->cc_rpn_lsb;
-		cc->rpn_set = 0;
-		cc->cc_rpn_msb = cc->cc_rpn_lsb = 0;
-	} else {
+	} else if (cc->nrpn_set) {
 		data->rpn.status = UMP_MSG_STATUS_NRPN;
 		data->rpn.bank = cc->cc_nrpn_msb;
 		data->rpn.index = cc->cc_nrpn_lsb;
-		cc->nrpn_set = 0;
-		cc->cc_nrpn_msb = cc->cc_nrpn_lsb = 0;
+	} else {
+		return 0; // skip
 	}
+
 	data->rpn.data = upscale_14_to_32bit((cc->cc_data_msb << 7) |
 					     cc->cc_data_lsb);
 	data->rpn.channel = channel;
+
+	cc->rpn_set = 0;
+	cc->nrpn_set = 0;
+	cc->cc_rpn_msb = cc->cc_rpn_lsb = 0;
 	cc->cc_data_msb = cc->cc_data_lsb = 0;
+	cc->cc_data_msb_set = cc->cc_data_lsb_set = 0;
+	return 1;
 }
 
 /* convert CC event to MIDI 2.0 UMP */
@@ -823,28 +835,34 @@ static int cc_ev_to_ump_midi2(const struct snd_seq_event *event,
 	unsigned char index = event->data.control.param & 0x7f;
 	unsigned char val = event->data.control.value & 0x7f;
 	struct ump_cvt_to_ump_bank *cc = &dest_port->midi2_bank[channel];
+	int ret;
 
 	/* process special CC's (bank/rpn/nrpn) */
 	switch (index) {
 	case UMP_CC_RPN_MSB:
+		ret = fill_rpn(cc, data, channel, true);
 		cc->rpn_set = 1;
 		cc->cc_rpn_msb = val;
-		return 0; // skip
+		return ret;
 	case UMP_CC_RPN_LSB:
+		ret = fill_rpn(cc, data, channel, true);
 		cc->rpn_set = 1;
 		cc->cc_rpn_lsb = val;
-		return 0; // skip
+		return ret;
 	case UMP_CC_NRPN_MSB:
+		ret = fill_rpn(cc, data, channel, true);
 		cc->nrpn_set = 1;
 		cc->cc_nrpn_msb = val;
-		return 0; // skip
+		return ret;
 	case UMP_CC_NRPN_LSB:
+		ret = fill_rpn(cc, data, channel, true);
 		cc->nrpn_set = 1;
 		cc->cc_nrpn_lsb = val;
-		return 0; // skip
+		return ret;
 	case UMP_CC_DATA:
+		cc->cc_data_msb_set = 1;
 		cc->cc_data_msb = val;
-		return 0; // skip
+		return fill_rpn(cc, data, channel, false);
 	case UMP_CC_BANK_SELECT:
 		cc->bank_set = 1;
 		cc->cc_bank_msb = val;
@@ -854,11 +872,9 @@ static int cc_ev_to_ump_midi2(const struct snd_seq_event *event,
 		cc->cc_bank_lsb = val;
 		return 0; // skip
 	case UMP_CC_DATA_LSB:
+		cc->cc_data_lsb_set = 1;
 		cc->cc_data_lsb = val;
-		if (!(cc->rpn_set || cc->nrpn_set))
-			return 0; // skip
-		fill_rpn(cc, data, channel);
-		return 1;
+		return fill_rpn(cc, data, channel, false);
 	}
 
 	data->cc.status = status;
@@ -926,6 +942,7 @@ static int ctrl14_ev_to_ump_midi2(const struct snd_seq_event *event,
 	unsigned char index = event->data.control.param & 0x7f;
 	struct ump_cvt_to_ump_bank *cc = &dest_port->midi2_bank[channel];
 	unsigned char msb, lsb;
+	int ret;
 
 	msb = (event->data.control.value >> 7) & 0x7f;
 	lsb = event->data.control.value & 0x7f;
@@ -939,28 +956,25 @@ static int ctrl14_ev_to_ump_midi2(const struct snd_seq_event *event,
 		cc->cc_bank_lsb = lsb;
 		return 0; // skip
 	case UMP_CC_RPN_MSB:
-		cc->cc_rpn_msb = msb;
-		fallthrough;
 	case UMP_CC_RPN_LSB:
-		cc->rpn_set = 1;
+		ret = fill_rpn(cc, data, channel, true);
+		cc->cc_rpn_msb = msb;
 		cc->cc_rpn_lsb = lsb;
-		return 0; // skip
+		cc->rpn_set = 1;
+		return ret;
 	case UMP_CC_NRPN_MSB:
-		cc->cc_nrpn_msb = msb;
-		fallthrough;
 	case UMP_CC_NRPN_LSB:
+		ret = fill_rpn(cc, data, channel, true);
+		cc->cc_nrpn_msb = msb;
 		cc->nrpn_set = 1;
 		cc->cc_nrpn_lsb = lsb;
-		return 0; // skip
+		return ret;
 	case UMP_CC_DATA:
-		cc->cc_data_msb = msb;
-		fallthrough;
 	case UMP_CC_DATA_LSB:
+		cc->cc_data_msb_set = cc->cc_data_lsb_set = 1;
+		cc->cc_data_msb = msb;
 		cc->cc_data_lsb = lsb;
-		if (!(cc->rpn_set || cc->nrpn_set))
-			return 0; // skip
-		fill_rpn(cc, data, channel);
-		return 1;
+		return fill_rpn(cc, data, channel, false);
 	}
 
 	data->cc.status = UMP_MSG_STATUS_CC;
-- 
2.43.0




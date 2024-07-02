Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD0F14293;
	Tue,  2 Jul 2024 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940902; cv=none; b=plGafcyQ8nlF2d9tJoAuhSwOtPWQ1gc6wcLvyk4RX5B0vFT5WQx5dklsRpQpVd2ItH1JigIacbmmv9UMvnhVwrlnpL16aoedrA38QIjt4SU4MjP715YWtGgoytgYFC819qXkSO01mH2M3/vXfk1OUtlGVoTIko34piEQ+IXMjnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940902; c=relaxed/simple;
	bh=HZFJOv4s2gvUyTQz/iETrPbUZ7BzUvbzUK57VqH5v4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HraW5+Q4EBybyLCgGTZjQpZ1TiXF//at0+TuVDivXHstGDvV9LfRWjkwn4pH7WqD2ZQU+aitrbzpbLFPAGN6qTVymtTjR8XZ4Peq9gYMcRL3Jfm9u6GWRADcGkUSse0exPxWzeGgNwvJ3Q1lrQwNiBGvCz8ckgTBVLDPglpj1go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPTddp1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPTddp1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4258AC116B1;
	Tue,  2 Jul 2024 17:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940902;
	bh=HZFJOv4s2gvUyTQz/iETrPbUZ7BzUvbzUK57VqH5v4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPTddp1eosDs/5uWDIRHSSl04MAZYtFrcrN+gkm7d60r8JAGb4/fHcZojpEGuBFcj
	 bulD9PTf3Iqwh0xDb/x3qb3IsHV/XRnKiMyNivI0wcIIycGsjYYmjiVxlHNiAVdbzo
	 t8b2YXQ+XZLLDcwnJVCt7oMcaHVmym/z+GiL1/Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/163] ALSA: seq: Fix missing channel at encoding RPN/NRPN MIDI2 messages
Date: Tue,  2 Jul 2024 19:02:34 +0200
Message-ID: <20240702170234.577567406@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

[ Upstream commit c5ab94ea280a9b4108723eecf0a636e22a5bb137 ]

The conversion from the legacy event to MIDI2 UMP for RPN and NRPN
missed the setup of the channel number, resulting in always the
channel 0.  Fix it.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Link: https://patch.msgid.link/20240625095200.25745-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index d81f776a4c3dd..6687efdceea13 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -791,7 +791,8 @@ static int paf_ev_to_ump_midi2(const struct snd_seq_event *event,
 
 /* set up the MIDI2 RPN/NRPN packet data from the parsed info */
 static void fill_rpn(struct snd_seq_ump_midi2_bank *cc,
-		     union snd_ump_midi2_msg *data)
+		     union snd_ump_midi2_msg *data,
+		     unsigned char channel)
 {
 	if (cc->rpn_set) {
 		data->rpn.status = UMP_MSG_STATUS_RPN;
@@ -808,6 +809,7 @@ static void fill_rpn(struct snd_seq_ump_midi2_bank *cc,
 	}
 	data->rpn.data = upscale_14_to_32bit((cc->cc_data_msb << 7) |
 					     cc->cc_data_lsb);
+	data->rpn.channel = channel;
 	cc->cc_data_msb = cc->cc_data_lsb = 0;
 }
 
@@ -855,7 +857,7 @@ static int cc_ev_to_ump_midi2(const struct snd_seq_event *event,
 		cc->cc_data_lsb = val;
 		if (!(cc->rpn_set || cc->nrpn_set))
 			return 0; // skip
-		fill_rpn(cc, data);
+		fill_rpn(cc, data, channel);
 		return 1;
 	}
 
@@ -957,7 +959,7 @@ static int ctrl14_ev_to_ump_midi2(const struct snd_seq_event *event,
 		cc->cc_data_lsb = lsb;
 		if (!(cc->rpn_set || cc->nrpn_set))
 			return 0; // skip
-		fill_rpn(cc, data);
+		fill_rpn(cc, data, channel);
 		return 1;
 	}
 
-- 
2.43.0




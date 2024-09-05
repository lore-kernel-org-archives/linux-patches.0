Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06571194A60;
	Thu,  5 Sep 2024 09:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529369; cv=none; b=XJgyCZ7PrYJdLsiCIa6EU2O/xrBYGTrsl1OsY7aLQ4S0skceExAsXlTOxDmXW+PkF1geH+r7sdxMNzZ7JYzEArhfpmYn6gDxgYaVfMpUfodD2MK4mtxTss5lsf/5wzqOr51hNcA6kMyvZLcBY6SMCPP7eFZbI2OwQwGYDT4y784=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529369; c=relaxed/simple;
	bh=0/WxzY1Sji86mo+0DJbJiQKMBBwCHJaTcm9dpgXtVk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzSUZaZhC4qkhQjFrEOwNmvG6GLDywhYPxvlFDiD9n4lkAy8ZMWGuJxSt7MmsDvGJtQGGGdfSQuu+Rc7CI0Fiqnr0dyAKaOBWZBvxLxn1EfzCGao0qMIbIL7YWTSGWeb9+7MHQOW6ai3HNKjor+S/FV6iXQ+oZ/CAcijYtAnKZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCdQmsFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCdQmsFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD38C4CEC3;
	Thu,  5 Sep 2024 09:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529368;
	bh=0/WxzY1Sji86mo+0DJbJiQKMBBwCHJaTcm9dpgXtVk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCdQmsFsKEkSrRJLuRcDyNk8+JaVrTs5NwozL7eMaIOVVjUpIAE3YRawyTMyluxAk
	 jf39O4MUANEZj9ReMmlmiucMj4uALhVs5g0iwRW0o2EGwVFtIwo1Dsk4iaqV9aPSEG
	 p4Jt3yNpkDaCH+tJMqKleZqcIFtNea7espwfGMAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 011/184] ALSA: seq: ump: Use the common RPN/bank conversion context
Date: Thu,  5 Sep 2024 11:38:44 +0200
Message-ID: <20240905093732.683996957@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

[ Upstream commit a683030606fa5ff8b722a5e28839d19288011ede ]

The UMP core conversion helper API already defines the context needed
to record the bank and RPN/NRPN values, and we can simply re-use the
same struct instead of re-defining the same content as a different
name.

Link: https://patch.msgid.link/20240731130528.12600-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ports.h       | 14 ++------------
 sound/core/seq/seq_ump_convert.c | 10 +++++-----
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/sound/core/seq/seq_ports.h b/sound/core/seq/seq_ports.h
index b111382f697aa..9e36738c0dd04 100644
--- a/sound/core/seq/seq_ports.h
+++ b/sound/core/seq/seq_ports.h
@@ -7,6 +7,7 @@
 #define __SND_SEQ_PORTS_H
 
 #include <sound/seq_kernel.h>
+#include <sound/ump_convert.h>
 #include "seq_lock.h"
 
 /* list of 'exported' ports */
@@ -42,17 +43,6 @@ struct snd_seq_port_subs_info {
 	int (*close)(void *private_data, struct snd_seq_port_subscribe *info);
 };
 
-/* context for converting from legacy control event to UMP packet */
-struct snd_seq_ump_midi2_bank {
-	bool rpn_set;
-	bool nrpn_set;
-	bool bank_set;
-	unsigned char cc_rpn_msb, cc_rpn_lsb;
-	unsigned char cc_nrpn_msb, cc_nrpn_lsb;
-	unsigned char cc_data_msb, cc_data_lsb;
-	unsigned char cc_bank_msb, cc_bank_lsb;
-};
-
 struct snd_seq_client_port {
 
 	struct snd_seq_addr addr;	/* client/port number */
@@ -88,7 +78,7 @@ struct snd_seq_client_port {
 	unsigned char ump_group;
 
 #if IS_ENABLED(CONFIG_SND_SEQ_UMP)
-	struct snd_seq_ump_midi2_bank midi2_bank[16]; /* per channel */
+	struct ump_cvt_to_ump_bank midi2_bank[16]; /* per channel */
 #endif
 };
 
diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index d9dacfbe4a9ae..b1bc6d122d92d 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -368,7 +368,7 @@ static int cvt_ump_midi1_to_midi2(struct snd_seq_client *dest,
 	struct snd_seq_ump_event ev_cvt;
 	const union snd_ump_midi1_msg *midi1 = (const union snd_ump_midi1_msg *)event->ump;
 	union snd_ump_midi2_msg *midi2 = (union snd_ump_midi2_msg *)ev_cvt.ump;
-	struct snd_seq_ump_midi2_bank *cc;
+	struct ump_cvt_to_ump_bank *cc;
 
 	ev_cvt = *event;
 	memset(&ev_cvt.ump, 0, sizeof(ev_cvt.ump));
@@ -790,7 +790,7 @@ static int paf_ev_to_ump_midi2(const struct snd_seq_event *event,
 }
 
 /* set up the MIDI2 RPN/NRPN packet data from the parsed info */
-static void fill_rpn(struct snd_seq_ump_midi2_bank *cc,
+static void fill_rpn(struct ump_cvt_to_ump_bank *cc,
 		     union snd_ump_midi2_msg *data,
 		     unsigned char channel)
 {
@@ -822,7 +822,7 @@ static int cc_ev_to_ump_midi2(const struct snd_seq_event *event,
 	unsigned char channel = event->data.control.channel & 0x0f;
 	unsigned char index = event->data.control.param & 0x7f;
 	unsigned char val = event->data.control.value & 0x7f;
-	struct snd_seq_ump_midi2_bank *cc = &dest_port->midi2_bank[channel];
+	struct ump_cvt_to_ump_bank *cc = &dest_port->midi2_bank[channel];
 
 	/* process special CC's (bank/rpn/nrpn) */
 	switch (index) {
@@ -887,7 +887,7 @@ static int pgm_ev_to_ump_midi2(const struct snd_seq_event *event,
 			       unsigned char status)
 {
 	unsigned char channel = event->data.control.channel & 0x0f;
-	struct snd_seq_ump_midi2_bank *cc = &dest_port->midi2_bank[channel];
+	struct ump_cvt_to_ump_bank *cc = &dest_port->midi2_bank[channel];
 
 	data->pg.status = status;
 	data->pg.channel = channel;
@@ -924,7 +924,7 @@ static int ctrl14_ev_to_ump_midi2(const struct snd_seq_event *event,
 {
 	unsigned char channel = event->data.control.channel & 0x0f;
 	unsigned char index = event->data.control.param & 0x7f;
-	struct snd_seq_ump_midi2_bank *cc = &dest_port->midi2_bank[channel];
+	struct ump_cvt_to_ump_bank *cc = &dest_port->midi2_bank[channel];
 	unsigned char msb, lsb;
 
 	msb = (event->data.control.value >> 7) & 0x7f;
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE801CB334;
	Thu,  6 Jun 2024 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683760; cv=none; b=gF5uk8XJG/DfMnJ63oXrsR6JqAw7SCgaS0Zf5RdntKYdrbBUO7Ub7uKo5gtw9nbMIpIxlntRbjCY4kSI4ihQUtltMg0L9ufBJ4QRLGZR/lzVCUVGyS47ZYxpV5S+c5giK4+Aq7eKQvNX4VBbIbl/AcN/57juRQMGkzdbTiBHDTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683760; c=relaxed/simple;
	bh=7joS1tb7qekm/htkXI0LMHuPFGpza7AZahdZAAFSbbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIRbAQsdE/RVprpUkVrNPmS4OqbUsHIknWF7wzkXRWB3P8rejO+SaBhkfuGpV/ucjDOuQJRGtyUc7kxP4x53V89urFOOKfeYAKYsCg0STqr3cG+67fFPOqghlIqYfT/NoN9teTJN3AGVSUq0DBFsuuxoEklYgmNxujGrAPAG39s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txZr7+e0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txZr7+e0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF57BC2BD10;
	Thu,  6 Jun 2024 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683759;
	bh=7joS1tb7qekm/htkXI0LMHuPFGpza7AZahdZAAFSbbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txZr7+e0L7m2ie9mXIIrK/D5G2OdjqGZNNbo8XQNRul469kUjI9hvhuj0041smUEd
	 lIm2bjWOGX3+FCe6O7sGp6t1Bdy6fWyGv4lJP2SGo+01ZpM4gcXcUwRN+/4ioaHTrK
	 dI3ypcHg8GJK4PZJoYuLiVFN2o/DY6jUmpGH+v/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 736/744] ALSA: seq: ump: Fix swapped song position pointer data
Date: Thu,  6 Jun 2024 16:06:48 +0200
Message-ID: <20240606131756.068754938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit 310fa3ec2859f1c094e6e9b5d2e1ca51738c409a ]

At converting between the legacy event and UMP, the parameters for
MIDI Song Position Pointer are incorrectly stored.  It should have
been LSB -> MSB order while it stored in MSB -> LSB order.
This patch corrects the ordering.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Link: https://lore.kernel.org/r/20240531075110.3250-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index 903a644b80e25..9bfba69b2a709 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -157,7 +157,7 @@ static void ump_system_to_one_param_ev(const union snd_ump_midi1_msg *val,
 static void ump_system_to_songpos_ev(const union snd_ump_midi1_msg *val,
 				     struct snd_seq_event *ev)
 {
-	ev->data.control.value = (val->system.parm1 << 7) | val->system.parm2;
+	ev->data.control.value = (val->system.parm2 << 7) | val->system.parm1;
 }
 
 /* Encoders for 0xf0 - 0xff */
@@ -752,8 +752,8 @@ static int system_2p_ev_to_ump_midi1(const struct snd_seq_event *event,
 				     unsigned char status)
 {
 	data->system.status = status;
-	data->system.parm1 = (event->data.control.value >> 7) & 0x7f;
-	data->system.parm2 = event->data.control.value & 0x7f;
+	data->system.parm1 = event->data.control.value & 0x7f;
+	data->system.parm2 = (event->data.control.value >> 7) & 0x7f;
 	return 1;
 }
 
-- 
2.43.0




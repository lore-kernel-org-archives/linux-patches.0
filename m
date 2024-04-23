Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E903143C6B;
	Tue, 23 Apr 2024 21:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908650; cv=none; b=hG8EIS3IGJOmmBcLWAHgsflUhwxNw9HL34SWHw6puSoJ+djw4UbQmFccdcacGaEM5cK0eFiaCE/hFHJEEgigwMb8syEv69QhopNY8adDosK3BmhFxKNMEnS8OqTEnS930YAUh0/cN9uohmbmc7qv9xbr6UbmflzH2FZzwJeGELA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908650; c=relaxed/simple;
	bh=+58TTd6JNBaS0pJu1VzPeFSTMGRPE/PQ36iqMeSbcss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VP8DnC0VP/I1SEWHKS2sEJx6kO2VNIqCjFGRckKSBHkMbNCAvBKV6V78AAskp1JG+kbdNH/LSnls94xopcca+8nwHzz6zQt7QKiYttITlV6eXyWXfAfqEoH7NuPO5A7e/7KbgsDFRX4PPK3Dmrkhgeix9Z20BcKhVHEYjUceKnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFPEJUg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFPEJUg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B37C32781;
	Tue, 23 Apr 2024 21:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908650;
	bh=+58TTd6JNBaS0pJu1VzPeFSTMGRPE/PQ36iqMeSbcss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFPEJUg8WPA74dpWD/zt/wHH4WQGRYGamPDXQAn5j4K2WY8C1X53la/rWrtKYqMxs
	 WmqNUleIxVcfYPUmVtYejypBQUaOgC0O8gyFLSwqxps19Ou7PwZHMIEgrG9ijW4PHJ
	 5IIpQieOAGdZvjuYMHv/zgRw7BsrlbE0waQRv+mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 100/158] ALSA: seq: ump: Fix conversion from MIDI2 to MIDI1 UMP messages
Date: Tue, 23 Apr 2024 14:38:57 -0700
Message-ID: <20240423213858.999513325@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

commit f25f17dc5c6a5e3f2014d44635f0c0db45224efe upstream.

The conversion from MIDI2 to MIDI1 UMP messages had a leftover
artifact (superfluous bit shift), and this resulted in the bogus type
check, leading to empty outputs.  Let's fix it.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Cc: <stable@vger.kernel.org>
Link: https://github.com/alsa-project/alsa-utils/issues/262
Message-ID: <20240419100442.14806-1-tiwai@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_ump_convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index b141024830ec..ee6ac649df83 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -428,7 +428,7 @@ static int cvt_ump_midi2_to_midi1(struct snd_seq_client *dest,
 	midi1->note.group = midi2->note.group;
 	midi1->note.status = midi2->note.status;
 	midi1->note.channel = midi2->note.channel;
-	switch (midi2->note.status << 4) {
+	switch (midi2->note.status) {
 	case UMP_MSG_STATUS_NOTE_ON:
 	case UMP_MSG_STATUS_NOTE_OFF:
 		midi1->note.note = midi2->note.note;
-- 
2.44.0




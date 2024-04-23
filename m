Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D56143C46;
	Tue, 23 Apr 2024 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908523; cv=none; b=t9Rm073KihKVpUfxnH5TzIIb0+IS73OuK428P0jRBWZMe6MC8hgmunuYBZIVmtqJM+fk/paAno4w6D2TBs7+46fQsW9D9tHfx/OIf7tOHIRtCcues1v5DNNftq9C48OP5/tqZiw8WsCBQz8QZosQ2yIn4GuitdBBbaONMkLjQsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908523; c=relaxed/simple;
	bh=amoAlcVgfnbfpFv0EL0jh799Ms1K/6U5gGIVbQeqiaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drY61Tj7JxEQ0+/SYKMfmf+AJsuEJvx1jkm8kGMAodYItAlqZA++hqk73fY7i/akBHY0BO/WPJjqppH9Snno67eF2mLp43uOlTrKQWBp/mvHopXQfdvLGjH4Cq5byagUGx9h/vZ9R3cZS7MuAHrmt/uC5lVC0PWvuJNHrKifa0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XnKmuSKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XnKmuSKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8780CC32786;
	Tue, 23 Apr 2024 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908523;
	bh=amoAlcVgfnbfpFv0EL0jh799Ms1K/6U5gGIVbQeqiaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnKmuSKsMd8QiOxop+9IZ910+UqDehgplmAii3O8JS+tRewFgn2MobI2o0teZtPho
	 2zQNNk65ooYiCMB0CT3MT6XITDtsPvStCvHgN6nS3q25KBHaZdWDcP6wpYGHo5q6KU
	 JSlkb/mQR5RyKrlolqhCPLsQA/lIBebkPmSx4q3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 089/158] ALSA: seq: ump: Fix conversion from MIDI2 to MIDI1 UMP messages
Date: Tue, 23 Apr 2024 14:38:31 -0700
Message-ID: <20240423213858.843507708@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 sound/core/seq/seq_ump_convert.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -428,7 +428,7 @@ static int cvt_ump_midi2_to_midi1(struct
 	midi1->note.group = midi2->note.group;
 	midi1->note.status = midi2->note.status;
 	midi1->note.channel = midi2->note.channel;
-	switch (midi2->note.status << 4) {
+	switch (midi2->note.status) {
 	case UMP_MSG_STATUS_NOTE_ON:
 	case UMP_MSG_STATUS_NOTE_OFF:
 		midi1->note.note = midi2->note.note;



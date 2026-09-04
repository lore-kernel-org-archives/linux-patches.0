Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1B441D11A;
	Fri,  4 Sep 2026 06:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502566; cv=none; b=cnjYgwIYzTSqiQEPtdR1zVxP85OVsE5tb9jViBqEudrwqtHMexzpA9pdFFpjXY1CBfBN0D++ozP55KJPAwGuhf5/sTO8xt7flSkRvX8MvhgpfQz7qnyuBn5UtH3mLo6yA+HZbTelM++CvvNn0P+PZkvxs9mrBNjJQ1WMvLtnSFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502566; c=relaxed/simple;
	bh=kWd+lMcCMnhxP/ZA9ImlKoyEpn+Kx/QK11qPNR8DJEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC0eZmeQt6ltcyrYSLJfCt21nOyKvehZwLskOIJbAA5PkGcPJcNCP+gR7+vfcTGE4T5f3XEdZk7pZQTT6+ASYO1wVF+yZWosgR+kVvlb+gzmSjj8eviqbTzGFVH8gTMCZUSAVr5o8rC1InslIuEy6U8gyD77JUajY3SxCZCeloQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfqG5mGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfqG5mGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CA01F00A3D;
	Fri,  4 Sep 2026 06:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502564;
	bh=aZUDj4tH9AuALmbOT9CFboP6CLcpMIpmB2vcYewMRFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfqG5mGnHIHbYSOz8MFV5xC5QmhLqe3w3DSIB1ZwhtoXZNViC2hgJmREi0WXDoj+V
	 iCgbUrgbWDnvWUkks1r1B6NU9KmgV5wT/vTV9w7dd3i8tkYuBca66kdWc0B9LbAvj+
	 KDoF7QfRB6MfIkLoWbSlnEYCdbbXJIl4+4Vy7Ijw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 252/403] ALSA: ump: Fix corrupted data bytes at MIDI 1.0 SysEx to UMP conversion
Date: Fri,  4 Sep 2026 07:00:55 +0200
Message-ID: <20260904045740.600250094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

commit 8a906c0b4f1ba123a95c166f644d2383bf30a420 upstream.

The cvt_legacy_sysex_to_ump() initialises only the first word of the
output packet and ORs the data bytes into it.  The second word is left
alone, and the conversion context is kept across calls, so it still
carries the previous packet's bytes.  Those stale bits corrupt the new
data.  Any SysEx longer than six data bytes is affected.

A SysEx with the twelve data bytes 01..0c comes out as:

  30160102 03040506
  30260708 0b0e0f0e

The second packet declares six data bytes and four of them are wrong,
inside the declared length.

The sibling cvt_legacy_cmd_to_ump() already clears the second word.  Do
the same here.

Fixes: 0b5288f5fe63 ("ALSA: ump: Add legacy raw MIDI support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260808014554.3550153-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump_convert.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -258,6 +258,7 @@ static int cvt_legacy_sysex_to_ump(struc
 	else
 		status = UMP_SYSEX_STATUS_CONTINUE;
 	*data = ump_compose(UMP_MSG_TYPE_DATA, group, status, cvt->len);
+	data[1] = 0;
 	offset = 8;
 	for (i = 0; i < cvt->len; i++) {
 		*data |= cvt->buf[i] << offset;



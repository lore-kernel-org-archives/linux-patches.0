Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE9F4499B6;
	Mon, 31 Aug 2026 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183637; cv=none; b=poremH1IWPzanNdJRiPx2pzo4x06guqf/y6RTaBfV5EM1Xgt1pYB4Z7JZwokT62Nm/siq0azOIcrQzdx4khJJlgENl4Oq77zhVJkB/07OdRJHIN1HGbmRdIsD/b0GM9G0is/xPFBcTO8Yt/EAW+qTB5OQJE29u5py6Y4VXjDQHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183637; c=relaxed/simple;
	bh=cQ57fkDsDwzpmwIWoJvw1RgpgDlGKTY+eDCUJZP5RZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2qmCNQEG0P0imEtAmAmE7cQRBP/G1dU+ph524FL7Lrtcx4aUBpCmGtavD1Cu4fCkHc02MWwBo+F8Tn3OZaaw+Y/yZccyRp1C5TvIOJ5QrE+GqJZqggJflVfqJbLaeafS7cq71yQa5CECBooLfI4J4vaVDY3hGHxjbQpab9mxnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aI+UuBfZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aI+UuBfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA191F00ACF;
	Mon, 31 Aug 2026 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183636;
	bh=0348j7GgjD5nrT0ccFOpds++M7C2amy49q2o+LU81Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aI+UuBfZr7qq0WlYDt5z7hnf1Vz1qF5GqukT/bmbTqewwwiF7+tgtEkCUwev0iSEu
	 2LKBDeXzxP1xUnDsgOfp+u7Gmq72AFo0BJ5EXRFa0eDSenz5jtTT1XtouRKbkevuih
	 jYjc0fHsa73xvgI5LIqrVzYwnhz+BbopHHcN9kjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Vorhees <vorhees-work@proton.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 64/71] ALSA: usb-audio: Fix sample rates for PreSonus AudioBox USB
Date: Mon, 31 Aug 2026 15:34:29 +0200
Message-ID: <20260831133402.561766684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trevor Vorhees <vorhees-work@proton.me>

commit 21e958c4fd92d63139039430c246613505480689 upstream.

The fixed audio formats for the PreSonus AudioBox USB specify a discrete
rate mask but leave nr_rates at zero and rate_table unset.  find_format()
therefore rejects every requested rate, preventing the playback and
capture streams from being opened.

Add the advertised 44100 and 48000 Hz rates to both streams and report
their 24 significant bits.

Fixes: 34fe4a9df247 ("ALSA: usb-audio: Add quirk for PreSonus AudioBox USB")
Cc: stable@vger.kernel.org
Signed-off-by: Trevor Vorhees <vorhees-work@proton.me>
Link: https://patch.msgid.link/20260811-audiobox-usb-fix-v1-1-13c8b7f071ea@proton.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2692,6 +2692,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 			{
 				QUIRK_DATA_AUDIOFORMAT(2) {
 					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.fmt_bits = 24,
 					.channels = 2,
 					.iface = 2,
 					.altsetting = 1,
@@ -2703,11 +2704,16 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 						 SNDRV_PCM_RATE_48000,
 					.rate_min = 44100,
 					.rate_max = 48000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) {
+						44100, 48000
+					},
 				}
 			},
 			{
 				QUIRK_DATA_AUDIOFORMAT(3) {
 					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.fmt_bits = 24,
 					.channels = 2,
 					.iface = 3,
 					.altsetting = 1,
@@ -2719,6 +2725,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 						 SNDRV_PCM_RATE_48000,
 					.rate_min = 44100,
 					.rate_max = 48000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) {
+						44100, 48000
+					},
 				}
 			},
 			QUIRK_COMPOSITE_END



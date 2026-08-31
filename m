Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC752D2AA;
	Mon, 31 Aug 2026 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183886; cv=none; b=mN+MpfG/TjdWAaid4cQBrwktbK7gqatLvxca+TbJE2J5YomGeUkjxrKirSsanJIpy1fpLrrCNk0FWj7zcBd9WHXh8XvxA7uJxSkxsjLXKnw+/RAmI24xR36S/pgIoakk4CX7QX9p55Kjb7FGv4pCjZPXCLe+H1EaBV2FivGG0kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183886; c=relaxed/simple;
	bh=7mOIX5HIqCf6VA2kCoQwtNV7eIkGk59CPzsfvysvD00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG32WFII0b+XEFtTjOehZaFuXZuPQgeglv6bpH7bfSA7Cw7ON2ARY3KGHdZRz7VDahu88IEMLnsHO5/xUy8FaKhqVqBKCu+y0WWxjHRiyGnKFSaYu7u3adQ5FLidePKjtEHkBqCH5URcotEmBYGYbvBIL3wbHNF0Qi5MLatTkAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkpqYbyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkpqYbyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890A81F00A3D;
	Mon, 31 Aug 2026 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183885;
	bh=5FyqT/C2hURpK+gaC2GOKm0IPipjpdwCyoeNQBkDMnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkpqYbypoLD+fWSA0IEuk9Q7TplC55/1V1msW8cUeNo0ChyGnrHZDmqemecKOt5SJ
	 q4CmTcfp7icdPL/1do3NBbu0q7pqLucG8XBDIIn53JUmcI6EfGJF5YAKWYJxXkxwgL
	 rL3Y3wDxdIFUfwr0zPy182DT+tnziwq1Q562txAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Vorhees <vorhees-work@proton.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 69/76] ALSA: usb-audio: Fix sample rates for PreSonus AudioBox USB
Date: Mon, 31 Aug 2026 15:34:41 +0200
Message-ID: <20260831133402.970754180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2670,6 +2670,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 			{
 				QUIRK_DATA_AUDIOFORMAT(2) {
 					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.fmt_bits = 24,
 					.channels = 2,
 					.iface = 2,
 					.altsetting = 1,
@@ -2681,11 +2682,16 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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
@@ -2697,6 +2703,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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



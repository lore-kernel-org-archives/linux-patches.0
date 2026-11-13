Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585882;
	b=L5mDe9+/6fxUiHA/TsFqgrofArP7nA5IWguQxgNYcKAUVgdUjzVODfJhKvwOOCU0BTZL
	 +o2g1QvPzQ9po1Axl0UE8BBuK1sd6LtCcRrRSEyK0tVX4NFqX1p9ajAsL1BULN1RDtk+c
	 8TM6FT9l4rUM9IyKWGamKAMCqpyNvtWj8zWvM6//bDa6SzhgQVaJhmC9tdDEyUFL44qaP
	 3H4fiUcThqc+rvvntw942HspSuC6EH90l8sA5C25xqBIaZlHyfzYgzg8SHqTohlF6s3BR
	 XAjYlo6eXlha0VAv9wq11Fsz+ECjpUtwMLE1EbLqFZlPWG/a5YK4xUcFRuq5dR1srkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KKrduEmvRFqtzKHTLpySWZwUzoskZ4dC5kkXrAD/XvE=;
	b=1fJYFAEtHdGuhu9wq9e3hYO6Zx5pE4jopeNEdhhh2RkotatITtvjgfmO0SSZPhYIJqYH
	 gk6ubo3hdLDy+cEyVjCp2fQweqbEcH+n3KecgrwFzJ/qw5MwvicHFKZ6Tk8PEJlCaC6DP
	 LxdI8LAAfxIx0qveVIhKtZsffUj6O7amx//wSZyCiMYO67JqSmtlaJkzLMSp7FpAQ+Owu
	 5MdwyuOP+RvFxwkgkBGdyqW6KvLsTB5Ritfu6NH7d0BoPnNkOM+NAfq2AAK7ix1w6Tkjd
	 enx2+MSgTFM32LqB4aFgH7zHNg0Pxx1gUYax6wkvqw/dvswtGmyhrSJ6P3MYzruE9Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDjBMJny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DBB606EAA7;
	Fri, 13 Nov 2026 16:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDjBMJny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208731F000C7;
	Fri, 13 Nov 2026 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585882;
	bh=KKrduEmvRFqtzKHTLpySWZwUzoskZ4dC5kkXrAD/XvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDjBMJny3TkTjWwQkcDu2Ru27XcRb/offFZuB3/hiSX8kOT/oxxU+DUeHYmNyy134
	 0Jr4OuL/fXSBDjRJPwH79VJhuk6CBDmSThPzym42qbL8Do2AAZg141FaHa45RWUO34
	 NOfezD1C6WYjt9rnf0/ZYOcFqsXDO0E9Y1EAauvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Hobson <nicholas.hobson@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 450/507] ALSA: usb-audio: keep MIDI input running for Roland TD-11
Date: Fri, 13 Nov 2026 10:52:34 -0500
Message-ID: <20261113153811.983501276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Hobson <nicholas.hobson@outlook.com>

[ Upstream commit 2e4c9ab2574eeaa7b893c7d35b4a9f60fd681ddd ]

The TD-11 hands MIDI handling off to the host once connected via
USB. If no MIDI input port is opened on the host, the device itself
becomes unusable as a standalone instrument until its input is
serviced, independent of anything happening on the computer.

Add a per-device keep_input_running flag, set for the TD-11 in
snd_usbmidi_detect_roland(), and check it alongside the existing
opened[1] check in snd_usbmidi_input_start()/snd_usbmidi_input_stop()
so that input is started at device creation and never stopped for
these devices, regardless of whether a client has the input port
open.

Signed-off-by: Nicholas Hobson <nicholas.hobson@outlook.com>
Link: https://patch.msgid.link/MN2PR15MB3472557AF39DC3A4CA9E753FF8BD2@MN2PR15MB3472.namprd15.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 19b42c1fff7f ("ALSA: usb-audio: Protect Roland control activation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 7e5b1b13360f0..353217b3629b7 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -113,6 +113,7 @@ struct snd_usb_midi {
 	unsigned int opened[2];
 	unsigned char disconnected;
 	unsigned char input_running;
+	unsigned char keep_input_running;
 
 	struct snd_kcontrol *roland_load_ctl;
 };
@@ -1172,7 +1173,7 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 			snd_usbmidi_input_start(&umidi->list);
 	} else {
 		umidi->opened[dir]--;
-		if (!umidi->opened[1])
+		if (!umidi->opened[1] && !umidi->keep_input_running)
 			snd_usbmidi_input_stop(&umidi->list);
 		if (!umidi->opened[0] && !umidi->opened[1]) {
 			if (umidi->roland_load_ctl) {
@@ -2262,6 +2263,10 @@ static int snd_usbmidi_detect_roland(struct snd_usb_midi *umidi,
 	struct usb_host_interface *hostif;
 	u8 *cs_desc;
 
+	/* TD-11 becomes unusable if input isn't serviced continuously */
+	if (umidi->usb_id == USB_ID(0x0582, 0x0151))
+		umidi->keep_input_running = 1;
+
 	intf = umidi->iface;
 	if (!intf)
 		return -ENOENT;
@@ -2469,7 +2474,7 @@ void snd_usbmidi_input_start(struct list_head *p)
 	int i;
 
 	umidi = list_entry(p, struct snd_usb_midi, list);
-	if (umidi->input_running || !umidi->opened[1])
+	if (umidi->input_running || (!umidi->opened[1] && !umidi->keep_input_running))
 		return;
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
 		snd_usbmidi_input_start_ep(umidi, umidi->endpoints[i].in);
@@ -2644,6 +2649,10 @@ int __snd_usbmidi_create(struct snd_card *card,
 	if (err < 0)
 		goto exit;
 
+	/* start input for devices that need continuous servicing */
+	if (umidi->keep_input_running)
+		snd_usbmidi_input_start(&umidi->list);
+
 	usb_autopm_get_interface_no_resume(umidi->iface);
 
 	list_add_tail(&umidi->list, midi_list);
-- 
2.53.0




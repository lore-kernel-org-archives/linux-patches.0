Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6FC228CA3;
	Tue,  6 May 2025 21:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567397; cv=none; b=BVEDZKs2UmWwnQbn4IANG3sp9OAYg/hVr1pIUoQ4h714UzEBtXQCEWWuL0N33jZlOfWaLbIPy6gemXYtkELC2e4dZCS2mbWygkc2/l2vpg0ZtcMZK/XV5rJP/KMjIUIaetmVSCw1XSiLESUVR/B2SWWNXVgiufSxjVBwOHVTLBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567397; c=relaxed/simple;
	bh=SyCbsSksxFRmZW0apmLnPJYYchzfA3iSIEsLMCoA+b4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nj/h+81TAvMk0APt1lTP4IghKc7OFjzOD+PPBhaYaY0AzkvfD9Cg04dJvBv/6xcrQ06cTSwLpynn8eyDeNBwMh5hw6QICGMZFhBJt4BCpZsB5dDvDxBKSuYmfU7oQlaTMW5cx3uffIQxffeVe6ZHGSd6vg25h5og7jAs+BB2GDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCFi0pdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCFi0pdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50622C4CEE4;
	Tue,  6 May 2025 21:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567397;
	bh=SyCbsSksxFRmZW0apmLnPJYYchzfA3iSIEsLMCoA+b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCFi0pdhBilxEuqbGtEZZ6DiwLeDT1eOCINZLqicpGTKKUbALtsGmxig72JLXdUqM
	 /HImziRZT4NGTuFoosX1yUyepolCvos2xoDXvpy+9HQuBfOItaLhSpBP2pcTVv7/ax
	 NbeVC9TgCeVQju9rfhdmnGv4vx/j7NYI7MTMIOeh61dXdT2QVVJYCNjIJKlXxyx6VV
	 JlwVagSLjwk+myGKp5e/gj/rYrnjfVsuRKczXRmn9TIRE1bVT/GyvmIfiSomKracl7
	 ZMCGWol4qVyq3F3z7t/mBFp5K6QVSZK9nHpYycIHkAO56h2ADwapCKvNIJF4GytWVF
	 SwBdrnX/H7PEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Paul Davis <paul@linuxaudiosystems.com>,
	Sasha Levin <sashal@kernel.org>,
	clemens@ladisch.de,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 13/18] ALSA: usb-audio: Fix duplicated name in MIDI substream names
Date: Tue,  6 May 2025 17:36:05 -0400
Message-Id: <20250506213610.2983098-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0759e77a6d9bd34a874da73721ce4a7dc6665023 ]

The MIDI substream name string is constructed from the combination of
the card shortname (which is taken from USB iProduct) and the USB
iJack.  The problem is that some devices put the product name to the
iJack field, too.  For example, aplaymidi -l output on the Lanchkey MK
49 are like:

  % aplaymidi -l
  Port    Client name            Port name
  44:0    Launchkey MK4 49       Launchkey MK4 49 Launchkey MK4
  44:1    Launchkey MK4 49       Launchkey MK4 49 Launchkey MK4

where the actual iJack name can't be seen because it's truncated due
to the doubly words.

For resolving those situations, this patch compares the iJack string
with the card shortname, and drops if both start with the same words.
Then the result becomes like:

  % aplaymidi -l
  Port    Client name            Port name
  40:0    Launchkey MK4 49       Launchkey MK4 49 MIDI In
  40:1    Launchkey MK4 49       Launchkey MK4 49 DAW In

A caveat is that there are some pre-defined names for certain
devices in the driver code, and this workaround shouldn't be applied
to them.  Similarly, when the iJack isn't specified, we should skip
this check, too.  The patch added those checks in addition to the
string comparison.

Suggested-by: Paul Davis <paul@linuxaudiosystems.com>
Tested-by: Paul Davis <paul@linuxaudiosystems.com>
Link: https://lore.kernel.org/CAFa_cKmEDQWcJatbYWi6A58Zg4Ma9_6Nr3k5LhqwyxC-P_kXtw@mail.gmail.com
Link: https://patch.msgid.link/20250429183626.20773-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 826ac870f2469..a792ada18863a 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1885,10 +1885,18 @@ static void snd_usbmidi_init_substream(struct snd_usb_midi *umidi,
 	}
 
 	port_info = find_port_info(umidi, number);
-	name_format = port_info ? port_info->name :
-		(jack_name != default_jack_name  ? "%s %s" : "%s %s %d");
-	snprintf(substream->name, sizeof(substream->name),
-		 name_format, umidi->card->shortname, jack_name, number + 1);
+	if (port_info || jack_name == default_jack_name ||
+	    strncmp(umidi->card->shortname, jack_name, strlen(umidi->card->shortname)) != 0) {
+		name_format = port_info ? port_info->name :
+			(jack_name != default_jack_name  ? "%s %s" : "%s %s %d");
+		snprintf(substream->name, sizeof(substream->name),
+			 name_format, umidi->card->shortname, jack_name, number + 1);
+	} else {
+		/* The manufacturer included the iProduct name in the jack
+		 * name, do not use both
+		 */
+		strscpy(substream->name, jack_name);
+	}
 
 	*rsubstream = substream;
 }
-- 
2.39.5


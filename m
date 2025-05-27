Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1A82566;
	Tue, 27 May 2025 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368291; cv=none; b=lzHmROCdem6QHoZr58WkUosK7dVlVe3dHPJb3VKB4cEJlpTDpDO3XqafQA8mwJ2QYgYfK7NtUhEmRXjdVGWTV2p3gXYUxhK0YKTP2s/bzAc5LpItC1s1ayY3BdAAqibWmq+6sTHSkerkUH53lPjbH4TUyjYlkBnnzFJcEY4Xs74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368291; c=relaxed/simple;
	bh=5fHM6fzvDMJTLXGRu70B/0Ittb5TPLStMNyBCma9kNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMuDBRfb3smkXe6aRZGTqZGaGEUlYrmYuTkYukIyOmJBm3e0t8H97/dP+sOqMz6CL6NSKYYuGau4xV9rChNPX/4u+77oue77gRdScwPGsJbiVsn4rghd9f8ZECS+4gpnELO0VDGE1RKgSxJDIPPJlffv5avBM9+SPA3TpHin1zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmZE9pck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmZE9pck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A72EC4CEE9;
	Tue, 27 May 2025 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368291;
	bh=5fHM6fzvDMJTLXGRu70B/0Ittb5TPLStMNyBCma9kNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmZE9pck6qQbvMtYKmp22nU0H6zfFRGUL6vBKECBP8rdr5CddaedhxjBkIJqXqze2
	 EJxB4hWczxzaHz3ySeoREexwFPsQFrz4F4R66Mcm3cOL7N7Q6kTw5QOFx8cuo6lpeG
	 4rAqH0XgSJ0BJAtnJEspnTSWa4U6fqwnAhxrBjK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Davis <paul@linuxaudiosystems.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 660/783] ALSA: usb-audio: Fix duplicated name in MIDI substream names
Date: Tue, 27 May 2025 18:27:37 +0200
Message-ID: <20250527162540.004631520@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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




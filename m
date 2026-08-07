Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2A04746B7;
	Fri,  7 Aug 2026 15:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117288; cv=none; b=SxFWBLle7DY2YwxLUCIknNMm8Qm81WekQYBH0Uz2QjTAVajZ3P/rnujD58SxySrbmt869m0iTGhTqJsXdtFlvj57Lyt7aw3nCwLYy/1dahnVVUTskeeaO7DLNdia8PZ8mAVcJdrIQZzrRiw0qol2KxfrRaTN+nNr4rCQ5sBXZKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117288; c=relaxed/simple;
	bh=tkL3CmMZ728ViEiwcoVmoMZa4yjlEYb1y+L1fhy3eKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOw++Ys9vqPJLtNott3mq7jeTqAIDuIyqWoSVA+culi+SnZtaslhX7wUFwYgSM7I2lc0e1q5Hmxe/sjetog/HMBWRJ5sMD/8IEiHKG9Y9gLZV+n50J1qxm11IelDdePSIFmHuLpSTZuFoON05XfQq7EkKrEPfcd+UbBk+vEzMR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNm95BDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNm95BDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5261F000E9;
	Fri,  7 Aug 2026 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117287;
	bh=TZmFJJyI78qr68yNsP+zYOYQ3OOEjzD3c99SslcPxfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNm95BDmn+S/jv1s9ZSfvpWMkDNheUaHpP19667KEM+QyHnXl8b7k02LQSF9h7raH
	 SRmUXI1hzOcSVlb5mZqgvp9zrOe+GzTAla9JXOKOCgAogvdzDrn35k6YHk/BMvRwQN
	 J7pMbVwCLqE/PVDwQuts/K6oWqHS0tyS4CiYRQvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 267/438] ALSA: usb-audio: fix use-after-free in ump_to_endpoint()
Date: Fri,  7 Aug 2026 16:37:43 +0200
Message-ID: <20260807143433.681704955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit 4a05b2d1b4642df74f30b6f54843e825c4a2bfd3 upstream.

create_midi2_ump() registers a card-owned snd_ump_endpoint and stores a
back-pointer to its per-interface snd_usb_midi2_ump object in
ump->private_data, but it never installs an ump->private_free hook and
never clears that pointer.

If a later step of snd_usb_midi_v2_create() fails, its error path calls
free_all_midi2_umps(), which kfree()s the snd_usb_midi2_ump object while
the already-registered endpoint keeps pointing at it.  The created
/dev/snd/umpC*D* node stays exposed, so the first operation of any UMP
open, ump_to_endpoint(), dereferences the dangling ump->private_data and
reads rmidi->eps[dir] out of freed memory.

A malicious USB MIDI 2.0 device that makes creation fail after the
endpoint is registered can thus trigger a slab use-after-free read on a
subsequent open of the UMP node.

Clear the endpoint's back-pointer before freeing the object, and let
ump_to_endpoint() tolerate a NULL private_data so the open/close/trigger
callbacks fail cleanly (their callers already handle a NULL endpoint)
instead of dereferencing a stale pointer.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: ff49d1df79ae ("ALSA: usb-audio: USB MIDI 2.0 UMP support")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260726051337.41124-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -329,7 +329,7 @@ ump_to_endpoint(struct snd_ump_endpoint
 {
 	struct snd_usb_midi2_ump *rmidi = ump->private_data;
 
-	return rmidi->eps[dir];
+	return rmidi ? rmidi->eps[dir] : NULL;
 }
 
 /* ump open callback */
@@ -685,6 +685,8 @@ static void free_all_midi2_umps(struct s
 		rmidi = list_first_entry(&umidi->rawmidi_list,
 					 struct snd_usb_midi2_ump, list);
 		list_del(&rmidi->list);
+		if (rmidi->ump)
+			rmidi->ump->private_data = NULL;
 		kfree(rmidi);
 	}
 }



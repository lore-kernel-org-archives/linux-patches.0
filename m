Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3203955FB;
	Fri,  7 Aug 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114165; cv=none; b=oXUrdgF8kLFz9fdGMsHh3YsG196VYK5a1CqoBNsxuvq8EjRGZZhe3jPiS2KkpKzuCX4PmWFZ8/ZrP40ScffZvKXetn4u1YqWvmOxr3n47qEPD06inQ6JYsz8oEuJyexCPdUfeuBo84fEgNubwz2J9+rqinMoE3nNfAQ1l77/AFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114165; c=relaxed/simple;
	bh=nMj5F7cMdUhS6rEDXfvxLxmmgoBasv3o2w8qxeOVtdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyuCpkx5p5TYCBT4I0V3oR96hdb3MqYD2KwEIAZ1FQNa+E0olBrrmmG5QmaH6do0yOGi7QNwK0YS8yLA7HDw41PRDjuVjTBGt1bFp6Aj04vpcHwvnSqkryOyV4fkf9kQqT/eDXPUjFz+euiUFScNsXIduH7mDGUHr9pQISzibns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmEAMZ44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmEAMZ44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112D21F000E9;
	Fri,  7 Aug 2026 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114164;
	bh=Z1KpVtJZKpgygLdqE2JtQfCoAHA9BoEer7NlpToQJQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmEAMZ44sbD9B14/DYyoYMeSQPGy4yN8+G1d9lFKiy2QKZIfBOIcehSD9fwx4cIcj
	 77k/CkWgBlbOfMryBeKnqwv/4pehtx9uZRx/go6pd4lrYNYZzaDavGAwwtayoU5ZQ3
	 M03pdd3g6Mlc/VfXWfHpF8Z2aRAd0gs8qimvV3y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 165/337] ALSA: usb-audio: fix use-after-free in ump_to_endpoint()
Date: Fri,  7 Aug 2026 16:36:08 +0200
Message-ID: <20260807143422.130206432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -337,7 +337,7 @@ ump_to_endpoint(struct snd_ump_endpoint
 {
 	struct snd_usb_midi2_ump *rmidi = ump->private_data;
 
-	return rmidi->eps[dir];
+	return rmidi ? rmidi->eps[dir] : NULL;
 }
 
 /* ump open callback */
@@ -693,6 +693,8 @@ static void free_all_midi2_umps(struct s
 		rmidi = list_first_entry(&umidi->rawmidi_list,
 					 struct snd_usb_midi2_ump, list);
 		list_del(&rmidi->list);
+		if (rmidi->ump)
+			rmidi->ump->private_data = NULL;
 		kfree(rmidi);
 	}
 }



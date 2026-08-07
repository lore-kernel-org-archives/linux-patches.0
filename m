Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C132351C2F;
	Fri,  7 Aug 2026 15:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115261; cv=none; b=cKz4R8Sp2/3ZBQyU6NfAO5YVp/OjejyIsmD8gPEl7riFgttTZ3KZ2gYdqgVUUye5MI+OaF9z7aUda7MoRMzb4MNw0HsNA4L3obQFigmbweeCy6afHClrDvvZm0awrUWaVnT0vJjr1GSNW3LsC9rJiAs/8pLRxKxSuKSGf9VmYXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115261; c=relaxed/simple;
	bh=Xuf9Njb0eoVceNjiid+GZIiN4LpROD8nohIJ5Qdhz+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGPJGD4pDp5nkoIMYYr7I1JagOrqu+ZfjyvUhaX854y2rMuEWgzvEoln+rlCpsfdUNxrcFNQg9ZwVxjDQ7FOK2bDq4HN0DIMxLn56K1torJFKx/iSDlmeXCkPFlvdQseCkAE6TBx2ZyOl5AcgmP85URMoMbEhAAp69sNqDEhIL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YearK7PQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YearK7PQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D471F000E9;
	Fri,  7 Aug 2026 15:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115260;
	bh=tCK08DvNMO5t/VoEuFfVRxUsJHoAvMi+i+sbTgCgOHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YearK7PQeRd9Wq05a2RAekF799Ckxon7ZGG6gD8pefPGUbam8XveKpp9PVWIeHdH3
	 cIbh5wDlr9R7mRkDFk7cpT6pi26y1AR8qKUGmxhwZ85QxFQo3s31kSo3xIzolALWlu
	 Q3rLlWcm5yyasT9IZkx+dBdNZFs73QG3158ihl68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 214/396] ALSA: usb-audio: fix use-after-free in ump_to_endpoint()
Date: Fri,  7 Aug 2026 16:36:14 +0200
Message-ID: <20260807143428.884451858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



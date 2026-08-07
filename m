Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94795418372;
	Fri,  7 Aug 2026 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115241; cv=none; b=lGIviMbnuPsY65AAWTPEdmrgbevkts+NQUQyzSsF4LFwlLEUepghd0EcCLZHNZ3TEvpqvRdO8FogG3JXr3z5ECwu1loh7Rb4Ts/bijpmWln8+XD8uBwM+l83fCz/iYnRsWt7+WaE8Hmb0OlhnyEBvm+wg0fFDTqhjDZPhXWkSvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115241; c=relaxed/simple;
	bh=2I7zPkFtDHURPBoOxcFNfnZm7wZ8C5uv3gZDidZiYi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nb+jiZWq6I+4JuWK7Ku9lcpOEo2NoIL3w1E0d4KybqtuqdgmV9FRZxZJV5OMIh+iWkXlqk8l0oRHToPE9OF2bfuvK9sxzfOUswOpK5oBYNZqvUNF9+e5SNaPzwgbGSylw4mwEyMV7Xs/UGWZRoCDWPu8C0TlWHY7ZTPIoFpxRgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=na8ONF/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="na8ONF/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0E21F000E9;
	Fri,  7 Aug 2026 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115240;
	bh=szABoJldtRaR7DYlpGDuFzQsSxlWGaW3NpOYHogGtJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=na8ONF/KDG0VF7pyw7KvXAex//VXT9iNVuwtEjBP17cX0G1h0kIwG5johV6v0HfZ3
	 MplBm4FYmrkSlQAglA8Zjnlg56yOG8Q+OZjYSW5tPq5XV17sAqRZdr6/ayUlHzWcO2
	 0nRyy/WT9fygjhvuD/7NZRmSbyvcO/5uVv2OQ+v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 207/396] ALSA: ump: fix double free of out_cvts on rawmidi error
Date: Fri,  7 Aug 2026 16:36:07 +0200
Message-ID: <20260807143428.742047675@linuxfoundation.org>
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

commit 70c977815af0d997feb2d0c5d284d55689bf7051 upstream.

snd_ump_attach_legacy_rawmidi() allocates the legacy conversion array
ump->out_cvts and, on the snd_rawmidi_new() error path, frees it with
kfree() but leaves ump->out_cvts pointing at the freed memory.  When the
endpoint is later torn down, snd_ump_endpoint_free() frees ump->out_cvts
a second time, resulting in a double free.

The host snd-usb-audio driver attaches the legacy rawmidi for any USB
MIDI 2.0 (UMP) device, so a device that makes snd_rawmidi_new() fail
reaches this path on enumeration.

Clear ump->out_cvts after freeing it on the error path so it is not
freed again during teardown.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 33cd7630782d ("ALSA: ump: Export MIDI1 / UMP conversion helpers")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260726051633.41206-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -1366,6 +1366,7 @@ int snd_ump_attach_legacy_rawmidi(struct
 			      &rmidi);
 	if (err < 0) {
 		kfree(ump->out_cvts);
+		ump->out_cvts = NULL;
 		return err;
 	}
 



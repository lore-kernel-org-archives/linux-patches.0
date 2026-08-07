Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059CA1C84D0;
	Fri,  7 Aug 2026 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116106; cv=none; b=HTOTFs09b7o76rY8rA4O4nY8fOaY0gNyjMyAyJ5uoA0mnFhaPFZ+cfWAWvsFNqvJNtdz2EnWwNmmD/2C5m4ee0yPHxE797XBzEvv43lHd5lSr8mWnSNN7eIdvRIVIFZESJIEPXGhXPY20Hj/DzzK8r9wsbUzVu9yLnh4NWXwYpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116106; c=relaxed/simple;
	bh=mYthdjBnxYDglXbNR4nTSRI2bBErv6nYBB0mzWeIq0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb8FX0NAetJpya80n+jexdrtdEIgUh3S/GcafUeJWfQLYZ9/0ZsAk5n/ipnZa7/X/TC+KmWD4GANCpAI9ZSYO236Qce/9kH65wmzEU4V96vn11rk3uhd8U1DKf3W7iKIQilSj2xy0IK2owzJcYPaXD/exJfSl/O8Aqq5gLRkKG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6Hirky8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6Hirky8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9A51F000E9;
	Fri,  7 Aug 2026 15:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116104;
	bh=Fk9DhUBxNBzF7yAv18IhVtM0eZ4W+Ntn0TM64rYv/RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6Hirky8QxaGzOb8qCkAZnak0/0t9M2qbRvla4c7UlZp+18h8cYB1Qz85mTcrnjDm
	 vx5DGEmnBPqGozFf6VU76HWElZ4zEoWNUvPylDKVaJ2ffGtkRKzKhUA4OeitO96Ugf
	 Ht6wdz/H84sc4EYMsR+0DOO98sJ+yehNFwfzEsE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 112/261] ALSA: ump: fix double free of out_cvts on rawmidi error
Date: Fri,  7 Aug 2026 16:37:49 +0200
Message-ID: <20260807143417.795895897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1286,6 +1286,7 @@ int snd_ump_attach_legacy_rawmidi(struct
 			      &rmidi);
 	if (err < 0) {
 		kfree(ump->out_cvts);
+		ump->out_cvts = NULL;
 		return err;
 	}
 



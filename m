Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FC42FF641;
	Fri,  7 Aug 2026 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114148; cv=none; b=Oes9xeXD3VH1ITi/LVUsf1pgiw5rDPdiSpQ4giNrUovJoufthy80OzR07C09r+D/3I7Wq7PCzOd/BHDAEf+NTew4ImvWb9krfmEhQEmf2KnN3UUR8biN82OG8ORFl+wBoOwanJ/B3hMwPy3AqgIFsdCXwQiOxINLFAoInmWKA6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114148; c=relaxed/simple;
	bh=Q0GhqOK23MG8jmziCt/zl7gCl1xd33+yKAGHQWA2hws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNftC2llupvb0q6fqJITRRub6L2oBeasMQNRPm9ZPwAAswkEWLXdOwspKlRYYtwjQaCDATfMzOY2g+EUDBeir6OAl7q9vnV28/UhGWapIsHIgxDo59GeWK9nuqaCRn/RBz0ZFmNiu0bNZCLtHu6q4adHcXenVJtlhWmgp+81/1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwsDkszg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwsDkszg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D80C1F000E9;
	Fri,  7 Aug 2026 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114147;
	bh=aZPFAftzy4lVppX3ZnuFyvb0t4TDE84rMuz/G5LDIBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwsDkszg/LclQEu9XlBrUl9GYMWLZDiN8K1FBLu79EpwiUjGBM9jcKau3OO5rq7Jf
	 wweVWMqHbrBNXf7K3qPbgyEGp72qOHWnmekMrz0JNASb4TWtc2tsh5Hwf7RYLoQWf9
	 6hS5OWJkMKz/s6Wt+dd9f6XEAfARS+GWYCYjT4ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 160/337] ALSA: ump: fix double free of out_cvts on rawmidi error
Date: Fri,  7 Aug 2026 16:36:03 +0200
Message-ID: <20260807143422.020042329@linuxfoundation.org>
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
@@ -1297,6 +1297,7 @@ int snd_ump_attach_legacy_rawmidi(struct
 			      &rmidi);
 	if (err < 0) {
 		kfree(ump->out_cvts);
+		ump->out_cvts = NULL;
 		return err;
 	}
 



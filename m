Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D26726B0BB;
	Thu, 13 Feb 2025 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459457; cv=none; b=CsbNvBMgsOtBUzTjCIA2Sqz46SEJgu/h0PZ5a62BZ072TslBilrj4QkTDNsTg9hQiGSrenmN5Lk7kBlM/6yR481WMlYD4URP3aK/nSJ845XqSmvRSmBPA5wBMXqQHt33cEwdy4SUWY/MlFmkFaoVfCCCQyfGzRURWU9lVbCeDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459457; c=relaxed/simple;
	bh=F0lWGcre5OAC3iQ3jaIN7oI+lGer6ox9kP8w0O2aMUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPDNZrCVLpq7KC+j6iZTQ0BgYlR9/qoivq7Fwf0WQo1H2LVlJdf/cxG/+xfbXJPIGqerTWKy6ETQTVHmI+wm05buydhWTMmCRYzCSTRxE3HUoV/0UiQ6Ij3XUAY4Fl9FiTz+BJVPm7ExaTiDEfG4PiKmBCHI3fPL8LVxsXvkdgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILqqCHY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILqqCHY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFA2C4CED1;
	Thu, 13 Feb 2025 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459457;
	bh=F0lWGcre5OAC3iQ3jaIN7oI+lGer6ox9kP8w0O2aMUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILqqCHY+rodhkRL5sp4yolQHUbLhbp5Js3H4iF2kVw9vj7ArS4EBDcO6R1Ga9ikmc
	 bc8792Qz7lCCQWiDx711yNfTn4n9x2rrY8kQQT9yfhB5gET0HZ5WXgNPNqK/L3A4pW
	 NqjsKdsNNTCwuO87Ix5Qe4ZhcLXcfewtkLJFFViQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austrum <austrum.lab@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 269/443] ALSA: hda: Fix headset detection failure due to unstable sort
Date: Thu, 13 Feb 2025 15:27:14 +0100
Message-ID: <20250213142450.993261921@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 3b4309546b48fc167aa615a2d881a09c0a97971f upstream.

The auto_parser assumed sort() was stable, but the kernel's sort() uses
heapsort, which has never been stable. After commit 0e02ca29a563
("lib/sort: optimize heapsort with double-pop variation"), the order of
equal elements changed, causing the headset to fail to work.

Fix the issue by recording the original order of elements before
sorting and using it as a tiebreaker for equal elements in the
comparison function.

Fixes: b9030a005d58 ("ALSA: hda - Use standard sort function in hda_auto_parser.c")
Reported-by: Austrum <austrum.lab@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219158
Tested-by: Austrum <austrum.lab@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://patch.msgid.link/20250128165415.643223-1-visitorckw@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_auto_parser.c |    8 +++++++-
 sound/pci/hda/hda_auto_parser.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_auto_parser.c
+++ b/sound/pci/hda/hda_auto_parser.c
@@ -80,7 +80,11 @@ static int compare_input_type(const void
 
 	/* In case one has boost and the other one has not,
 	   pick the one with boost first. */
-	return (int)(b->has_boost_on_pin - a->has_boost_on_pin);
+	if (a->has_boost_on_pin != b->has_boost_on_pin)
+		return (int)(b->has_boost_on_pin - a->has_boost_on_pin);
+
+	/* Keep the original order */
+	return a->order - b->order;
 }
 
 /* Reorder the surround channels
@@ -400,6 +404,8 @@ int snd_hda_parse_pin_defcfg(struct hda_
 	reorder_outputs(cfg->speaker_outs, cfg->speaker_pins);
 
 	/* sort inputs in the order of AUTO_PIN_* type */
+	for (i = 0; i < cfg->num_inputs; i++)
+		cfg->inputs[i].order = i;
 	sort(cfg->inputs, cfg->num_inputs, sizeof(cfg->inputs[0]),
 	     compare_input_type, NULL);
 
--- a/sound/pci/hda/hda_auto_parser.h
+++ b/sound/pci/hda/hda_auto_parser.h
@@ -37,6 +37,7 @@ struct auto_pin_cfg_item {
 	unsigned int is_headset_mic:1;
 	unsigned int is_headphone_mic:1; /* Mic-only in headphone jack */
 	unsigned int has_boost_on_pin:1;
+	int order;
 };
 
 struct auto_pin_cfg;



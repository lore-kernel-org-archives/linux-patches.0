Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46CE1DC184;
	Wed, 19 Feb 2025 09:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957132; cv=none; b=H8WWSI13nSEvTwN66JIx5adUWx3OSDl6dEDyQA/YmmW9zLdyYg8o8y6GJAGiByxt2Dy7rO01cqd/fGHQSLjmlhJDgwV++oGRKP2m8Z7mwJTvChWL3Ilwj9gRS44LzFdCflAbhUxC7mjbziRltDV54GaImg4ucmXM9CoaPcGX+DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957132; c=relaxed/simple;
	bh=UO33rKJ0eSqAir8Z/0tfu4klFSUTzyMMOOO1tI0+SKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2Yi0/eZgPIrbF5FOVqT2Og0dzVWQ4yAo219YqxzazQpp46kzQ0zoF48EMrnTrAoekF36/yWGJisxU49tO4tZJWCpdqThZJUtY85pE4DSQUYBG7YVzJ+QiHRnhenvlHINK4/qBGg1Q9U6uDMVwlRku3ctvqEs7dJ8rIDvhGoJUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHqXqAM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHqXqAM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0037C4CED1;
	Wed, 19 Feb 2025 09:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957132;
	bh=UO33rKJ0eSqAir8Z/0tfu4klFSUTzyMMOOO1tI0+SKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHqXqAM1n34AJJKEiItotMOlK6zfkSjh+WeiovhXlWIsJ9WYQLcrnbBNVp/2ijQkv
	 OgdmDMU88iZ3R4fuoVt4MvuhUYtjrj9hAmUP+IyADt3ojcQ7rABeD2dpYBFjCe+XEb
	 SoesCGdB9oMzgt62+ZA/UFjIc2ntUjqdmG8ui7Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austrum <austrum.lab@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 388/578] ALSA: hda: Fix headset detection failure due to unstable sort
Date: Wed, 19 Feb 2025 09:26:32 +0100
Message-ID: <20250219082708.288227789@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -35,6 +35,7 @@ struct auto_pin_cfg_item {
 	unsigned int is_headset_mic:1;
 	unsigned int is_headphone_mic:1; /* Mic-only in headphone jack */
 	unsigned int has_boost_on_pin:1;
+	int order;
 };
 
 struct auto_pin_cfg;



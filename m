Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B37527425B;
	Thu, 13 Feb 2025 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457893; cv=none; b=dghELyYCxZVOHASU7ofZPbVS63ssdbuzMa/J43X+RZ848jQMZTE3S3YHkLNwt1Mf7N649ElPcbzIAV8ghXZv1gepNGKe4WJbA/0dsEp6ZNPfnFTLm8IuHx3tZVv9kzM6f/5/n7oO1twApmLv2NqTvSWXMSL1o7mhJqOVnzb4g2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457893; c=relaxed/simple;
	bh=YlBbr10/TQzKvytrZXrwOKgCdjbxvL4Xniit941emDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1tJtqHkd0mheh4UVLmn1JUNQnFLyDmRWEAwFYpGLz5/s/j6n4iGJS4rb3AS/WEaXx7KUiPYR46qZbtc1iz+7f5QP7/x4Sm5nOfP0sP5N/l9RmwHTvIadcr7YwMEkI40gLR35s9t7ouuV9OmbuO5wnpfkGSTPamAXkVBZkjCHO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqYWbslM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqYWbslM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C028DC4CEE7;
	Thu, 13 Feb 2025 14:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457893;
	bh=YlBbr10/TQzKvytrZXrwOKgCdjbxvL4Xniit941emDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqYWbslMQk493d+yGPmVEjkHB5qbNNIoGk9SE3z7lRyzJwRzCICAUk4JWK/Wv/NsF
	 aNxNmVBv89ieA+/V5uXg777+OFJvoOg2lQqC9hQlqDJ6ADGHt2J+k90lYR8Cn9RDuf
	 ytRl7rkAygkJi0OlpquqFvOrdLe6+0Xp81sfOdT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austrum <austrum.lab@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 244/422] ALSA: hda: Fix headset detection failure due to unstable sort
Date: Thu, 13 Feb 2025 15:26:33 +0100
Message-ID: <20250213142445.953521787@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



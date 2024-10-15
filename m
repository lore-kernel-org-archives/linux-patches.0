Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079F21D0492;
	Tue, 15 Oct 2024 11:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993418; cv=none; b=Fr7DCLfAE4kXTWe0tYpQd88A5/1shweCSfgc8lZ4FbdkvXNu6Hm3GjnQgj5mqGK6PLjFb9Rto2QI5WJyGcKbIWj9xWSpbAip+/2xALYE5VCPelwI3UEGarnDFtxuRAH96u/LE2QLTt2zByctczXycsDeGlkWO224fLPkkDFaZ1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993418; c=relaxed/simple;
	bh=9mBYgKcEOLKY1a0jf08nVLoTgUqCXHpdRJ0crs8GfEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuBo+AyZGJGXwxJPSXDZxZQ8iXQU+EM/ABOpfruYXBlNszD5WNYFaWCzs06VNA3B/pQd575aEgCLQvNJb9e9YY2j06kw1JZ2YjvXiyAMeCcAXWz61TqsGtCtR1JPu5uxZPT4DxapgzJcmh28b+gx0K2tMuX/us5ZKkGCJl37DXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P95ezFVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P95ezFVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC7DC4CEC6;
	Tue, 15 Oct 2024 11:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993417;
	bh=9mBYgKcEOLKY1a0jf08nVLoTgUqCXHpdRJ0crs8GfEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P95ezFVH1meORVJleZAj5/A447QtxeJrYVgfBwyCT5Z9lLUfgxsgz6m17Jc9qG5dJ
	 7IjHubXEI0+LCPWMXhfNxAYWUNka3fCWcQFIjrHNxiG6Fh1ka0DM3g7+7tiB3gz1oC
	 OiTTewn1/kCKTSb2+6Wy0FP/xhSlRiFoBSCj/CC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Jerry <jerryluo225@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 405/691] ALSA: hda/conexant: Fix conflicting quirk for System76 Pangolin
Date: Tue, 15 Oct 2024 13:25:53 +0200
Message-ID: <20241015112456.418151742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b3ebb007060f89d5a45c9b99f06a55e36a1945b5 ]

We received a regression report for System76 Pangolin (pang14) due to
the recent fix for Tuxedo Sirius devices to support the top speaker.
The reason was the conflicting PCI SSID, as often seen.

As a workaround, now the codec SSID is checked and the quirk is
applied conditionally only to Sirius devices.

Fixes: 4178d78cd7a8 ("ALSA: hda/conexant: Add pincfg quirk to enable top speakers on Sirius devices")
Reported-by: Christian Heusel <christian@heusel.eu>
Reported-by: Jerry <jerryluo225@gmail.com>
Closes: https://lore.kernel.org/c930b6a6-64e5-498f-b65a-1cd5e0a1d733@heusel.eu
Link: https://patch.msgid.link/20241004082602.29016-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 83d976e3442c4..5b296cacb3896 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -820,6 +820,23 @@ static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
 	{}
 };
 
+/* pincfg quirk for Tuxedo Sirius;
+ * unfortunately the (PCI) SSID conflicts with System76 Pangolin pang14,
+ * which has incompatible pin setup, so we check the codec SSID (luckily
+ * different one!) and conditionally apply the quirk here
+ */
+static void cxt_fixup_sirius_top_speaker(struct hda_codec *codec,
+					 const struct hda_fixup *fix,
+					 int action)
+{
+	/* ignore for incorrectly picked-up pang14 */
+	if (codec->core.subsystem_id == 0x278212b3)
+		return;
+	/* set up the top speaker pin */
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		snd_hda_codec_set_pincfg(codec, 0x1d, 0x82170111);
+}
+
 static const struct hda_fixup cxt_fixups[] = {
 	[CXT_PINCFG_LENOVO_X200] = {
 		.type = HDA_FIXUP_PINS,
@@ -980,11 +997,8 @@ static const struct hda_fixup cxt_fixups[] = {
 		.v.pins = cxt_pincfg_sws_js201d,
 	},
 	[CXT_PINCFG_TOP_SPEAKER] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x1d, 0x82170111 },
-			{ }
-		},
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_sirius_top_speaker,
 	},
 };
 
-- 
2.43.0




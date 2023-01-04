Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C964AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFD7C433EF;
	Wed,  4 Jan 2023 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848629;
	bh=bSxn4xf8KId17UMJ89aDpG4EAI1V/Fp5KrN7yF3JUU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8yb5jasKCFMgpJE4cF+IOEgTSoxzGWX15/DCkj7JTnDXq0FN4bbpgTPXjBgXzDeB
	 SF+bg5ufwWKmxjl+5SLzHB4K+cdILAsCmk5vymGKgcg5mXbCLwEugyEXtUpFzxPl5t
	 13zCUrY8btrf7kZnjJr6cMIJoqamV62KppaFFO2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eray=20Or=C3=A7unus?= <erayorcunus@gmail.com>,
	Ike Panhc <ike.pan@canonical.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/207] platform/x86: ideapad-laptop: Add new _CFG bit numbers for future use
Date: Wed,  4 Jan 2023 17:05:02 +0100
Message-Id: <20230104160513.308482006@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eray Orçunus <erayorcunus@gmail.com>

[ Upstream commit be5dd7d8359de9fb22115a63f09981cdf689db4f ]

Later IdeaPads report various things in last 8 bits of _CFG, at least
5 of them represent supported on-screen-displays. Add those bit numbers
to the enum, and use CFG_OSD_ as prefix of their names. Also expose
the values of these bits to debugfs, since they can be useful.

Signed-off-by: Eray Orçunus <erayorcunus@gmail.com>
Acked-by: Ike Panhc <ike.pan@canonical.com>
Link: https://lore.kernel.org/r/20221029120311.11152-5-erayorcunus@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 33 +++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 7192e0d2a14f..125b4534424f 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -46,10 +46,22 @@ static const char *const ideapad_wmi_fnesc_events[] = {
 #endif
 
 enum {
-	CFG_CAP_BT_BIT   = 16,
-	CFG_CAP_3G_BIT   = 17,
-	CFG_CAP_WIFI_BIT = 18,
-	CFG_CAP_CAM_BIT  = 19,
+	CFG_CAP_BT_BIT       = 16,
+	CFG_CAP_3G_BIT       = 17,
+	CFG_CAP_WIFI_BIT     = 18,
+	CFG_CAP_CAM_BIT      = 19,
+
+	/*
+	 * These are OnScreenDisplay support bits that can be useful to determine
+	 * whether a hotkey exists/should show OSD. But they aren't particularly
+	 * meaningful since they were introduced later, i.e. 2010 IdeaPads
+	 * don't have these, but they still have had OSD for hotkeys.
+	 */
+	CFG_OSD_NUMLK_BIT    = 27,
+	CFG_OSD_CAPSLK_BIT   = 28,
+	CFG_OSD_MICMUTE_BIT  = 29,
+	CFG_OSD_TOUCHPAD_BIT = 30,
+	CFG_OSD_CAM_BIT      = 31,
 };
 
 enum {
@@ -387,6 +399,19 @@ static int debugfs_cfg_show(struct seq_file *s, void *data)
 		seq_puts(s, " camera");
 	seq_puts(s, "\n");
 
+	seq_puts(s, "OSD support:");
+	if (test_bit(CFG_OSD_NUMLK_BIT, &priv->cfg))
+		seq_puts(s, " num-lock");
+	if (test_bit(CFG_OSD_CAPSLK_BIT, &priv->cfg))
+		seq_puts(s, " caps-lock");
+	if (test_bit(CFG_OSD_MICMUTE_BIT, &priv->cfg))
+		seq_puts(s, " mic-mute");
+	if (test_bit(CFG_OSD_TOUCHPAD_BIT, &priv->cfg))
+		seq_puts(s, " touchpad");
+	if (test_bit(CFG_OSD_CAM_BIT, &priv->cfg))
+		seq_puts(s, " camera");
+	seq_puts(s, "\n");
+
 	seq_puts(s, "Graphics: ");
 	switch (priv->cfg & 0x700) {
 	case 0x100:
-- 
2.35.1




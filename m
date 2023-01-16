Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B49633EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2086EC433EF;
	Mon, 16 Jan 2023 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884542;
	bh=tGDKCpBdcqwHeqtLKtrq6/42JSMWZ9Q1z/GMens71e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mr3UViMjQQED79Zz431WnXP8t1bSkO97fktEz3VQNfPkz0vxXTGaaMPPxgpEVBDIn
	 Cejk3HJxgbAbJ4X5jjLgyIzk24dk3o7MUxU4npadc74a7xm40AqbMSIUa5gVHp9AmS
	 EAzbJzwQrrg+Q9mz8rztDcdu0Z6TAjDdzRDDcV0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 046/183] platform/x86: dell-privacy: Only register SW_CAMERA_LENS_COVER if present
Date: Mon, 16 Jan 2023 16:49:29 +0100
Message-Id: <20230116154805.318220962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 6dc485f9940df8105ea729cbeb7a7d18d409dde5 upstream.

Unlike keys where userspace only reacts to keypresses, userspace may act
on switches in both (0 and 1) of their positions.

For example if a SW_TABLET_MODE switch is registered then GNOME will not
automatically show the onscreen keyboard when a text field gets focus on
touchscreen devices when SW_TABLET_MODE reports 0 and when SW_TABLET_MODE
reports 1 libinput will block (filter out) builtin keyboard and touchpad
events.

So to avoid unwanted side-effects EV_SW type inputs should only be
registered if they are actually present, only register SW_CAMERA_LENS_COVER
if it is actually there.

Fixes: 8af9fa37b8a3 ("platform/x86: dell-privacy: Add support for Dell hardware privacy")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221221220724.119594-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-privacy.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/dell/dell-wmi-privacy.c
+++ b/drivers/platform/x86/dell/dell-wmi-privacy.c
@@ -292,7 +292,7 @@ static int dell_privacy_wmi_probe(struct
 {
 	struct privacy_wmi_data *priv;
 	struct key_entry *keymap;
-	int ret, i;
+	int ret, i, j;
 
 	ret = wmi_has_guid(DELL_PRIVACY_GUID);
 	if (!ret)
@@ -318,9 +318,20 @@ static int dell_privacy_wmi_probe(struct
 	/* remap the keymap code with Dell privacy key type 0x12 as prefix
 	 * KEY_MICMUTE scancode will be reported as 0x120001
 	 */
-	for (i = 0; i < ARRAY_SIZE(dell_wmi_keymap_type_0012); i++) {
-		keymap[i] = dell_wmi_keymap_type_0012[i];
-		keymap[i].code |= (0x0012 << 16);
+	for (i = 0, j = 0; i < ARRAY_SIZE(dell_wmi_keymap_type_0012); i++) {
+		/*
+		 * Unlike keys where only presses matter, userspace may act
+		 * on switches in both of their positions. Only register
+		 * SW_CAMERA_LENS_COVER if it is actually there.
+		 */
+		if (dell_wmi_keymap_type_0012[i].type == KE_VSW &&
+		    dell_wmi_keymap_type_0012[i].sw.code == SW_CAMERA_LENS_COVER &&
+		    !(priv->features_present & BIT(DELL_PRIVACY_TYPE_CAMERA)))
+			continue;
+
+		keymap[j] = dell_wmi_keymap_type_0012[i];
+		keymap[j].code |= (0x0012 << 16);
+		j++;
 	}
 	ret = sparse_keymap_setup(priv->input_dev, keymap, NULL);
 	kfree(keymap);



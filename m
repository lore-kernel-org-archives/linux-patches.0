Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1724B1C1AAA;
	Tue, 12 Aug 2025 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025374; cv=none; b=UN24U8eKSrD4uLlYBCIQbGHm4QKrzO5IAx8CRhbRSqJa4s2w2ZQXT8r9b7wFJDpyEcw+JdiHsFpkap1pbxwOgabHUEM6tKdrK2ZDxDicGhh8QNu/EDEjmSZVbeM+Xl97Kzzyps/NY/cwJy/wsn3eDUQf6ZS5mJhICWdFnCGm4bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025374; c=relaxed/simple;
	bh=XfM/kPSafs0k6BQxB0DcKOVxzXSHwtQ6cz5K8qvH/Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWOVRK53KybtKAZ7Q6Ak8Cz5TbLuuFEZAKNoYVKwORvyRwskJXMng7t8x5l0qM59vkmFsNakZau6csRPGZUGEKkQaCd24s4RWrADDmL2V3rY1uwemabCEYizKzcnVWYzUOSBNYTTuFtJpmbUhcnY9IdI7226I5oam/4VK8u52kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEfidSj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEfidSj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79960C4CEF0;
	Tue, 12 Aug 2025 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025374;
	bh=XfM/kPSafs0k6BQxB0DcKOVxzXSHwtQ6cz5K8qvH/Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEfidSj6cfhWCAXjLZt2RjkpWfWvvSg5f0x8Uc/Xnx5Tz58mhAtMRo5MgD0ll0r2Q
	 vX+67cQ1GLDs5uWXKnZQaneOK0kSVd6JxfXVANqagxARI9dsbCYEvGYkQmWPLdi/Qr
	 rP7qDcemD7ACHXj9aVwUf7duAZ6vpOaKYsduQxsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Brian Howard <blhoward2@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 005/480] ALSA: hda/cs35l56: Workaround bad dev-index on Lenovo Yoga Book 9i GenX
Date: Tue, 12 Aug 2025 19:43:33 +0200
Message-ID: <20250812174357.530454813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 40b1c2f9b299295ed0482e1fee6f46521e6e79e5 ]

The Lenovo Yoga Book 9i GenX has the wrong values in the cirrus,dev-index
_DSD property. Add a fixup for this model to ignore the property and
hardcode the index from the I2C bus address.

The error in the cirrus,dev-index property would prevent the second amp
instance from probing. The component binding would never see all the
required instances and so there would not be a binding between
patch_realtek.c and the cs35l56 driver.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reported-by: Brian Howard <blhoward2@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220228
Link: https://patch.msgid.link/20250714110154.204740-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 110 +++++++++++++++++++++++++++---------
 1 file changed, 82 insertions(+), 28 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 235d22049aa9..c9c8ec8d2474 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -874,6 +874,52 @@ static int cs35l56_hda_system_resume(struct device *dev)
 	return 0;
 }
 
+static int cs35l56_hda_fixup_yoga9(struct cs35l56_hda *cs35l56, int *bus_addr)
+{
+	/* The cirrus,dev-index property has the wrong values */
+	switch (*bus_addr) {
+	case 0x30:
+		cs35l56->index = 1;
+		return 0;
+	case 0x31:
+		cs35l56->index = 0;
+		return 0;
+	default:
+		/* There is a pseudo-address for broadcast to both amps - ignore it */
+		dev_dbg(cs35l56->base.dev, "Ignoring I2C address %#x\n", *bus_addr);
+		return 0;
+	}
+}
+
+static const struct {
+	const char *sub;
+	int (*fixup_fn)(struct cs35l56_hda *cs35l56, int *bus_addr);
+} cs35l56_hda_fixups[] = {
+	{
+		.sub = "17AA390B", /* Lenovo Yoga Book 9i GenX */
+		.fixup_fn = cs35l56_hda_fixup_yoga9,
+	},
+};
+
+static int cs35l56_hda_apply_platform_fixups(struct cs35l56_hda *cs35l56, const char *sub,
+					     int *bus_addr)
+{
+	int i;
+
+	if (IS_ERR(sub))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cs35l56_hda_fixups); i++) {
+		if (strcasecmp(cs35l56_hda_fixups[i].sub, sub) == 0) {
+			dev_dbg(cs35l56->base.dev, "Applying fixup for %s\n",
+				cs35l56_hda_fixups[i].sub);
+			return (cs35l56_hda_fixups[i].fixup_fn)(cs35l56, bus_addr);
+		}
+	}
+
+	return 0;
+}
+
 static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 {
 	u32 values[HDA_MAX_COMPONENTS];
@@ -898,39 +944,47 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 		ACPI_COMPANION_SET(cs35l56->base.dev, adev);
 	}
 
-	property = "cirrus,dev-index";
-	ret = device_property_count_u32(cs35l56->base.dev, property);
-	if (ret <= 0)
-		goto err;
-
-	if (ret > ARRAY_SIZE(values)) {
-		ret = -EINVAL;
-		goto err;
-	}
-	nval = ret;
+	/* Initialize things that could be overwritten by a fixup */
+	cs35l56->index = -1;
 
-	ret = device_property_read_u32_array(cs35l56->base.dev, property, values, nval);
+	sub = acpi_get_subsystem_id(ACPI_HANDLE(cs35l56->base.dev));
+	ret = cs35l56_hda_apply_platform_fixups(cs35l56, sub, &id);
 	if (ret)
-		goto err;
+		return ret;
 
-	cs35l56->index = -1;
-	for (i = 0; i < nval; i++) {
-		if (values[i] == id) {
-			cs35l56->index = i;
-			break;
-		}
-	}
-	/*
-	 * It's not an error for the ID to be missing: for I2C there can be
-	 * an alias address that is not a real device. So reject silently.
-	 */
 	if (cs35l56->index == -1) {
-		dev_dbg(cs35l56->base.dev, "No index found in %s\n", property);
-		ret = -ENODEV;
-		goto err;
-	}
+		property = "cirrus,dev-index";
+		ret = device_property_count_u32(cs35l56->base.dev, property);
+		if (ret <= 0)
+			goto err;
 
-	sub = acpi_get_subsystem_id(ACPI_HANDLE(cs35l56->base.dev));
+		if (ret > ARRAY_SIZE(values)) {
+			ret = -EINVAL;
+			goto err;
+		}
+		nval = ret;
+
+		ret = device_property_read_u32_array(cs35l56->base.dev, property, values, nval);
+		if (ret)
+			goto err;
+
+		for (i = 0; i < nval; i++) {
+			if (values[i] == id) {
+				cs35l56->index = i;
+				break;
+			}
+		}
+
+		/*
+		 * It's not an error for the ID to be missing: for I2C there can be
+		 * an alias address that is not a real device. So reject silently.
+		 */
+		if (cs35l56->index == -1) {
+			dev_dbg(cs35l56->base.dev, "No index found in %s\n", property);
+			ret = -ENODEV;
+			goto err;
+		}
+	}
 
 	if (IS_ERR(sub)) {
 		dev_info(cs35l56->base.dev,
-- 
2.39.5




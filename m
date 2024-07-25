Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11DD13C816;
	Thu, 25 Jul 2024 14:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919243; cv=none; b=KqN2VcFiVCZrrVGH1rC0xUE+4ifJOoRJEoibWskz4oIKt4WpvOCAWm2ae6Do2L7mkqGFjQkfpBhESPJ8WJ5FZTMvKukvqClEnuVWo5A33MjTptuq6glbEZ0na/ml7I/lc/LtbYZ7xefMWN8zvG/FZaA3vZe9rMsIe/URAWkX0ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919243; c=relaxed/simple;
	bh=BXpxJviUXyVHnwH2k9sS4gs21yxWWw7Cuqh+MM3GHPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiX99DTL876z97OzZ6E4s1Z83SVCcZPAxKVsy3EY/foFn20uVXU7y+suqB5rtp2/Vh5HrbfTEtz9cDUFiQMemjC8xi/VFn1lwk9V1T/G2iWZ1Eu1hqqmqJGDGdR4kJH9x+1+fTUoTumQplcx83SbqETI059bRbIazNKyXZzWipo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KELEiBzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KELEiBzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B26C32782;
	Thu, 25 Jul 2024 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919243;
	bh=BXpxJviUXyVHnwH2k9sS4gs21yxWWw7Cuqh+MM3GHPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KELEiBzzznFlnNOd4C70vrys0d1FdR8uipIK+u3ltaDoWlmP0ed9Rys2bVzDYPqsw
	 +ytIdQBERKSg0qEdJM7VPKyQw3KhNFS/FDqJTWCFxbz2BWLRqzbTgm1SeIoH2WeyZg
	 0zhJ7htb7qvmZrNP/quNK3uQPCIYfBA/+OC2bFjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/87] Input: elantech - fix touchpad state on resume for Lenovo N24
Date: Thu, 25 Jul 2024 16:37:09 +0200
Message-ID: <20240725142739.796165373@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

From: Jonathan Denose <jdenose@google.com>

[ Upstream commit a69ce592cbe0417664bc5a075205aa75c2ec1273 ]

The Lenovo N24 on resume becomes stuck in a state where it
sends incorrect packets, causing elantech_packet_check_v4 to fail.
The only way for the device to resume sending the correct packets is for
it to be disabled and then re-enabled.

This change adds a dmi check to trigger this behavior on resume.

Signed-off-by: Jonathan Denose <jdenose@google.com>
Link: https://lore.kernel.org/r/20240503155020.v2.1.Ifa0e25ebf968d8f307f58d678036944141ab17e6@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/elantech.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 4e38229404b4b..b4723ea395eb9 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1476,16 +1476,47 @@ static void elantech_disconnect(struct psmouse *psmouse)
 	psmouse->private = NULL;
 }
 
+/*
+ * Some hw_version 4 models fail to properly activate absolute mode on
+ * resume without going through disable/enable cycle.
+ */
+static const struct dmi_system_id elantech_needs_reenable[] = {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+	{
+		/* Lenovo N24 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "81AF"),
+		},
+	},
+#endif
+	{ }
+};
+
 /*
  * Put the touchpad back into absolute mode when reconnecting
  */
 static int elantech_reconnect(struct psmouse *psmouse)
 {
+	int err;
+
 	psmouse_reset(psmouse);
 
 	if (elantech_detect(psmouse, 0))
 		return -1;
 
+	if (dmi_check_system(elantech_needs_reenable)) {
+		err = ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_DISABLE);
+		if (err)
+			psmouse_warn(psmouse, "failed to deactivate mouse on %s: %d\n",
+				     psmouse->ps2dev.serio->phys, err);
+
+		err = ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE);
+		if (err)
+			psmouse_warn(psmouse, "failed to reactivate mouse on %s: %d\n",
+				     psmouse->ps2dev.serio->phys, err);
+	}
+
 	if (elantech_set_absolute_mode(psmouse)) {
 		psmouse_err(psmouse,
 			    "failed to put touchpad back into absolute mode.\n");
-- 
2.43.0




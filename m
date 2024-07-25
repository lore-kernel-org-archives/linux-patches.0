Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B24519B5BE;
	Thu, 25 Jul 2024 14:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918419; cv=none; b=hP9NQMUYYUDwUE2UFFDXOxbXAhoBhj4L86lMLa5Lofk9FWDyxaeU2sfTwWHMeZ6ecL7+pnKCMhfRWTk15Ir+bbnvczVudv0R3/ls1xGnUd0S2Ax1MVWQ58Zf0AC3LTh5Ei2qHC8YSf1+bOuyN/+tQP1L4uskBDJEs312CwPCU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918419; c=relaxed/simple;
	bh=Uznm5XQ7pDkI+EqaTVim7jGzpUFCultt7m4JMcbyouk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2hX4clpCfEvJGEpLzTC5ZvUyEQaoYdlYyUptwXGMGF1LkEULfpTQoJJvowqORpU+3Rml3nDr4RD+/4nMR1MBPOfUMq7S9npAnci9tvLFSv3vLa+3amHt0eSc+1ndeEY1uG03bfKHMWjxnTQhCo3Gmbak2R2D2YpLI+9567WhJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/f0kfD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/f0kfD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDA5C116B1;
	Thu, 25 Jul 2024 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918419;
	bh=Uznm5XQ7pDkI+EqaTVim7jGzpUFCultt7m4JMcbyouk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/f0kfD7TJBSF/3oH9RgHbTYXCMP/5Bw00LlOOmM7ir2D9g+pq1AgH2yHedlGKONR
	 /zkQsQuAajwlMxXPQwQnr3iHmH5zH80lpf9oqLiFDHS1Y3XNvUkWJrt04o4TjEjbGz
	 n2P3id3Bcbb7tbV77jQMDemVvL3cwblKfcezj944=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Denose <jdenose@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/33] Input: elantech - fix touchpad state on resume for Lenovo N24
Date: Thu, 25 Jul 2024 16:36:37 +0200
Message-ID: <20240725142729.058584185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6759cab82a723..6f747c59cd652 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1527,16 +1527,47 @@ static void elantech_disconnect(struct psmouse *psmouse)
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




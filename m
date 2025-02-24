Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FDB18A6BA;
	Mon, 24 Feb 2025 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407902; cv=none; b=PTC9snXWyPBw6hldPRwOjJ/X5xzR0S+uyyCRjDNll/5AamuPEYFdWwrEagBm74UWQUu2g694Ly/dPMwVSwroNnW5z0pcDSfH5VU4Aq8K6O0lkbsE3H/joZHGGW28pkmScsol7fbIc9QyJ6G9XztuV4HbNkKpoWZwzobtU3JJvis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407902; c=relaxed/simple;
	bh=vQjHUjVppY9mxgN8nonIdf4I8/S9eHjQw+2PCellyKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVX16jnej2jI2J8f0aJBMHEJs6CCMLCfgWrMHcJw6uBmAyYs1TECzsSFi9u1Fwf68gYnuTF5HCO4p0zvvdnkLRjmMce6ply3K+miS30XGgSJ9xmM0PSP/CHvC9r9s4RA/qFHnvk3lfMxOExOKequ0X2CXuadMqr1a6VV10W53SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kw1n2Iek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kw1n2Iek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C209C4CEE6;
	Mon, 24 Feb 2025 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407902;
	bh=vQjHUjVppY9mxgN8nonIdf4I8/S9eHjQw+2PCellyKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kw1n2Iekr9jkCwPLmOFSHSuyKGvjIouhaZ5PLBbJj06TJEWqHf2+N5IbcTw6JMse1
	 +Srsn/7TZsSOnoL9C2VIp4vr2LWPE4adLOJwu/DELyvyuAo+DOtHJpxF9xvzZC691I
	 Dx4/HEoS5gxJ9fPYcvLWOZ28L1Yi3l04JkEIneyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/140] Input: synaptics - fix crash when enabling pass-through port
Date: Mon, 24 Feb 2025 15:34:02 +0100
Message-ID: <20250224142604.702047436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 08bd5b7c9a2401faabdaa1472d45c7de0755fd7e ]

When enabling a pass-through port an interrupt might come before psmouse
driver binds to the pass-through port. However synaptics sub-driver
tries to access psmouse instance presumably associated with the
pass-through port to figure out if only 1 byte of response or entire
protocol packet needs to be forwarded to the pass-through port and may
crash if psmouse instance has not been attached to the port yet.

Fix the crash by introducing open() and close() methods for the port and
check if the port is open before trying to access psmouse instance.
Because psmouse calls serio_open() only after attaching psmouse instance
to serio port instance this prevents the potential crash.

Reported-by: Takashi Iwai <tiwai@suse.de>
Fixes: 100e16959c3c ("Input: libps2 - attach ps2dev instances as serio port's drvdata")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1219522
Cc: stable@vger.kernel.org
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/Z4qSHORvPn7EU2j1@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 56 ++++++++++++++++++++++++---------
 drivers/input/mouse/synaptics.h |  1 +
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index cff3393f0dd00..26677432ac836 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -667,23 +667,50 @@ static void synaptics_pt_stop(struct serio *serio)
 	serio_continue_rx(parent->ps2dev.serio);
 }
 
+static int synaptics_pt_open(struct serio *serio)
+{
+	struct psmouse *parent = psmouse_from_serio(serio->parent);
+	struct synaptics_data *priv = parent->private;
+
+	guard(serio_pause_rx)(parent->ps2dev.serio);
+	priv->pt_port_open = true;
+
+	return 0;
+}
+
+static void synaptics_pt_close(struct serio *serio)
+{
+	struct psmouse *parent = psmouse_from_serio(serio->parent);
+	struct synaptics_data *priv = parent->private;
+
+	guard(serio_pause_rx)(parent->ps2dev.serio);
+	priv->pt_port_open = false;
+}
+
 static int synaptics_is_pt_packet(u8 *buf)
 {
 	return (buf[0] & 0xFC) == 0x84 && (buf[3] & 0xCC) == 0xC4;
 }
 
-static void synaptics_pass_pt_packet(struct serio *ptport, u8 *packet)
+static void synaptics_pass_pt_packet(struct synaptics_data *priv, u8 *packet)
 {
-	struct psmouse *child = psmouse_from_serio(ptport);
+	struct serio *ptport;
 
-	if (child && child->state == PSMOUSE_ACTIVATED) {
-		serio_interrupt(ptport, packet[1], 0);
-		serio_interrupt(ptport, packet[4], 0);
-		serio_interrupt(ptport, packet[5], 0);
-		if (child->pktsize == 4)
-			serio_interrupt(ptport, packet[2], 0);
-	} else {
-		serio_interrupt(ptport, packet[1], 0);
+	ptport = priv->pt_port;
+	if (!ptport)
+		return;
+
+	serio_interrupt(ptport, packet[1], 0);
+
+	if (priv->pt_port_open) {
+		struct psmouse *child = psmouse_from_serio(ptport);
+
+		if (child->state == PSMOUSE_ACTIVATED) {
+			serio_interrupt(ptport, packet[4], 0);
+			serio_interrupt(ptport, packet[5], 0);
+			if (child->pktsize == 4)
+				serio_interrupt(ptport, packet[2], 0);
+		}
 	}
 }
 
@@ -722,6 +749,8 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 	serio->write = synaptics_pt_write;
 	serio->start = synaptics_pt_start;
 	serio->stop = synaptics_pt_stop;
+	serio->open = synaptics_pt_open;
+	serio->close = synaptics_pt_close;
 	serio->parent = psmouse->ps2dev.serio;
 
 	psmouse->pt_activate = synaptics_pt_activate;
@@ -1218,11 +1247,10 @@ static psmouse_ret_t synaptics_process_byte(struct psmouse *psmouse)
 
 		if (SYN_CAP_PASS_THROUGH(priv->info.capabilities) &&
 		    synaptics_is_pt_packet(psmouse->packet)) {
-			if (priv->pt_port)
-				synaptics_pass_pt_packet(priv->pt_port,
-							 psmouse->packet);
-		} else
+			synaptics_pass_pt_packet(priv, psmouse->packet);
+		} else {
 			synaptics_process_packet(psmouse);
+		}
 
 		return PSMOUSE_FULL_PACKET;
 	}
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 08533d1b1b16f..4b34f13b9f761 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -188,6 +188,7 @@ struct synaptics_data {
 	bool disable_gesture;			/* disable gestures */
 
 	struct serio *pt_port;			/* Pass-through serio port */
+	bool pt_port_open;
 
 	/*
 	 * Last received Advanced Gesture Mode (AGM) packet. An AGM packet
-- 
2.39.5




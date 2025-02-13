Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7841645;
	Thu, 13 Feb 2025 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459186; cv=none; b=uYpYphnyxdQ3cE2HhzQlY659Aa9fk3CA8n1UdjLvQ7WJV9WYFQCLSSAv2Z5e6kl/XKtrpt4w56Tqs36FnUgH4cH/dfE4wMRFsamRWnlsI7+G4JQjlw3iErz1dN07ppjaQ0l9VuBPtpRtaZKpMeOXgK81Q99Tm9xaaSs6VGgYP50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459186; c=relaxed/simple;
	bh=XalvmYgXc2SzIroHdvG1E6D3Gwu8uOwv75dfK+B6ZL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/F3Q+dV9njIfGETIIB63sx55IV/zX9iPDAEaqf96HQwuDzkThEj/uqXHUMLG5f333t/G2HYVFqI2ozNoc/IUK2Uo6KEsaGFWiGunJcWYnkJuIaJabWU2QDtPobNQJWwThPynfbfWXFtBJEh0GN4uFIN0UhXZRReHp5CAmGWAdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHlxI87E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHlxI87E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C56C4CED1;
	Thu, 13 Feb 2025 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459186;
	bh=XalvmYgXc2SzIroHdvG1E6D3Gwu8uOwv75dfK+B6ZL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHlxI87EfnokLbjHaTtym7WQMyOAdjatR/qayKHwSi1+Xzvvv3pnwVfotR+DCiCNG
	 AcvvlN2Saw2LvjzihOrpFxwvxrFau91gzQfTOoF6J3YdS5wmHiBhMbdVmHZmGlzsw9
	 BhUDM16pi9j6rIbto2OpSqBScs/zty2GxNlFXfdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 192/443] Input: synaptics - fix crash when enabling pass-through port
Date: Thu, 13 Feb 2025 15:25:57 +0100
Message-ID: <20250213142448.022143473@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 08bd5b7c9a2401faabdaa1472d45c7de0755fd7e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |   56 ++++++++++++++++++++++++++++++----------
 drivers/input/mouse/synaptics.h |    1 
 2 files changed, 43 insertions(+), 14 deletions(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -665,23 +665,50 @@ static void synaptics_pt_stop(struct ser
 	priv->pt_port = NULL;
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
 
@@ -720,6 +747,8 @@ static void synaptics_pt_create(struct p
 	serio->write = synaptics_pt_write;
 	serio->start = synaptics_pt_start;
 	serio->stop = synaptics_pt_stop;
+	serio->open = synaptics_pt_open;
+	serio->close = synaptics_pt_close;
 	serio->parent = psmouse->ps2dev.serio;
 
 	psmouse->pt_activate = synaptics_pt_activate;
@@ -1216,11 +1245,10 @@ static psmouse_ret_t synaptics_process_b
 
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
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -188,6 +188,7 @@ struct synaptics_data {
 	bool disable_gesture;			/* disable gestures */
 
 	struct serio *pt_port;			/* Pass-through serio port */
+	bool pt_port_open;
 
 	/*
 	 * Last received Advanced Gesture Mode (AGM) packet. An AGM packet



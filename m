Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F92322C88;
	Sat, 12 Sep 2026 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221067; cv=none; b=VAAPUcEKpOKrabHr9T+vm3P0OKeTOjANQQs5WV5pkyo0cjWDytTkOJmmcFVXPFE3Z6DX8xewfZkyoiNriI3CNb2tE30KSG4viv6Z309ZI/5U8xqNT8yr0IDOpE/BJUOKU2Cmjs/HXQ11ga2imhct8bjwPgtI91xzAtrKqnwDako=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221067; c=relaxed/simple;
	bh=1egqQ+Yql81RRCre7blC++VUDeJmgLbajIl3SNcToes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh8YQPY9fVG0lXgcsG/sY36/UjhB8rlge+7bBm3DUGpNspEwpndNA5b+WzezlMJZLDZOjNM6yf67prNJiyv6YqdfMnRsqIBirG/Rzd+oMmqcH6fr66xr/UulxuxYhOAMHs6MiMPQ/peLnceyX5mm6TEe/srGaJC0KSF2tRhgpS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxpm4cbp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxpm4cbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5431F000FF;
	Sat, 12 Sep 2026 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221065;
	bh=bfjn4R3SarLwc3BWCkrVSGAl18u79rqeoClryWhUJt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxpm4cbp8vViofKv+GCtoiFgZ1ZO369uD1meU8wFjuLyc1L/OEEEZ05hSyqs2Ko6l
	 IgnUBYMMuQuR3Djj1vACHju0LFNPysRRmhiU81I3/jTbZa3vUUfotY+h3EWn/Dm5mA
	 /JDbEcBf/65L/cg86P3URL1SChMQvtk+ylK4BdhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Figa <tfiga@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.6 0308/1424] platform/chrome: sensorhub: Fix dropped timestamp events and log spam
Date: Sat, 12 Sep 2026 08:45:40 +0200
Message-ID: <20260912065614.180214147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 9a3f43b30373c61477d0d3ab52946c05f9492bf9 upstream.

Commit 833740a2333c ("platform/chrome: sensorhub: Bound the EC-reported
sensor number") evaluated the `sensor_num` against the bounds limit even
for timestamp events.  A timestamp event typically has a `sensor_num` of
0xff [1], causing the driver to flag it as invalid and skip to the next
event.

As a result, we'd see a flooding of "Invalid sensor number 255 from EC"
warning logs and these timestamp events were being dropped.

Move the bounds-check into cros_ec_sensor_ring_process_event() and
evaluate it only after standalone timestamp events have already been
processed and returned early.

[1] https://crrev.com/219ca6ef82ba266da788b673ee4ad50bd3ea1285/common/motion_sense_fifo.c#427

Fixes: 833740a2333c ("platform/chrome: sensorhub: Bound the EC-reported sensor number")
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Link: https://lore.kernel.org/r/20260715024454.4127571-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_sensorhub_ring.c |   27 ++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/platform/chrome/cros_ec_sensorhub_ring.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
@@ -436,6 +436,21 @@ cros_ec_sensor_ring_process_event(struct
 						  fifo_timestamp,
 						  *current_timestamp,
 						  now);
+
+		/*
+		 * A standalone timestamp event typically has a sensor_num of
+		 * 0xff.  Return early here to prevent it from hitting the
+		 * bounds check below and spamming the logs.
+		 */
+		return false;
+	}
+
+	/* Skip event if sensor_num from EC is out of bounds. */
+	if (in->sensor_num >= sensorhub->sensor_num) {
+		dev_warn_ratelimited(sensorhub->dev,
+				     "Invalid sensor number %u from EC\n",
+				     in->sensor_num);
+		return false;
 	}
 
 	if (in->flags & MOTIONSENSE_SENSOR_FLAG_ODR) {
@@ -463,10 +478,6 @@ cros_ec_sensor_ring_process_event(struct
 		return true;
 	}
 
-	if (in->flags & MOTIONSENSE_SENSOR_FLAG_TIMESTAMP)
-		/* If we just have a timestamp, skip this entry. */
-		return false;
-
 	/* Regular sample */
 	out->sensor_id = in->sensor_num;
 	trace_cros_ec_sensorhub_data(in->sensor_num,
@@ -851,14 +862,6 @@ static void cros_ec_sensorhub_ring_handl
 
 		for (in = sensorhub->resp->fifo_read.data, j = 0;
 		     j < number_data; j++, in++) {
-			/* Skip event if sensor_num from EC is out of bounds. */
-			if (in->sensor_num >= sensorhub->sensor_num) {
-				dev_warn_ratelimited(sensorhub->dev,
-						     "Invalid sensor number %u from EC\n",
-						     in->sensor_num);
-				continue;
-			}
-
 			if (cros_ec_sensor_ring_process_event(
 						sensorhub, fifo_info,
 						fifo_timestamp,



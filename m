Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C312642C500;
	Fri,  4 Sep 2026 06:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503002; cv=none; b=QtKqOyWZsT5UF6i9uF1/73mM/TpMeWWOI+cZVKg0r9/QvS9nQ9MgBW6nZWyii4sL7czYI63UDPRbZ7SWwY+kJ2KAfhbTLvJMakSv2s+G8R3Mwph4IF5UobQHhwsy2ZH5HzK1DjQ6Felq+HKYxo67nqYfwlaYfwUeacaVFMzBaxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503002; c=relaxed/simple;
	bh=5Qu0W/YhcLMerkB4KTQWDjMuCxBKXBQ/2tunc6hYfp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRBG1sMlb8ZFMMdF/oFrAawygTWstZnPGpLwnl6mI2r1O7Si5LFkgH6E4aiuiIgwyYsiELQemIbmSi3wqR7ioztxTw5m43B0y5HKdhnG0cnbB/Ycuwcb71zLbdHviLWDaiTTt3EsbuDjqJakPEUyowZkJRkVt3HK3q9Acig303k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUVNzDaF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUVNzDaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280A21F00A3E;
	Fri,  4 Sep 2026 06:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788503001;
	bh=/HwKKPRTQOVRcpD4VZdMKWDR+gu5M91AledeH1kRmG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUVNzDaFZqn3eZqz5SoEFYVp4n7ryKCTHAnbzYsYFoeRTcTlqxEvdg1KFbFiAswDS
	 Lw9uCLZEfkFFeftIOXp269li6eJGWa2+934p+3Lr2eDc0Au4RnyO35xHeFQ3p2/NTF
	 FAjV6mL++jGCXMorlnBCO/DZoRM6gyYf77kW7MpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Figa <tfiga@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.12 403/403] platform/chrome: sensorhub: Fix dropped timestamp events and log spam
Date: Fri,  4 Sep 2026 07:03:26 +0200
Message-ID: <20260904045743.941632619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -464,6 +464,21 @@ cros_ec_sensor_ring_process_event(struct
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
@@ -491,10 +506,6 @@ cros_ec_sensor_ring_process_event(struct
 		return true;
 	}
 
-	if (in->flags & MOTIONSENSE_SENSOR_FLAG_TIMESTAMP)
-		/* If we just have a timestamp, skip this entry. */
-		return false;
-
 	/* Regular sample */
 	out->sensor_id = in->sensor_num;
 	trace_cros_ec_sensorhub_data(in->sensor_num,
@@ -879,14 +890,6 @@ static void cros_ec_sensorhub_ring_handl
 
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



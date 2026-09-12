Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B741F344DBD;
	Sat, 12 Sep 2026 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241712; cv=none; b=M9PNlYFbQY24Do7TzUDQe967bGHaQSM6Qt3mrw+qQKikouDeLDeCPSIZwXDTlK/aYdDFBof102QhXu5wTQNxZyQkXRy8xoSu0sHh4OWnTmfMbQUfIDSP9GfmyS4UP+xVMQ5EcuV1Vqg3tfa5FUZ09+P/Lrif3JBEFJfKMFOBC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241712; c=relaxed/simple;
	bh=1PgRTgQKMzfchKPYHmHhoJZV5DOJArngmONRdqqrVuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac1IPoqv3YRuMNhKd/o/MSutI7WWJBNKYyrQejkXHHkrnATCpPvMLJUR4OjZC1fHVkFx/KT1KhxMxJdozmajkub58NTGi/caC/R9VRBErnu0YZNq71NXUaE66n+dPL8BJofd2zOHLrl+7Wm73uh+76dutorxcD4E64srauPwTjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYP0qRMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYP0qRMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E9F1F000FF;
	Sat, 12 Sep 2026 19:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241711;
	bh=Jcmu+cEALjE5FkmIW98f0RFZDc7QHSoZpxrzndYeXbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYP0qRMwLDEz7et/TnpkIrOw5uf9YBy98sD4/tpFxaQUwIAo2UJjfLhMQKLAkBCVR
	 uAzsCZ3aRhbgLtQOMv0TYAu0lDR3bCXz+ZeldQYxoeVdx6XfTwEaigjxAsjDIEJ5Ea
	 Vbsd6rX5LOCQ+gviqAVnfF8YwocslzHzSA5IGWbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Figa <tfiga@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.10 190/798] platform/chrome: sensorhub: Fix dropped timestamp events and log spam
Date: Sat, 12 Sep 2026 08:56:58 +0200
Message-ID: <20260912065521.408412475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



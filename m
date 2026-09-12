Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF2232D7F8;
	Sat, 12 Sep 2026 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237081; cv=none; b=OmvdpYncAAdrR3gU1XbwKIAtXio8gRy1lomPApmyMUKOdq2k+b6zZqQ9LANj0K0hhq3a4j9aVIEbMIYvDrjMn2QU9fwc3i87O6QgoYPcPMX7ehIWNryhhnooq6yTpj1WyeZ2rQ/2HAm71fOwNJS11BcZ5iJdzslWVwHbFm91Hn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237081; c=relaxed/simple;
	bh=VzdrRWNBUmY+bAQX7gqqJZb/YSfNMob9QYp/Tgrlg0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTVdIqpaPE+XdUlLnAqLoZNQpbqq6DN1zWu0VgsB6FefXZTiDsqc/3VSFbsx+vue3eu5D1UXGi4tJvwKqUsp0rTdSmh9XeIXPOZ35C85tR/T9LL6dEmjhD9RVB8niuiS4suDNQh+mE7UOwrT+csw87LNzWZ1Gc8O8pCnY7xwgx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjUuWEWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjUuWEWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBF21F000FF;
	Sat, 12 Sep 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237079;
	bh=RQ5xBodKAW9bqpZ0ohxzf0o9NiSKNsZYo2oFpVruSPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjUuWEWSBoLi2Te/wm7XiX+634yCL67LACvTNhGd3yI5Z148EONMMBvOdeMiosjUO
	 wqDWZpyMHe+ghlWZRerOvva/UJsoC8uNbMw4j2oM0YxIfxrFO95xFR0DNkLkyxszLm
	 k2+IRo5scDwnv4m9IPjc4jyASP3ZLgG6g/cmwXEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.15 169/935] platform/chrome: sensorhub: Bound the EC-reported sensor number
Date: Sat, 12 Sep 2026 08:53:19 +0200
Message-ID: <20260912065530.693235990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 833740a2333c2e4db4e02e3d0ffba04e8718a5f3 upstream.

Each EC FIFO event carries an 8-bit sensor number (in->sensor_num).
cros_ec_sensorhub_ring_handler() validates the FIFO event count, the
per-read count and the ring bound, but not the sensor number, which
cros_ec_sensor_ring_process_event() then uses unchecked to index
sensorhub->batch_state[] - allocated with only sensorhub->sensor_num
entries. A sensor number of sensor_num or larger is an out-of-bounds
read and write of batch_state[].

Validate the sensor number in the ring handler, where each event is read
from the EC, and drop a malformed event before it is used.

Fixes: 145d59baff59 ("platform/chrome: cros_ec_sensorhub: Add FIFO support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://lore.kernel.org/r/20260618-b4-disp-adb3f790-v3-1-3a164ed63cbd@proton.me
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_sensorhub_ring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/chrome/cros_ec_sensorhub_ring.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
@@ -851,6 +851,14 @@ static void cros_ec_sensorhub_ring_handl
 
 		for (in = sensorhub->resp->fifo_read.data, j = 0;
 		     j < number_data; j++, in++) {
+			/* Skip event if sensor_num from EC is out of bounds. */
+			if (in->sensor_num >= sensorhub->sensor_num) {
+				dev_warn_ratelimited(sensorhub->dev,
+						     "Invalid sensor number %u from EC\n",
+						     in->sensor_num);
+				continue;
+			}
+
 			if (cros_ec_sensor_ring_process_event(
 						sensorhub, fifo_info,
 						fifo_timestamp,



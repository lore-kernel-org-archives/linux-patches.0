Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E851A13B;
	Thu, 17 Sep 2026 17:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666502; cv=none; b=Vsokok86UBk0YnoQWEgnRTub837XBETKl1UkBxiNtRXm4qDBbHjjnzd4WHNhl8KSE7L9xDPsY5ZCVsW2M9ulIXPvT9CeHS3Zz/F02NfDK2PwwLSXTIkd6Eh8QTyige/cKU7WhEpbwyiqK3FqS+8BZJ8iIaOtJPAwvmxgujeeEO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666502; c=relaxed/simple;
	bh=gw2UWISDMlZF++jy95AUgqNSCD/LmKgmhVg76VV+sSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuUNIKmXyXdzao83iWYkvdS5jRrN86yscKHPvJuf7B+QKQ/Q1cY31HZKqH9GwSdIE8Z7xI8AsWr2EU7IQ83Hw8ICKxMqhtqiimh+iaqLZZ33h1TQVKtVVG9vtQoXS9NmqKbwgA/15hhbm4uuntbQnSEFUAo8WCoiSdFlW9LnxHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRfrsD/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRfrsD/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C0F1F000FF;
	Thu, 17 Sep 2026 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666500;
	bh=El0fwvh3kitgKSo/WyMrka+r3L3HZS6UavOfV4vUSI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRfrsD/tRXjPZjM6mvF+sKOL4Wpt2qDUvPlhzxAR7n989E8AzMsTr1f38QuHCys4d
	 yqOFIxYtSNmMQTUNauGbfUd1EbdpPTB55uxRMwGMtlRFbBy9UN6uq+CYhNtQoeHe8V
	 BYfxmLnHK7n6UDjSf3aDjafx4s6tt+ZVx9Bmizy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1057/1250] hwmon: (chipcap2) fix channels in humidity alarm notifications
Date: Thu, 17 Sep 2026 16:14:12 +0100
Message-ID: <20260917151620.774440647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 286b175bb03893949f24621f356abd9d20368b0a upstream.

hwmon_notify_event() expects the channel number as its last argument,
taken into account with the type parameter that it is a humidity sensor
type. Given that this device only provides one humidity channel, 0 must
be passed. The custom construct to enumerate the channels makes wrong
assumptions by listing all types together (temperature and humidity).

Remove the custom channel enumeration and pass the right channel to
hwmon_notify_event() for hwmon_humidity_min_alarm and
hwmon_humidity_max_alarm.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20260823-chipcap2_locks-v2-1-6a26c8e9e2fc@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/chipcap2.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -90,11 +90,6 @@ struct cc2_data {
 	bool process_irqs;
 };
 
-enum cc2_chan_addr {
-	CC2_CHAN_TEMP = 0,
-	CC2_CHAN_HUMIDITY,
-};
-
 /* %RH as a per cent mille from a register value */
 static long cc2_rh_convert(u16 data)
 {
@@ -493,7 +488,7 @@ static irqreturn_t cc2_low_interrupt(int
 
 	if (cc2->process_irqs) {
 		hwmon_notify_event(cc2->hwmon, hwmon_humidity,
-				   hwmon_humidity_min_alarm, CC2_CHAN_HUMIDITY);
+				   hwmon_humidity_min_alarm, 0);
 		cc2->rh_alarm.low_alarm = true;
 	}
 
@@ -506,7 +501,7 @@ static irqreturn_t cc2_high_interrupt(in
 
 	if (cc2->process_irqs) {
 		hwmon_notify_event(cc2->hwmon, hwmon_humidity,
-				   hwmon_humidity_max_alarm, CC2_CHAN_HUMIDITY);
+				   hwmon_humidity_max_alarm, 0);
 		cc2->rh_alarm.high_alarm = true;
 	}
 



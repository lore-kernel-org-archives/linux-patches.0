Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D7E3DAAC9;
	Thu, 17 Sep 2026 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671115; cv=none; b=dmuHcORN0kL8Cxr4bHNEimNZXWoeBY9MYknHtZTqFJ+n20/Tn+eWg9m9AGsHKv8fu5dyBJfYBHabJC+oHDRaBqjtL/ZYJqAsfHR7hxSHz5CavnElg5HZcQZ8Q9BRHE+zo2xkVSkaIkdDfcSqkQnKBoZDUWmGf2Ysu5sob8Ky3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671115; c=relaxed/simple;
	bh=AbB3drdicndLL+Qp2JgSLYNDBxg/Mdvc/RmQ9vrd/BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOI9Wyz3yKjBdVBJo51i9Z/HZ5fs+eaywx8/VUyiddL7NjIf0YNKxjtApeEXkT65sZ8CZCNfZZtPatliHrnZusO3pa/DpyLx6iR9ldE0wr7NaWaMsrW8fTK4AhW33V8yZaG+iiVCFuu8vLJkf/SlBKFm0x3QMP89zOb6R7+awZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDykedrj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDykedrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B76C1F000FF;
	Thu, 17 Sep 2026 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671114;
	bh=JBz/2P3kxHVoM3bD8NaXz39AqfaX1PnqLtLX5wXLgyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDykedrjEbswJA2EjAbVwpif91RNMZzn9+2TBpEOkNsVkFp10/DgiPHOhvCMAaKO0
	 7JRvt00YQT2RLXfxPZOnaMemqH81F5NQ3+Wb4oVrPhgcW2Bgjt+5xwTRgwsmmMHtVr
	 k1kj/SFF/99Y2ky5qXo4P/ekdnl9SIYAouR8UFHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 0871/1102] hwmon: (chipcap2) fix channels in humidity alarm notifications
Date: Thu, 17 Sep 2026 16:13:34 +0100
Message-ID: <20260917151602.426388293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -89,11 +89,6 @@ struct cc2_data {
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
@@ -492,7 +487,7 @@ static irqreturn_t cc2_low_interrupt(int
 
 	if (cc2->process_irqs) {
 		hwmon_notify_event(cc2->hwmon, hwmon_humidity,
-				   hwmon_humidity_min_alarm, CC2_CHAN_HUMIDITY);
+				   hwmon_humidity_min_alarm, 0);
 		cc2->rh_alarm.low_alarm = true;
 	}
 
@@ -505,7 +500,7 @@ static irqreturn_t cc2_high_interrupt(in
 
 	if (cc2->process_irqs) {
 		hwmon_notify_event(cc2->hwmon, hwmon_humidity,
-				   hwmon_humidity_max_alarm, CC2_CHAN_HUMIDITY);
+				   hwmon_humidity_max_alarm, 0);
 		cc2->rh_alarm.high_alarm = true;
 	}
 



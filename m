Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F62B4CDDDA;
	Thu, 17 Sep 2026 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660432; cv=none; b=itIr8pupekvz9VBDmsvC6YeVZhAbwHQCULTksUxiN8SNAP+SprHLZaQszKqCGJ0Mcd1daG0qIbU7ybU2QHM6q7EqQ7jBWDdNuDLqUxJbi7Hh9NV2bK2PVWFh2lHbxpZRsZFnQHCG9TdaQC+dXGmZxvk5EXUxh7CjQT3u8ldcuxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660432; c=relaxed/simple;
	bh=xm/H4jaD6G/OtS24wieRKFjrICdIbfBO/pzhrX6jYOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRmvHxmjvkkLHbjFpvC91Hw7KYDbWytEXzZZWFG5reWxYrlzoL4Kdsk4eSu9aN42OAJ+bik7nIsfJalOnMagij75sX8xCLoNm0Uh/ZVMZ8UuriuD165UpL6kayrg1hTo3wNWkAqyFevHzETVy4A0CdIhC5o5wWKT26W0uFodctQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTydonba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTydonba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76061F000FF;
	Thu, 17 Sep 2026 15:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660431;
	bh=cXOpalAwXtQJBKL1279rWsWbhJENgQF5P2nc7/75VLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTydonba/nRz3FFlHxabxj1rmBNRDmjLjBpCuFtWrRGXKYo+BbVo/uFZtr9+4uhJn
	 861sc6uUX++K6iIPTfTblIwRvOslwmC+WVD2Q2Uiq9XyyhZmf8JLLoXtfrzp99HxPa
	 PTwjGAjEv3m1SzvwNsZzBlbnjTag/mjJbZYJqrYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 591/733] hwmon: (chipcap2) fix channels in humidity alarm notifications
Date: Thu, 17 Sep 2026 16:14:59 +0100
Message-ID: <20260917151407.162554143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 



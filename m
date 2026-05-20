Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA1369D67;
	Wed, 20 May 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299309; cv=none; b=rMZAtsYal4G1Ygpkph9TXGuUVRihjePpLKcBWsmDPgPAmVMnzPJKoCCNh79iiWkbOI9jRVR/2YVXLKd1DTvxPIcoDCKpE3MENelxRbh5nX2yZXejxi0WAlqz2lzBSj7Br1M7spOIdMvjJS61QVN+9ItFA6y1rNerQUI8xyd+XOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299309; c=relaxed/simple;
	bh=4zQ6+MM8yBHkM9ubpn8PA1T58EXUyAyKJDChA5DZh6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdUtBXbFgUCIG/5lfgJdDFPqJLK/uQwMNTf4tADIaOcZTwg6Q3AeIgBCWV+gfJczcI4vAa2IL9++dOQFIH4Rjnb0AtDeunJoSzGwFv500NCOpLj4uRn6g055DsEH1Y2qC0ccI/ODEMBWetIO8S3qDeX4jEfdP1pv1FsUZtGQ6kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esQRxfkr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esQRxfkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A781F000E9;
	Wed, 20 May 2026 17:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299308;
	bh=B40PL5E5VXrW8UyhPNOglUlsVTaLgNOyyyK0Yn/pVRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=esQRxfkrBVYuIxSsCaDdLBjxst0xDhKIzgZ7TzG6LzER6RXVdujaR13nm3Pd0FzTu
	 1iKWNc1g71jvvqnLVoDYBijLr8b/i0AFfvliumzHyqe92GFi/qNCghAtByWBQdis/y
	 aLgTh3HAyKY+kQdfNQVSbFgY6xZKjq6h7twNmhuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Pighin <anthony.pighin@nokia.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 724/957] rtc: abx80x: Disable alarm feature if no interrupt attached
Date: Wed, 20 May 2026 18:20:07 +0200
Message-ID: <20260520162150.254123120@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Anthony Pighin (Nokia) <anthony.pighin@nokia.com>

[ Upstream commit 0fedce7244e4b85c049ce579c87e298a1b0b811d ]

Commit 795cda8338ea ("rtc: interface: Fix long-standing race when setting
alarm") exposed an issue where the rtc-abx80x driver does not clear the
alarm feature bit, but instead relies on the set_alarm operation to return
invalid.

For example, when a RTC_UIE_ON ioctl is handled, it should abort at the
feature validation. Instead, it proceeds to the rtc_timer_enqueue(),
which used to return an error from the set_alarm call. However,
following the race condition handling, which likely should not be
discarding predecing errors, a success condition is returned to the
ioctl() caller. This results in (for example):
    hwclock: select() to /dev/rtc0 to wait for clock tick timed out

Notwithstanding the validity of the race condition handling, if an interrupt
wasn't specified, or could not be attached, the driver should clear the
alarm feature bit.

Fixes: 718a820a303c ("rtc: abx80x: add alarm support")
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
Link: https://patch.msgid.link/BN0PR08MB69510928028C933749F4139383D1A@BN0PR08MB6951.namprd08.prod.outlook.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index 3fee27914ba80..5f3a3e60a19d0 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -933,6 +933,8 @@ static int abx80x_probe(struct i2c_client *client)
 			client->irq = 0;
 		}
 	}
+	if (client->irq <= 0)
+		clear_bit(RTC_FEATURE_ALARM, priv->rtc->features);
 
 	err = rtc_add_group(priv->rtc, &rtc_calib_attr_group);
 	if (err) {
-- 
2.53.0




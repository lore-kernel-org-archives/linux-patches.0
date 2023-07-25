Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA31D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB54C433C7;
	Tue, 25 Jul 2023 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283863;
	bh=PhWBYx1Pun4I3gmS2xxsyjjydJTxAmFGHnmI8wVisSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYcj7C9xRU1ISQU5d7MvqhPXGuk7o0rP6IxykXTN5/qQ1eMIkS8TH1rJJrhJcf1/f
	 Bn6kBe3rKQunvW4Lkd2TNDykJIVzjEliWhIQkX/b/qLQ3pjoTxyrJfE+2DB+Kt5xGH
	 MqErrLCSrLe6m7SVOYwKRd8DUtMKPxMKq6dKh1gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chu Lin <linchuyuan@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/509] hwmon: (adm1275) enable adm1272 temperature reporting
Date: Tue, 25 Jul 2023 12:41:27 +0200
Message-ID: <20230725104600.511657100@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chu Lin <linchuyuan@google.com>

[ Upstream commit 9da9c2dc57b2fa2e65521894cb66df4bf615214d ]

adm1272 supports temperature reporting but it is disabled by default.

Tested:
ls temp1_*
temp1_crit           temp1_highest        temp1_max
temp1_crit_alarm     temp1_input          temp1_max_alarm

cat temp1_input
26642

Signed-off-by: Chu Lin <linchuyuan@google.com>
Link: https://lore.kernel.org/r/20210512171043.2433694-1-linchuyuan@google.com
[groeck: Updated subject to reflect correct driver]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: b153a0bb4199 ("hwmon: (pmbus/adm1275) Fix problems with temperature monitoring on ADM1272")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/adm1275.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/pmbus/adm1275.c b/drivers/hwmon/pmbus/adm1275.c
index e7997f37b2666..0be1b5777d2f0 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -611,11 +611,13 @@ static int adm1275_probe(struct i2c_client *client)
 		tindex = 8;
 
 		info->func[0] |= PMBUS_HAVE_PIN | PMBUS_HAVE_STATUS_INPUT |
-			PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT;
+			PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT |
+			PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP;
 
-		/* Enable VOUT if not enabled (it is disabled by default) */
-		if (!(config & ADM1278_VOUT_EN)) {
-			config |= ADM1278_VOUT_EN;
+		/* Enable VOUT & TEMP1 if not enabled (disabled by default) */
+		if ((config & (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) !=
+		    (ADM1278_VOUT_EN | ADM1278_TEMP1_EN)) {
+			config |= ADM1278_VOUT_EN | ADM1278_TEMP1_EN;
 			ret = i2c_smbus_write_byte_data(client,
 							ADM1275_PMON_CONFIG,
 							config);
@@ -625,10 +627,6 @@ static int adm1275_probe(struct i2c_client *client)
 				return -ENODEV;
 			}
 		}
-
-		if (config & ADM1278_TEMP1_EN)
-			info->func[0] |=
-				PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP;
 		if (config & ADM1278_VIN_EN)
 			info->func[0] |= PMBUS_HAVE_VIN;
 		break;
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE4E3A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFycC+Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69456C433C7;
	Wed, 15 Nov 2023 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077309;
	bh=6mBF/LcgQrCnm5IZ3BuuyKSVRmvKVXp/1cOkZLZuC0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFycC+ShCDG6ksF2RdMj3m4WyVSQL7vNCynSVSSle04NmzHgN6A7Zql6DDdI42Y1Y
	 dt1wvvaWmZdeLwFXKQJCb2utNTjmdSoRBGJo29nV2mMC/4QptEceo/Eey3k6DlKw0D
	 tlszcuGI28yeYRPDweJy5PTOSWvkdcLFx9olSsrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Solanki <naresh.solanki@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/603] hwmon: (pmbus/mp2975) Move PGOOD fix
Date: Wed, 15 Nov 2023 14:12:32 -0500
Message-ID: <20231115191627.592961971@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Naresh Solanki <naresh.solanki@9elements.com>

[ Upstream commit 9da2901c47332b030ea4d2a2302bc7c0b83fc67c ]

The PGOOD fix was intended for MP2973 & MP2971 & not for MP2975.

Fixes: acda945afb46 ("hwmon: (pmbus/mp2975) Fix PGOOD in READ_STATUS_WORD")
Signed-off-by: Naresh Solanki <naresh.solanki@9elements.com>
Link: https://lore.kernel.org/r/20231027103352.918895-1-naresh.solanki@9elements.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/mp2975.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/pmbus/mp2975.c b/drivers/hwmon/pmbus/mp2975.c
index 26ba506331007..b9bb469e2d8fe 100644
--- a/drivers/hwmon/pmbus/mp2975.c
+++ b/drivers/hwmon/pmbus/mp2975.c
@@ -297,6 +297,11 @@ static int mp2973_read_word_data(struct i2c_client *client, int page,
 	int ret;
 
 	switch (reg) {
+	case PMBUS_STATUS_WORD:
+		/* MP2973 & MP2971 return PGOOD instead of PB_STATUS_POWER_GOOD_N. */
+		ret = pmbus_read_word_data(client, page, phase, reg);
+		ret ^= PB_STATUS_POWER_GOOD_N;
+		break;
 	case PMBUS_OT_FAULT_LIMIT:
 		ret = mp2975_read_word_helper(client, page, phase, reg,
 					      GENMASK(7, 0));
@@ -380,11 +385,6 @@ static int mp2975_read_word_data(struct i2c_client *client, int page,
 	int ret;
 
 	switch (reg) {
-	case PMBUS_STATUS_WORD:
-		/* MP2973 & MP2971 return PGOOD instead of PB_STATUS_POWER_GOOD_N. */
-		ret = pmbus_read_word_data(client, page, phase, reg);
-		ret ^= PB_STATUS_POWER_GOOD_N;
-		break;
 	case PMBUS_OT_FAULT_LIMIT:
 		ret = mp2975_read_word_helper(client, page, phase, reg,
 					      GENMASK(7, 0));
-- 
2.42.0




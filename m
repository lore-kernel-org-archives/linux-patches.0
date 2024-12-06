Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F209C1494B2;
	Fri,  6 Dec 2024 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496761; cv=none; b=ih0lrat+yv197fCeCxqAglLlhkuZgo4+UxMG7MnneNFawt7irYwGVsEGHZcuFb0EXHOO5wAVdHWU/uXJbySXry6aRRbH9IPo5Yss2BqhlReiRPrcU0uLYnQEy+tG4WwWedLYORSeYe77DVUMJCY85aW34T63NOd1oeLCMy6gFYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496761; c=relaxed/simple;
	bh=MtLRQ2jCt/BEcL//MKeNrhnGHHusxEOZf5Zk7h6xNjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qd8aDDOoNBZzgOmxf0z8Y/I0mZ0N/XvLPfmUWHvGMyDGFUZeVFWgo/7djdTcYsM9zlSA9zMec0wPISiyh18hpaetoZ5zlHd20wKnFTiFACpInb7qCr3D0ePElT8y5Cy8j/9NcLOGP2LvzOb2NTNUACyYGDf5B8WkA3kqpXrddxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRjTCtWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRjTCtWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E320C4CEDE;
	Fri,  6 Dec 2024 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496760;
	bh=MtLRQ2jCt/BEcL//MKeNrhnGHHusxEOZf5Zk7h6xNjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRjTCtWkpnvOn1UskITfWBVbYp19IWs+xKeQcwcvcMIEshjYTiCKemhEOdUTG/wB1
	 Fs2KG8xEj7NgSueEKevh0zIhsy9a8jO487CDLyDgArpSqre7mz3jzz6BKpmomzdXvJ
	 pgVfiaxWnQKPwXZRXKYezLZHbjFSAgkmcNv2g/4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Naresh Solanki <naresh.solanki@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/676] hwmon: (pmbus_core) Allow to hook PMBUS_SMBALERT_MASK
Date: Fri,  6 Dec 2024 15:28:34 +0100
Message-ID: <20241206143657.071345847@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 9c6df63a66c1fdf99d6e1ad278d140080c724120 ]

Use _pmbus_write_word_data to allow intercepting writes to
PMBUS_SMBALERT_MASK in the custom chip specific code.

This is required for MP2971/MP2973 which doesn't follow the
PMBUS specification for PMBUS_SMBALERT_MASK.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Signed-off-by: Naresh Solanki <naresh.solanki@9elements.com>
Link: https://lore.kernel.org/r/20240130152903.3651341-1-naresh.solanki@9elements.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 509c3a362675 ("hwmon: (pmbus/core) clear faults after setting smbalert mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 728c07c42651c..e592446b26653 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3199,7 +3199,7 @@ static int pmbus_regulator_notify(struct pmbus_data *data, int page, int event)
 
 static int pmbus_write_smbalert_mask(struct i2c_client *client, u8 page, u8 reg, u8 val)
 {
-	return pmbus_write_word_data(client, page, PMBUS_SMBALERT_MASK, reg | (val << 8));
+	return _pmbus_write_word_data(client, page, PMBUS_SMBALERT_MASK, reg | (val << 8));
 }
 
 static irqreturn_t pmbus_fault_handler(int irq, void *pdata)
-- 
2.43.0




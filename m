Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C446B6F2FE;
	Thu, 12 Dec 2024 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025348; cv=none; b=qEOk2YTWXrMJwoYXdZ3vVJWit7I60zqY/zsinBE/9WMpaii1bNf9xfjQS/VA7X38tnkqfGpid3L7gZ6PCSlfxOdeHN1IAHJCzp7mxs3mYjI1Fd2zkaZwrkzNyR/PdadjZWa8JdSD/azn+pYeFRLapHwHzxBeqsGDccMZEa187lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025348; c=relaxed/simple;
	bh=gcigGEUOYpteJuTrJMqSzGxFP4GkVubsvsTMsJIMmvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVA40Z2O0cHezOlrRnsehPkILgw58yQjUEcvLDDKwWFtKulfDgn6gNz/qknGE6fTMNgC9OpPyCvkjm/wwdv9bv1hutprJhm447IwABkK57VFB2g+RCmIcY8/yotXR+SE1Kc7g/mWz40f1gO1Z9BzFUtB26etyoTAtgfO4NN30uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBx/MKJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBx/MKJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39CEC4CECE;
	Thu, 12 Dec 2024 17:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025346;
	bh=gcigGEUOYpteJuTrJMqSzGxFP4GkVubsvsTMsJIMmvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBx/MKJRK/YTAIO4QA6s5KNWS6Ue4llXxl4Lzm/1FiZOH4JRFfxZ/EgG+igjSGWAW
	 5axlgjeB7575ENd23YNXzgSMmJHPLJjS0x5ZIBsvhswUYL3bTfW+s08M8QKV8qxylX
	 VCjAkEpqrbHP2hAM2KnC4jg8ExepOs59v1Qb80Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/321] misc: apds990x: Fix missing pm_runtime_disable()
Date: Thu, 12 Dec 2024 16:00:56 +0100
Message-ID: <20241212144235.429359831@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 3c5d8b819d27012264edd17e6ae7fffda382fe44 ]

The pm_runtime_disable() is missing in probe error path,
so add it to fix it.

Fixes: 92b1f84d46b2 ("drivers/misc: driver for APDS990X ALS and proximity sensors")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240923035556.3009105-1-ruanjinjie@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/apds990x.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 45f5b997a0e10..5b17288ecc2f0 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -1148,7 +1148,7 @@ static int apds990x_probe(struct i2c_client *client,
 		err = chip->pdata->setup_resources();
 		if (err) {
 			err = -EINVAL;
-			goto fail3;
+			goto fail4;
 		}
 	}
 
@@ -1156,7 +1156,7 @@ static int apds990x_probe(struct i2c_client *client,
 				apds990x_attribute_group);
 	if (err < 0) {
 		dev_err(&chip->client->dev, "Sysfs registration failed\n");
-		goto fail4;
+		goto fail5;
 	}
 
 	err = request_threaded_irq(client->irq, NULL,
@@ -1167,15 +1167,17 @@ static int apds990x_probe(struct i2c_client *client,
 	if (err) {
 		dev_err(&client->dev, "could not get IRQ %d\n",
 			client->irq);
-		goto fail5;
+		goto fail6;
 	}
 	return err;
-fail5:
+fail6:
 	sysfs_remove_group(&chip->client->dev.kobj,
 			&apds990x_attribute_group[0]);
-fail4:
+fail5:
 	if (chip->pdata && chip->pdata->release_resources)
 		chip->pdata->release_resources();
+fail4:
+	pm_runtime_disable(&client->dev);
 fail3:
 	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
 fail2:
-- 
2.43.0




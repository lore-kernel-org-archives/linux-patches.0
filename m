Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEBE2210DE;
	Thu, 12 Dec 2024 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022732; cv=none; b=B5kNXYBgkZ+sAhPHJpBncxL4KLgco2fW10MZxw8gCG1c/uNy+NT9KxQAR11yM793qxvmxMebIvS8KaO2Nt8oTyTmVt58R09y6RYN4HoVhyyH0RFJT1MxY/sO0t8AwPBev5T+Q1vMHletCHWtxiJHveSBlxB7Lvyz2sGx7CO8/L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022732; c=relaxed/simple;
	bh=VFgM1roJ4PJSGVTkzkNjrEmW1AGnlfoD7AIutn2rDwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnB+SdP1f5DLTDSfbuoe0GUlcN0hE3FJgAgVohiB4u8zr1A9p5VQwVFmc3faFpL9prn+8ujpHN3/byqZ552nt/SHdsAkqEmpGDugSzRixn8Qyy/miqxsXKtkMmfVSCvfYotvySQoXMzP02Mp42Mpy58JtBRKfRfzyWOYcAjOVn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li7UM0KP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li7UM0KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3598CC4CECE;
	Thu, 12 Dec 2024 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022731;
	bh=VFgM1roJ4PJSGVTkzkNjrEmW1AGnlfoD7AIutn2rDwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li7UM0KPBfmNu5zPby/yGQepOATCqqDThLBPxHjzQ5v4uSx1mPtx0IRoGMLGB5Unv
	 EfKT8LXo/NjvHgNcOUYa2/MrEQXu+EYKTqU4p4oi+KKFFi3SWaDZgmrTmvlqIy38ib
	 JTWTs5ZV+1ESicd/CIeMp8nAvP2k1zYQe6i2yknU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 291/565] misc: apds990x: Fix missing pm_runtime_disable()
Date: Thu, 12 Dec 2024 15:58:06 +0100
Message-ID: <20241212144322.969974267@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D9E23CE;
	Tue,  3 Dec 2024 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242057; cv=none; b=H7BJwjOru6QMd7ZxiS2vorxBw1UDN9GncN08N7SEftUxhUKDLbUAfVfcSisHyd8/7RSb0EVVP60JDgLgZLz94B2XeE71OwGyqRw6geM3WHXR83Np65OUVpOgizf7J9LpAQT8BGDPXE46q06TEbR6jWC319di7FvTYeJ3FpKQJ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242057; c=relaxed/simple;
	bh=7RIGY277x7ZWAcIiFVaF86JH/+/VohLn7IObSkwcf9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrfJwAQnn8FarNeXE8CQCLgbMxrY7kJZ6PNZ0Piq3MRMH4H5tmGckDVPUPa1ZbbxVmBHk/MY9RqGW04rLp9YwP0nblcQ4v1U2nNRBCtwyb1+5napi3g9wCoBuFllxnwv0z+aIKTtNcCHA1hv2z3g33j0a8usVRQJ3s1ShpH6GrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXMBFKXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXMBFKXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E929EC4CECF;
	Tue,  3 Dec 2024 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242056;
	bh=7RIGY277x7ZWAcIiFVaF86JH/+/VohLn7IObSkwcf9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXMBFKXQ1Xrm6EQeeLmFuSoB9GFloAAVLI2BnSAyLDWpjpB2a6404ugSrL1QO4n+W
	 VE0zUB6Ft6MKgHaQAmRfLtjtn3xX+I6XRb9bU+3axvVoMbAYzxiyYlBp5wmk62ViaJ
	 M6bwN117Nw5+nEUIypKiB4i+ECQVNeLyQxA1o9gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 595/826] misc: apds990x: Fix missing pm_runtime_disable()
Date: Tue,  3 Dec 2024 15:45:22 +0100
Message-ID: <20241203144806.968203897@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6d4edd69db126..e7d73c972f65d 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -1147,7 +1147,7 @@ static int apds990x_probe(struct i2c_client *client)
 		err = chip->pdata->setup_resources();
 		if (err) {
 			err = -EINVAL;
-			goto fail3;
+			goto fail4;
 		}
 	}
 
@@ -1155,7 +1155,7 @@ static int apds990x_probe(struct i2c_client *client)
 				apds990x_attribute_group);
 	if (err < 0) {
 		dev_err(&chip->client->dev, "Sysfs registration failed\n");
-		goto fail4;
+		goto fail5;
 	}
 
 	err = request_threaded_irq(client->irq, NULL,
@@ -1166,15 +1166,17 @@ static int apds990x_probe(struct i2c_client *client)
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




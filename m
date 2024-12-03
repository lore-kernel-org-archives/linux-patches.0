Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849A81F75BC;
	Tue,  3 Dec 2024 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239405; cv=none; b=rGMLPCIsIQgYLx/V+JuQ2ZS0r6Eeg85fErUU+SfB3E/XRo9v10Erz0MmRCiwKg780RTg3CCFg0iFrVuEbIj7P/RzrEVoC3ZZd4HHxxLi3DDi90JTjJpvsnt/jEjCccgC0cDTyV9Ba6+TZGvjF4QNU6qSxkjIhoDgfclkh0Dj21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239405; c=relaxed/simple;
	bh=GRcbKDdt9WuXLSCV/u+XVBTbDK9b7EcMazbWAW5I/J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxKCXqNQnhjFHjC0/CgdZ5yBR6UgFC5g9JlQDNFfmEJTUH/yB/iEK0/MZYg6TQkr0frecirCA9JjpiIkCr5mPPju1j567wPnrT5to4U9iahBQyYSPmElqWa8dQ5mvvOs9lNlSxKF61UEkEUUz16cevFK1yOiN4WqE4XAYCAcUZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ink5xFZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ink5xFZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC854C4CED6;
	Tue,  3 Dec 2024 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239405;
	bh=GRcbKDdt9WuXLSCV/u+XVBTbDK9b7EcMazbWAW5I/J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ink5xFZLU8DIMLtnva9DdFHvDPiLNrD30gOvhFHKLaJKw6yMg4+PkVHxnOHMTz6Vy
	 M/N33QFX8P/0jl52k0XHnAn5UVZedxEPOl0K6qnDdsgqgFRP7JD7tIZ0aqnS/Ymjaq
	 gA0TPErwKbCaZCN5eX6Z6qqW6q/NygAsMEfCxE8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 602/817] misc: apds990x: Fix missing pm_runtime_disable()
Date: Tue,  3 Dec 2024 15:42:54 +0100
Message-ID: <20241203144019.426607886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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




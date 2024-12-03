Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E931F4722;
	Tue,  3 Dec 2024 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236863; cv=none; b=cH1CSFh7P7Tvx7TU6apA5BSQ07Y0El4EkkPMwo+Uk43+d3dwxG+F2KppIv4x2pK/JEy+CEeWkwg2DUlBxDURLZMStn8fy4m1iJfdvplKmI3hy9mdlZC896yGcD0cEgRf6tdVC20q+Rok7yWesjMhIkPp0TLEZe+pxokBB5erXy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236863; c=relaxed/simple;
	bh=DT3fnP3mPsYbPt6+2tVkZj9zlw7zcyQj8+a/851jZC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubZcL9m2YrxlxZGfTBaO8laLR4nqQtQ3u18IBbO3w5vsBL1s5y0Owa50kWk7a114KVZxtWzztgfsajLGXqnXX7ci14AAOuKHH79flLeo/C1aIr+6yFbxuuawlQU9bn4Ld64rj3R3E0NiHlzUYngnlUuI98Egznp7wNKeViiu5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0R0/mR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0R0/mR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DAAC4CECF;
	Tue,  3 Dec 2024 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236862;
	bh=DT3fnP3mPsYbPt6+2tVkZj9zlw7zcyQj8+a/851jZC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0R0/mR7hMhf7BzPcN++8b/2v+wQOhB2Sa36tkMnu+q3utGfLN6QV9rviSfjPqC90
	 9ZvO+VjOMdqrexBYo5d0fAFA/T4KJptAV95VVJweSVqAyqbNRzrYklzwplbNanDbMn
	 f/cBZDnkD/PB3T24Si3bk9prqz2wuJT23BcXqhMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/138] misc: apds990x: Fix missing pm_runtime_disable()
Date: Tue,  3 Dec 2024 15:32:06 +0100
Message-ID: <20241203141927.275921291@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ed9412d750b74..871d2d42db938 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -1163,7 +1163,7 @@ static int apds990x_probe(struct i2c_client *client,
 		err = chip->pdata->setup_resources();
 		if (err) {
 			err = -EINVAL;
-			goto fail3;
+			goto fail4;
 		}
 	}
 
@@ -1171,7 +1171,7 @@ static int apds990x_probe(struct i2c_client *client,
 				apds990x_attribute_group);
 	if (err < 0) {
 		dev_err(&chip->client->dev, "Sysfs registration failed\n");
-		goto fail4;
+		goto fail5;
 	}
 
 	err = request_threaded_irq(client->irq, NULL,
@@ -1182,15 +1182,17 @@ static int apds990x_probe(struct i2c_client *client,
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




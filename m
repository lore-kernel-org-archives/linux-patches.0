Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5E320C00E;
	Fri,  6 Dec 2024 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497914; cv=none; b=qjqEcpt8VPkvQcoWWIxCLz62G9ZTrmV0Pb9mZFMeQ7HaaiXaWON1Wgmy5AEezuhruuIAHFcTjitWbvRj7HJ/nFw4TlQ5awYpywWqYaGTuv+d4PbCpl9/TOBHVBthHO+fA0tzHSHelfwCidfp6LvL7nOYKwGz6fBc9OeYlcZ7ZpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497914; c=relaxed/simple;
	bh=lUSpmTmO74TU9yrnn0/FfSD8x7bmbWf2rwMYgJDYKT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCtH8zE6NXm+nCuhzGZrBzZY36rCRagb7dZGA3i/TvO8p3OU9oaOxjO0PcZEHxvbxiTfL/uHMP0dgmzpY4SDZLk5InA/O8y3j9xxo0Uj4JJU0OZ1WAw8BVaIh6ceq17o+dz0PJMDv3JCfjUfD35m7tkeqhymZfkGrwrsA1mtg2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDjTHgcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDjTHgcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10E8C4CEDC;
	Fri,  6 Dec 2024 15:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497914;
	bh=lUSpmTmO74TU9yrnn0/FfSD8x7bmbWf2rwMYgJDYKT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDjTHgcNCVNtCnkKMJFlEXWvF4k38DlWAo3cIlgorHO5mnnBV1sIHLuZ5un8p86iT
	 xcuRfXtE61i5oaN9fSdjjdPx/9Sz5g3wvL/TDMrQ85DZQu+5Q60AG1DqUnCSrs5k6e
	 DLfzD/O3KtgMG1SYSDlNH1ZoVBHpuRPaXH0j2uYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 431/676] misc: apds990x: Fix missing pm_runtime_disable()
Date: Fri,  6 Dec 2024 15:34:10 +0100
Message-ID: <20241206143710.178719906@linuxfoundation.org>
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
index 92b92be91d602..095344a312d2a 100644
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




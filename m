Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D905916419;
	Mon, 23 Jun 2025 13:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685799; cv=none; b=Isl350gyyzt0xKVuDmuULtq5WehPLmi17gHXSUEswIXj7GIsB8j5Ap1GDgPe/liKsAKpaVcjyBhCFeZK2w6leshl9zY1fHCjdDJzOGyKPM9s6DAWZ/uqZwsQY1egPLLOqIO1pXuWvI8WvllZs2QW5CGevtzV0/qirHQ9FEJN3M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685799; c=relaxed/simple;
	bh=rjwNsbE/iED57gMiTj/eMO9bdb8RwUbQuyUmoSPfkrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piXWWsLzE57/98Uwz9eycW5RxKJ8b4qrEg5msyBfSOoD3W2lL5C7kgP2t5Hm1huGpXfnEfgzn6BujG859ShAwLFX8KZADSy3hwsX9mmwThIUwHuLkIZQdlJ5DrOkhvJIn3IUgPTpDVab2R5IhWhxyai288gk6wLW8VzcHiUJEcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEvWEYQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEvWEYQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F459C4CEEA;
	Mon, 23 Jun 2025 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685799;
	bh=rjwNsbE/iED57gMiTj/eMO9bdb8RwUbQuyUmoSPfkrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEvWEYQf2efSUxzX+qbslVds0lZYHNOOwpXWC2RVw6Lggx7yKmqUjsjYHhoFxgybN
	 N6uhxQXyfG4niIS5FZBwSOGpB1VpCaxe9fsl2vxPVGQn4E1Sm1BJydoahfPn8J5fe6
	 dnS+Lgj+Q6xfAVP6tsiP8B9JncpMf+6dw06tyVVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarang Raval <tarang.raval@siliconsignals.io>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 268/592] media: i2c: imx334: Fix runtime PM handling in remove function
Date: Mon, 23 Jun 2025 15:03:46 +0200
Message-ID: <20250623130706.694171195@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tarang Raval <tarang.raval@siliconsignals.io>

[ Upstream commit b493cd3c03641f9bbaa9787e43ca92163cb50051 ]

pm_runtime_suspended() only checks the current runtime PM status and does
not modify it, making it ineffective in this context. This could result in
improper power management if the device remains active when removed.

This patch fixes the issue by introducing a check with
pm_runtime_status_suspended() to determine if the device is already
suspended. If it is not, it calls imx334_power_off() to power down the
device and then uses pm_runtime_set_suspended() to correctly update the
runtime PM status to suspended.

Signed-off-by: Tarang Raval <tarang.raval@siliconsignals.io>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx334.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx334.c b/drivers/media/i2c/imx334.c
index b51721c01e1d6..63d812a41542f 100644
--- a/drivers/media/i2c/imx334.c
+++ b/drivers/media/i2c/imx334.c
@@ -1435,7 +1435,10 @@ static void imx334_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 
 	pm_runtime_disable(&client->dev);
-	pm_runtime_suspended(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev)) {
+		imx334_power_off(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 
 	mutex_destroy(&imx334->mutex);
 }
-- 
2.39.5




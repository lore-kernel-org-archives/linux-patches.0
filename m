Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17E4313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301023; cv=none; b=ta4AIZlxZCMGzwDkOHqMp++yx/1dEgA0r3IVn+8Iz/5Ytn/O9J/b6u/iJWor2O3neuHhqPSSllxOXvZ5RymbzfhU1vUmLN7TJpHRw9gdXbUDa0EUk6C3iP64JHe5nMdHmNKVyrA76O+y99QNFPsXxAhgYx20f3zoM/CA3Gi3IuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301023; c=relaxed/simple;
	bh=acyDod6XCOH+jKSFS/GSgVrZwDWwzJ9Uzixv95uaBJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGQx2m684wCh6Vszpw0NQSkuOrKFb77wkqvoLNTbPx29YI6dbWbe77lhse4hJB9+O4skayzbUXTh0zLppQxVAQWooexsMzKBkVWg+5+8yyl9CqVxTRPmYCUmE1KG4t+pLyLi4mtQKjAek1+2HzMQnCpml/oU0vggIdASm4HUis4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TR4U7stW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TR4U7stW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77F8C116D0;
	Sat, 28 Feb 2026 17:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301023;
	bh=acyDod6XCOH+jKSFS/GSgVrZwDWwzJ9Uzixv95uaBJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TR4U7stWdaQigEKyfC1xQpmsMiaKysEyH9zc0ftGsZywNJFzfx/Tmd39Bjx2h684N
	 UsvtP6Lpmr3UWr7psE8bbOievcoNriwzU3BxorfG4a+Je3HHjQ0CpYMCA9rQjWGsX0
	 ptL0N0OyGsJd2MH38YhbrOVOG3W9Re+p7zHzINa2JABET0FGOyYP6rycPRLdIHQkdS
	 u6XWbjc1oGr+sOQu+/Okq++5LowcnqYKOTs1bmT5YBi0PbiBIOpeWi4td19BYTPpn7
	 29VANN433D45wFyVwJ5E/JeQzgykCR6ff/LGYEQ1n93/NnRbBgKgnpKxUugtE73llU
	 JlMP7hrASvPmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/752] media: mt9m114: Avoid a reset low spike during probe()
Date: Sat, 28 Feb 2026 12:37:51 -0500
Message-ID: <20260228174750.1542406-160-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 84359d0a5e3afce5e3e3b6562efadff690614d5b ]

mt9m114_probe() requests the reset GPIO in output low state:

	sensor->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);

and then almost immediately afterwards calls mt9m114_power_on() which does:

		gpiod_set_value(sensor->reset, 1);
		fsleep(duration);
		gpiod_set_value(sensor->reset, 0);

which means that if the reset pin was high before this code runs that
it will very briefly be driven low because of passing GPIOD_OUT_LOW when
requesting the GPIO only to be driven high again possibly directly after
that. Such a very brief driving low of the reset pin may put the chip in
a confused state.

Request the GPIO in high (reset the chip) state instead to avoid this,
turning the initial gpiod_set_value() in mt9m114_power_on() into a no-op.
and the fsleep() ensures that it will stay high long enough to properly
reset the chip.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/mt9m114.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m114.c b/drivers/media/i2c/mt9m114.c
index 51ebbe7ae9969..554f25071cca6 100644
--- a/drivers/media/i2c/mt9m114.c
+++ b/drivers/media/i2c/mt9m114.c
@@ -2434,7 +2434,7 @@ static int mt9m114_probe(struct i2c_client *client)
 		goto error_ep_free;
 	}
 
-	sensor->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
+	sensor->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(sensor->reset)) {
 		ret = PTR_ERR(sensor->reset);
 		dev_err_probe(dev, ret, "Failed to get reset GPIO\n");
-- 
2.51.0


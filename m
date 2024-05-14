Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116AA320F;
	Tue, 14 May 2024 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687590; cv=none; b=MvV2+A/INXR9JynMcHHMHlHXbpe65B3yONOYvcXCMX1jVdWyjIHMT/b47oXP6Eoag1kwYwTDj1ZKcmYo8hKlHJt3LldJ7UX4UhxPLcV47tKrne7ZVKzE/0ddbuymb38kqJKbArMYq6n1onFci+Rqw4yhUACGHUnsK4EVxuFakMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687590; c=relaxed/simple;
	bh=whj4uupTcaPAqTZbFdNhJQjPRd3CRaeWSef3/Wd5D1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuMFoNo+7lw+99odqLxx44YFcAwQh3nx0IN0NJk3Zj/InFmJ0HiMzMrYQeuSIBqm/p0eajk8CLQWxi3DUVFiYOlqpamAfzy0MsYS+9uk5vZdIdNgPnJCjjFPrDoDsEaTJgtbf8MTZzebCe7LCyKSar5eAtqvWK6k92dp9Pg/nzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gR2Cvx//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gR2Cvx//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40373C2BD10;
	Tue, 14 May 2024 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687589;
	bh=whj4uupTcaPAqTZbFdNhJQjPRd3CRaeWSef3/Wd5D1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gR2Cvx//5yX2g+/AZ4eGU/mFwPwcTIfG/RhrZSKvPYGySi1enC0sx4CIFdsMuT95r
	 idLMsGF+vo7UByAJ0kNIkPGN/UOsjvWiabGreS/0sM/UzFr4G408wvSeg6aNDEWWmJ
	 5md2PCUgqdfrcqG1O7Zs2vQN9i4OCIFCHhfOmEXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Okazaki <dtokazaki@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/168] eeprom: at24: fix memory corruption race condition
Date: Tue, 14 May 2024 12:18:27 +0200
Message-ID: <20240514101007.038291082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Daniel Okazaki <dtokazaki@google.com>

[ Upstream commit f42c97027fb75776e2e9358d16bf4a99aeb04cf2 ]

If the eeprom is not accessible, an nvmem device will be registered, the
read will fail, and the device will be torn down. If another driver
accesses the nvmem device after the teardown, it will reference
invalid memory.

Move the failure point before registering the nvmem device.

Signed-off-by: Daniel Okazaki <dtokazaki@google.com>
Fixes: b20eb4c1f026 ("eeprom: at24: drop unnecessary label")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240422174337.2487142-1-dtokazaki@google.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/at24.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 65a7517c031a7..02bea44369435 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -782,15 +782,6 @@ static int at24_probe(struct i2c_client *client)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	at24->nvmem = devm_nvmem_register(dev, &nvmem_config);
-	if (IS_ERR(at24->nvmem)) {
-		pm_runtime_disable(dev);
-		if (!pm_runtime_status_suspended(dev))
-			regulator_disable(at24->vcc_reg);
-		return dev_err_probe(dev, PTR_ERR(at24->nvmem),
-				     "failed to register nvmem\n");
-	}
-
 	/*
 	 * Perform a one-byte test read to verify that the
 	 * chip is functional.
@@ -803,6 +794,15 @@ static int at24_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
+	at24->nvmem = devm_nvmem_register(dev, &nvmem_config);
+	if (IS_ERR(at24->nvmem)) {
+		pm_runtime_disable(dev);
+		if (!pm_runtime_status_suspended(dev))
+			regulator_disable(at24->vcc_reg);
+		return dev_err_probe(dev, PTR_ERR(at24->nvmem),
+				     "failed to register nvmem\n");
+	}
+
 	/* If this a SPD EEPROM, probe for DDR3 thermal sensor */
 	if (cdata == &at24_data_spd)
 		at24_probe_temp_sensor(client);
-- 
2.43.0




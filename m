Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B44A12FF67;
	Tue, 14 May 2024 11:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686085; cv=none; b=Gc66qSjAtA6uJQzU3KbqSte9UvQL2jT5+F3iljyqWf88zrw8R/jeRUhToHZGCJYfYh6IRA/DwpMjB/P4nCV1ymAFTKB1jYxUJe0sO9mSBkPAiua797Pvpw/Id6CScei6LOIp2NMWBULggemDkcgWkeTo1Gt3CJJhqrhLztFsxtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686085; c=relaxed/simple;
	bh=c/q1V1kWYt4pOo1lWqkl/iRcWsDlnYfovCZm0DIpxu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhQ52s8tqdd28omHaGz6JdrKIQtMabayWK4tnhMCBMmJXofMeXZwdlz9KUZxWBqHQqCYapyRDEhFr7pbquycqIq7wtIUOtSH9syCbfLflnzybVFUAcTaPI+DKfYu+9qWCIq1tEtO0spceU3DZPC2qevZB3tRyKKq5hgrtyOvSxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iktzg5Ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iktzg5Ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58025C2BD10;
	Tue, 14 May 2024 11:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686084;
	bh=c/q1V1kWYt4pOo1lWqkl/iRcWsDlnYfovCZm0DIpxu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iktzg5RuLYlTSWAWXIR73xn1S/f1BQOzhyvD1uxENrBGQ4roNGi0drHkufWls4+dx
	 +c2jWeYuQfeQ9xqKFcQcUdD9nZbel/lTJIjMXzonToPgipBvrj0ilva70UOO+7eYir
	 vpvah8eKFBKjgsf6zKW8w6zL5iWSxMRctqbPelYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Okazaki <dtokazaki@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/236] eeprom: at24: fix memory corruption race condition
Date: Tue, 14 May 2024 12:16:09 +0200
Message-ID: <20240514101020.607753209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc30fe137b40f..e664c1c852503 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -781,15 +781,6 @@ static int at24_probe(struct i2c_client *client)
 	}
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
 	 * Perform a one-byte test read to verify that the chip is functional,
 	 * unless powering on the device is to be avoided during probe (i.e.
@@ -805,6 +796,15 @@ static int at24_probe(struct i2c_client *client)
 		}
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




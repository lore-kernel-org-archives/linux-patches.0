Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6720412FB36;
	Tue, 14 May 2024 10:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684236; cv=none; b=r/WbJZ/qNs8EVGRsy3sPAkhD9wRzKM1S1xNAOPTnU8NcGFSdkmequF9Q3filrxFi7e8pjYD8muCQi1KZ3BGCLB4AKYL0xGS4eORDwXfh7kzkG2rIs9zw4qgPFuVVRZKR+llDsyamIZAyNkn3Js1dLK0qJrYtobZsd2Wq/8a+0Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684236; c=relaxed/simple;
	bh=0Fj+HVlWtbCkmgeIIEalBCdCeHTC9mOe4PDCEX7dbDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP/e7LMUVbmwDxI8SCcgvcyFpVCD86dF3Ab+4OVAYtReOuDRFdspO758GxPEEQi7Zu3yvx/BavS3T8bPQyOxFYEpQ1QrBu5uK0BhibP2GaoyEUdsddV7iJtlBVCdoljtNgHQ6uo+S95sZ078DHafap7Y/VZSPgSfJdWEmJzZ124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylCSLhy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylCSLhy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4553CC2BD10;
	Tue, 14 May 2024 10:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684236;
	bh=0Fj+HVlWtbCkmgeIIEalBCdCeHTC9mOe4PDCEX7dbDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylCSLhy+98ZxtHGB3u+xewnw0h6oLqbDFJ3iIJIzZiDNpNSOLN2YlgMj8fhOTFc6t
	 T6zSD9YHi72qxkokKbdOCKuh17cj8shQ6a5SYmOrnCHpFgR1+sf38QmAHyaVTR+7Bv
	 BT8EUaEMMz4ltd7Ok30yQOGNWR19JC19lU8Ls1po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Okazaki <dtokazaki@google.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/301] eeprom: at24: fix memory corruption race condition
Date: Tue, 14 May 2024 12:14:41 +0200
Message-ID: <20240514101032.621915542@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index e6d688817b106..c290e849b2ed8 100644
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




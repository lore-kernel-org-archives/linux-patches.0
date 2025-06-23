Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7461A4F12;
	Mon, 23 Jun 2025 22:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716265; cv=none; b=QMiNlL0K9ZRLfIqoa7xKn5FJ5NRrH2CB7lMIxgOcdeMjSpx1Z7FQYXO0apgClBmKYrUBrtJLT8vddzzPJXLMwYvJ83ACfPC/r6ULWBoWN2HCGSDt0USRMac9/flX4x4csoa46Qi8oLeT6522l070fEjjbbaYbg+vAI7Mxbl2lkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716265; c=relaxed/simple;
	bh=Rjjk9uo8GykzxZ1vTRinvcOU7j3eEXxI5jAD6NAeQVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFzYW5WgwfXftfbeeF9L4/m7aMxALap6YnIsldlx/xJIpYhw3qLQDI/5+pIMZ3he60yEVCiiSvjP78NfgwUONFPyB7Sr0noURI/Ew8ASfqThNee1KHXP8PV70qiwPiVqg3k6V7Sj7YMqoCJ+Gu5IuwAZbW8urTaoQVqxdSzrXk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZ7rx3IW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZ7rx3IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8C9C4CEEA;
	Mon, 23 Jun 2025 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716264;
	bh=Rjjk9uo8GykzxZ1vTRinvcOU7j3eEXxI5jAD6NAeQVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZ7rx3IWCS2g1u6d8qYYEgnAUIc8A3LYz76q1GsfFsVb1KbU5Frq9DUxYGuDeTE1S
	 PC/uySc5cY/52/ussQX3xCQuKfjg8EfvWb01mRL+EB0+8vK7NpAy2MemYr7rqFTs6L
	 4gHq+vdYuwf8C5V1iQ/m9L5v30W5B/IlXr73J0z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tali Perry <tali.perry1@gmail.com>,
	Mohammed Elbadry <mohammed.0.elbadry@gmail.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 312/411] i2c: npcm: Add clock toggle recovery
Date: Mon, 23 Jun 2025 15:07:36 +0200
Message-ID: <20250623130641.494471991@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tali Perry <tali.perry1@gmail.com>

[ Upstream commit 38010591a0fc3203f1cee45b01ab358b72dd9ab2 ]

During init of the bus, the module checks that the bus is idle.
If one of the lines are stuck try to recover them first before failing.
Sometimes SDA and SCL are low if improper reset occurs (e.g., reboot).

Signed-off-by: Tali Perry <tali.perry1@gmail.com>
Signed-off-by: Mohammed Elbadry <mohammed.0.elbadry@gmail.com>
Reviewed-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Link: https://lore.kernel.org/r/20250328193252.1570811-1-mohammed.0.elbadry@gmail.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index d97694ac29ca9..3f30c3cff7201 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -1950,10 +1950,14 @@ static int npcm_i2c_init_module(struct npcm_i2c *bus, enum i2c_mode mode,
 
 	/* check HW is OK: SDA and SCL should be high at this point. */
 	if ((npcm_i2c_get_SDA(&bus->adap) == 0) || (npcm_i2c_get_SCL(&bus->adap) == 0)) {
-		dev_err(bus->dev, "I2C%d init fail: lines are low\n", bus->num);
-		dev_err(bus->dev, "SDA=%d SCL=%d\n", npcm_i2c_get_SDA(&bus->adap),
-			npcm_i2c_get_SCL(&bus->adap));
-		return -ENXIO;
+		dev_warn(bus->dev, " I2C%d SDA=%d SCL=%d, attempting to recover\n", bus->num,
+				 npcm_i2c_get_SDA(&bus->adap), npcm_i2c_get_SCL(&bus->adap));
+		if (npcm_i2c_recovery_tgclk(&bus->adap)) {
+			dev_err(bus->dev, "I2C%d init fail: SDA=%d SCL=%d\n",
+				bus->num, npcm_i2c_get_SDA(&bus->adap),
+				npcm_i2c_get_SCL(&bus->adap));
+			return -ENXIO;
+		}
 	}
 
 	npcm_i2c_int_enable(bus, true);
-- 
2.39.5



 cha
 #endif /* CONFIG_KVM */
 
 static bool spectre_bhb_fw_mitigated;
+static bool __read_mostly __nospectre_bhb;
+static int __init parse_spectre_bhb_param(char *str)
+{
+	__nospectre_bhb = true;
+	return 0;
+}
+early_param("nospectre_bhb", parse_spectre_bhb_param);
 
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 {
@@ -1100,7 +1107,7 @@ void spectre_bhb_enable_mitigation(const
 		/* No point mitigating Spectre-BHB alone. */
 	} else if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY)) {
 		pr_info_once("spectre-bhb mitigation disabled by compile time option\n");
-	} else if (cpu_mitigations_off()) {
+	} else if (cpu_mitigations_off() || __nospectre_bhb) {
 		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
 	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
 		state = SPECTRE_MITIGATED;



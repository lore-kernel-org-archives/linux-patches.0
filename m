Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6641EE7C6;
	Mon, 23 Jun 2025 21:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714799; cv=none; b=BWQki8Z8Pzain8yxVJc7MzJNllmlKOOtOdiXcim8/umZhMEQxbneErhcqgrya6Hc13xGFMgwm4ngKb4ohZdXaeyIn7Jnwh0ReGBRDpmGIl8oOwrqvt/pVByj7S1rRaQTruDTdf0uK3Jeu7XVM67ZUz1/cEq8H9WcQU2BXuBmlVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714799; c=relaxed/simple;
	bh=w5qtbRgGeBmrQmHdmPkWq6oO7It4xLbmbpwGHqCGTpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Drfp17WOX1IecDITFWoMW89+QDrrbRlltTKw+hXfeY5f8JKKSid6LMg6hjlg1KyajFhwMkv0W835hKXVT9wgevLQ9TlCGEaB+ZcCdHupkIjr+UPqE/cAjIF/5Fc5SY7wxJEtFw4hrc6q8e+cSFOgluEyoTisMBYoFy+Zp0uc854=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQdYBc3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQdYBc3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE72C4CEEA;
	Mon, 23 Jun 2025 21:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714799;
	bh=w5qtbRgGeBmrQmHdmPkWq6oO7It4xLbmbpwGHqCGTpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQdYBc3Q0wWsra0U0qyiKmMGCVGAs91ONvBKsp3W7NP+rtQNYulrYnmJhBsojM92C
	 iX0wJcrYkF+ioWLQhE9Huk2P4GAvV7D7yJa5tLOkZaWDUaYrdMWuruXWAmyRXzPucv
	 5qs9VCZq3sksQoppDxhU12xQQA3JJxcmScJFRdk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tali Perry <tali.perry1@gmail.com>,
	Mohammed Elbadry <mohammed.0.elbadry@gmail.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/355] i2c: npcm: Add clock toggle recovery
Date: Mon, 23 Jun 2025 15:07:35 +0200
Message-ID: <20250623130634.388948571@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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




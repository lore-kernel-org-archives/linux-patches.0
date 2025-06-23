Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC22136348;
	Mon, 23 Jun 2025 21:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715487; cv=none; b=Yy/2F1iprsBbdSHNRL5WFKz3z07QWuIuYaiHfd3Kyt2GRJtk/Ltr8EhdTMmeeFeoQ4VUJHRT4brFDH9yTIIda+ddNfN/uI8RfEWbMyUUrQA4MVJ7b5L9eR4skllGKceYc9yLfvUDeXanHUnWDFM+th8g06HHcP4Kx49zaF5NKiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715487; c=relaxed/simple;
	bh=YaoyhqXInuD943DPzPvLM1W+vhqeobS446ZLauqWAFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofy56+2/4o76Ft8Cdv10U3f9Vry+TlmXDD95SKMhIQ4Q4NhSYfXzwuxM/QDkBXIJe5j4LXNunqFNBowLt8af3T86v+hb75YktgnmuGeFNBMGgCxNHR2f/+2+1Z0qhvZ12cAtJHw+7vIZC/nA0TC7SGRxPnFKRXOX67QjNO2zAfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp8Qw8UY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp8Qw8UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89307C4CEEA;
	Mon, 23 Jun 2025 21:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715486;
	bh=YaoyhqXInuD943DPzPvLM1W+vhqeobS446ZLauqWAFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tp8Qw8UYd1fqeMTEkMXbioA1bLLCLFgX1UtMhSfNX8zoALN8ngLFI8aReenDDCjjf
	 v0c9soiOdamgAVBjkwmnLIDq7rU0NcTKFFg7eFZRgTpQwMt+Lr3BkcNzGiQlT0+f6U
	 KeC0pJh7+JcZylGNw3iv0q784d8s77+RothRpL0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tali Perry <tali.perry1@gmail.com>,
	Mohammed Elbadry <mohammed.0.elbadry@gmail.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/414] i2c: npcm: Add clock toggle recovery
Date: Mon, 23 Jun 2025 15:05:46 +0200
Message-ID: <20250623130647.233393165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a693ebb64edf4..7b6eb2bfb412e 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -1969,10 +1969,14 @@ static int npcm_i2c_init_module(struct npcm_i2c *bus, enum i2c_mode mode,
 
 	/* Check HW is OK: SDA and SCL should be high at this point. */
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




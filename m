Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D38D2C026C;
	Sat, 17 Oct 2026 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254365; cv=none; b=nRV854PKHZqo4tXBUKHKjZZaJDxGrvH7+x7HWtRxP8CawvWLPAtaN8QgMN8uu+x43+P8XBIWHZ4BQdQHlHt0I1IiriaVDMv3O33aPRN+Wj9Qdz/ZwWhOOQt7Bg8tPOG/3qkNpUguGoKfmnHCrI7Ka8uNenuU6bwyO7iriJPmUmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254365; c=relaxed/simple;
	bh=TRza1Y7rofAasCtlHdaR08JtGkQ9WeqJRuLeE97tIWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hW61md/erTUzCf/FvqkzalfClAvJJSNashRfZ3qK9JJ4ivlwVqwp0uZ9l1p1QS74wlmKCMck0OK8tZAHmqc99XJx5TJttS1CEe1CqjcYPMDq+TV63hosMYuSAx23cLBp5EzAbHwNNOSL65vjf+1G4lx5Pe6Zd1Iuk8rIhRqIENc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YerkKVtL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YerkKVtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5DE1F000C4;
	Sat, 17 Oct 2026 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254364;
	bh=M7SMkSloQjKR/HN7DMNuSDimzYyIguRXIwV6rbj8PS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YerkKVtLrLDyhvU1cn07n5h2kbJn+IDTd9x5WF6HBib+iOHSffLSriuzYwID3Gkky
	 I0r73kMRABQqrN0RX7BZQdPu8c8Aa3JeHctu9l86Bqh9+0f8LMX1F7197reXeD8D7u
	 cjD4fbeVppvVEKbUh25HOAV+MTPv3UeRuotrL/lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 420/869] ata: libata-core: Add NOLPM quirk for PNY CS900 1TB SSD
Date: Sat, 17 Oct 2026 17:54:21 +0200
Message-ID: <20261017160047.906124463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 462775c620197adaabc983ce847e5b9878ff4cb0 ]

The PNY CS900 1TB SSD (Phison PS3111-S11, DRAM-less) drops off the bus
after entering Device-Initiated Slumber during idle. With the default
med_power_with_dipm policy the link goes down (SStatus 1 SControl 300)
and does not recover, forcing the filesystem read-only. Forcing
max_performance keeps the link stable across prolonged idle.

Add a NOLPM quirk so link power management is disabled for this drive
specifically, leaving it intact for other devices on the host.

Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e07f82ca68f18..fe3ed016b6d18 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4226,6 +4226,9 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	/* Apacer models with LPM issues */
 	{ "Apacer AS340*",		NULL,	ATA_QUIRK_NOLPM },
 
+	/* PNY CS900 (Phison PS3111-S11, DRAM-less) drops the link on DIPM */
+	{ "PNY CS900 1TB SSD",		NULL,	ATA_QUIRK_NOLPM },
+
 	/* Silicon Motion models with LPM issues */
 	{ "MD619HXCLDE3TC",		"TCVAID", ATA_QUIRK_NOLPM },
 	{ "MD619GXCLDE3TC",		"TCV35D", ATA_QUIRK_NOLPM },
-- 
2.53.0




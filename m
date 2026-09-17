Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740CB502D59;
	Thu, 17 Sep 2026 17:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664991; cv=none; b=lsOx9GmJDnco4CopsMQBIM0Sjpnc3X1CsD2DojZa7K3IUxXdZg2T9AMrVkwwTqT1LrdFncfXuZwv1ksUvayp0qVCdB4WO99D+AF0/P/7j+6BQNCqPixGAjTXV6Z2lu/j/RTfMNyrvgEfJD1Z1ujEL6GOxB66066TXrgBjxe56Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664991; c=relaxed/simple;
	bh=BCH2z+ZxkTj4Sc7dNddxH7qqMu81zEmrKlRMBhE2Yps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8mZYKmZHPdHK4vS2YKgxS8K3MxdpRyRjqS7rDPGsbb32f+dmaxEuoiydX299dl73qgqrYba5ZhuINqWo8rUGhxBSxQLPtbYW/plrSlekCkpIv+Szsm1twmwYLg/wN1p0onpD5LDOo/Ta/Of9A2PFsDmrVzGsVUZja6ah0RBg2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBv5v3Xb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBv5v3Xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7C41F000FF;
	Thu, 17 Sep 2026 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664990;
	bh=IFwT44DUKrMLCc4unzGSxgfhQT5S2hAQfB3LbXPAgf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBv5v3Xb2bcr1uy9rUjKsk1vu2Kr7faPaRWLvfmXKXl/2TF0Ef7N8Owdzki64He/K
	 YkJyGMXWiilGcHRfCZi2LYSW1WVfulSEyH0duJ3awG8w99UPm7Vcq4o6mxzszhVoQe
	 /uldUTzjnZ/ihCL80TXZ5XwvioFtTJjAlLij5uZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0554/1250] ata: libata-core: Disable LPM on some WD drives
Date: Thu, 17 Sep 2026 16:05:49 +0100
Message-ID: <20260917151606.948912488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 356d8241cf3c7b07a4a491dbab43b5a41513ca86 ]

According to a user report WDC WD100EFGX-68CPLN0 and WDC WD102KFBX-68M95N0
have problems with LPM.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220693
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f0753f5e57a8e..ae1e5f82026c5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4372,6 +4372,14 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "WDC WD3000JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD3200JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 
+	/*
+	 * WD drives with LPM issues (irrespective of supported SATA speeds).
+	 * (Unlike ATA_QUIRK_WD_BROKEN_LPM, which is only applied if the drive
+	 * exposes SATA Gen1 speed support, and SATA Gen1 speed support only.)
+	 */
+	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+
 	/*
 	 * This sata dom device goes on a walkabout when the ATA_LOG_DIRECTORY
 	 * log page is accessed. Ensure we never ask for this log page with
-- 
2.53.0




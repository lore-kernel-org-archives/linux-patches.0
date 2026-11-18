Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020486;
	b=sIol5awyKxE3o7KHNpOwnjyv3Oi4Pwm32Nk7XPajSRMSkpmEZUm0NHLt5sl57zTjh5Sp
	 7yuQgZVvjyMK8I8Z4A74MOugHpjK59KL81IwycrvMI4ffXbr48O1HyOaR6j6mQlg1aj9V
	 MMpiHEuKBr4h22dnsEXHDmcsJB/6yqbhtGA2QxppLsTstreMoDdnF8cnS5QjTomz3uEuA
	 xoCmIAYsvA4sKoKDdXeV5Sha4LVLq9KFDFMqXnRSorYJS91OfIVkTv7UR0TrvJ3BtjXUT
	 53n7vNDUHK5vOcQS9sXqXXsc5ACNeLUBad62bN0ax6AmV3ks/GXLfiIK/Pj69K7XE5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JVPL2iAppyQZpXFINxl1IrjnghrI8S3p3mrsjgV5X28=;
	b=u+oROyhw6lcRqVJXkPTL/G1qwB8jFLzJPJc5RZhCianb2poNUtQnRboLaOMQo6RJwSpo
	 pbNqDThmz2TdvCzdOPf38P21KtcVN9gIrC6cYb49Fjul3ysLwHXAtCPwE24ikXgJzvstW
	 Vhh0969zI3+bgfrSE8HZYCe2R7N306b9kyprnR7Mx6kOLNXzQPypYWAkVbb56ZvN3/2sm
	 mHUpDCAKz3qBwub1ivVCZaf9Q75JmWq5mV1AjA38AK3whCsApIqDQPMWEp/bmrMMFZKtQ
	 8at0qZEe3vzOwsCD7SGYcvfF1PHKjA6uoHw1WUkgNK3EQq8baFOW6s5B1aIg/DeomsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LG/I2gnB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9D3606A31C;
	Wed, 18 Nov 2026 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LG/I2gnB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BF31F000C4;
	Wed, 18 Nov 2026 16:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020486;
	bh=JVPL2iAppyQZpXFINxl1IrjnghrI8S3p3mrsjgV5X28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LG/I2gnBl0/cczso29tLqbKRHczA9owXYADwjyuuDlFw4HudQ7S8No/sfTNgFCXvD
	 8m40kumqil/UVvmuXvuOqwcFHDOmHLcxnLPqRBP0pAiXvlKupnMrn0pDGVy5+WaiYY
	 VuO1DZtEqQG+Yd4LtkGywMQSDwLClLzo4TNhS9Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1928/2651] ata: libata-core: Fix NO_FUA quirks shadowed by earlier quirk entries
Date: Wed, 18 Nov 2026 15:52:48 +0100
Message-ID: <20261118150356.111490807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 4153718a215eeb5bab3df50417bbd9602e84658c ]

ata_dev_quirks() uses the first entry in __ata_dev_quirks[] that
matches the device and ignores all later entries. Commit 38d431229bfb
("ata: libata: exclude FUA support for known buggy drives") appended
three ATA_QUIRK_NO_FUA entries to the end of the table, with model
patterns meant to cover whole product lines. Earlier entries already
match some or all of these drives, so NO_FUA is not always applied:

- "INTEL*SSDSC2CT*" never takes effect. Every model it matches also
  matches the earlier "INTEL*SSD*" entry, so these drives only get
  ATA_QUIRK_ZERO_AFTER_TRIM.

- "WDC*WD2500J*" does not take effect for "WDC WD2500JD-*" drives,
  which match the earlier ATA_QUIRK_WD_BROKEN_LPM entry.

- "OCZ-VERTEX*" does not take effect for "OCZ-VERTEX" drives with
  firmware "1.30", which match the earlier ATA_QUIRK_BROKEN_HPA entry.

Move the Intel entry in front of "INTEL*SSD*" and keep
ATA_QUIRK_ZERO_AFTER_TRIM in it, so these drives stay on the
ZERO_AFTER_TRIM whitelist. Add ATA_QUIRK_NO_FUA to the WD2500JD and
OCZ Vertex 1.30 entries. The quirks of all other drives are unchanged.

libata only uses FUA when it is enabled with libata.fua=1, so systems
using the default setting are not affected.

Fixes: 38d431229bfb ("ata: libata: exclude FUA support for known buggy drives")
Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261013193915.174460-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f218773f187fc..1fe222008abd2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4323,7 +4323,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "MAXTOR 6L080L4",	"A93.0500",	ATA_QUIRK_BROKEN_HPA },
 
 	/* this one allows HPA unlocking but fails IOs on the area */
-	{ "OCZ-VERTEX",		    "1.30",	ATA_QUIRK_BROKEN_HPA },
+	{ "OCZ-VERTEX",		    "1.30",	ATA_QUIRK_BROKEN_HPA |
+						ATA_QUIRK_NO_FUA },
 
 	/* Devices which report 1 sector over size HPA */
 	{ "ST340823A",		NULL,		ATA_QUIRK_HPA_SIZE },
@@ -4459,6 +4460,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "Crucial*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "INTEL SSDSC2KG480G8", "XCV10120",	ATA_QUIRK_ZERO_AFTER_TRIM |
 						ATA_QUIRK_MAX_SEC },
+	{ "INTEL*SSDSC2CT*",		NULL,	ATA_QUIRK_ZERO_AFTER_TRIM |
+						ATA_QUIRK_NO_FUA },
 	{ "INTEL*SSD*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "SSD*INTEL*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "Samsung*SSD*",		NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
@@ -4479,7 +4482,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "WDC WD1200JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD1600JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD2000JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
-	{ "WDC WD2500JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
+	{ "WDC WD2500JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM |
+						ATA_QUIRK_NO_FUA },
 	{ "WDC WD3000JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD3200JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 
@@ -4504,7 +4508,6 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "Maxtor",		"BANC1G10",	ATA_QUIRK_NO_FUA },
 	{ "WDC*WD2500J*",	NULL,		ATA_QUIRK_NO_FUA },
 	{ "OCZ-VERTEX*",	NULL,		ATA_QUIRK_NO_FUA },
-	{ "INTEL*SSDSC2CT*",	NULL,		ATA_QUIRK_NO_FUA },
 
 	/* End Marker */
 	{ }
-- 
2.53.0




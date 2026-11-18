Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026824;
	b=WYU/Bo/fh0NDa4hiQA+I8ngGDo5FfkG2bY+Fqawrn/6zRAqwcGbYGeRjkE4T6+Z9rKrc
	 ApHzE3mJw0wEKKyWqpwYGnEyQ2qTD74qyO9wKxxUOXPNRF3JbAPX0E3H/RUabDOJNEfEj
	 //pFxDpXFHSzXSZ/l5bQboiGPPPEWwQ7qGyPFe4NUA4KrVVaZ4QqD9eNoS49NsWmuyD1L
	 18d209PoF/Gw/TnQC6BmaSTv1LU3J+rBUTdcuMJoI/Q0sP3L3TUgFlSEurB3W+R7NIMI1
	 /qvThDRYMnulA4+iqixfnBoux9hdOxL/mQi7qZ4ofdNY/jrWbAXIQislJ4SffRNlmIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dlHzgPK5qPb1ETbsZSirL6vyA2BwRcNC85+g6wT8yvA=;
	b=3kPSNVpDOje05DqMSjzczY20pQooiVnOcNkP1ZVBUNTlyE+ECzVg/vc2Tx1Lx+qQ/HUk
	 EkHZWFT0U064vIi0EwMTHyCxatEqLDw33dqECM4hClm4YrOy1IMlawvPVWQUOSJM5NT6u
	 EEgtNhprzu+zqdXxpmTZgmWkPSnx7lG/n6ixWpzJvlB4slieWnZRCPIPcHWI8JrYTkkW2
	 DENTxfdRhI5qv9h8qOM7DsFGYwiPiZOybc4/ZPo6jLB2ocgSLtAqyPMaTR3eY0tSibA6Y
	 fPqH3ouLCv7A9IBENxDt/NJ5Ix9TKxx3an2eYZ0Fr5z6Qyu+DBn1CMCQGT8EVKi7SOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+xVEzJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D425606A331;
	Wed, 18 Nov 2026 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+xVEzJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19401F000C5;
	Wed, 18 Nov 2026 18:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026824;
	bh=dlHzgPK5qPb1ETbsZSirL6vyA2BwRcNC85+g6wT8yvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+xVEzJZ/1+kYAqNvVFf9kngFUjLfITM1bsfDia5PxU0dIo0FGncM3b9Dy0XstY9D
	 pvv2NwZyQj2CXCPjjN+BApbVfi53gMfLEKOszgARnpWhQwxhFW1o6yGFxn++MTCj75
	 FlMJ8V3m2wf1TCwN1vytF5w9F8nel0wnmEPCE+9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1573/2151] ata: libata-core: Fix NO_FUA quirks shadowed by earlier quirk entries
Date: Wed, 18 Nov 2026 15:55:08 +0100
Message-ID: <20261118150219.184226106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a4f50f7910964..9b373830a7c40 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4250,7 +4250,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "MAXTOR 6L080L4",	"A93.0500",	ATA_QUIRK_BROKEN_HPA },
 
 	/* this one allows HPA unlocking but fails IOs on the area */
-	{ "OCZ-VERTEX",		    "1.30",	ATA_QUIRK_BROKEN_HPA },
+	{ "OCZ-VERTEX",		    "1.30",	ATA_QUIRK_BROKEN_HPA |
+						ATA_QUIRK_NO_FUA },
 
 	/* Devices which report 1 sector over size HPA */
 	{ "ST340823A",		NULL,		ATA_QUIRK_HPA_SIZE },
@@ -4386,6 +4387,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "Crucial*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "INTEL SSDSC2KG480G8", "XCV10120",	ATA_QUIRK_ZERO_AFTER_TRIM |
 						ATA_QUIRK_MAX_SEC },
+	{ "INTEL*SSDSC2CT*",		NULL,	ATA_QUIRK_ZERO_AFTER_TRIM |
+						ATA_QUIRK_NO_FUA },
 	{ "INTEL*SSD*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "SSD*INTEL*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "Samsung*SSD*",		NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
@@ -4406,7 +4409,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "WDC WD1200JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD1600JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD2000JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
-	{ "WDC WD2500JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
+	{ "WDC WD2500JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM |
+						ATA_QUIRK_NO_FUA },
 	{ "WDC WD3000JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD3200JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 
@@ -4431,7 +4435,6 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "Maxtor",		"BANC1G10",	ATA_QUIRK_NO_FUA },
 	{ "WDC*WD2500J*",	NULL,		ATA_QUIRK_NO_FUA },
 	{ "OCZ-VERTEX*",	NULL,		ATA_QUIRK_NO_FUA },
-	{ "INTEL*SSDSC2CT*",	NULL,		ATA_QUIRK_NO_FUA },
 
 	/* End Marker */
 	{ }
-- 
2.53.0




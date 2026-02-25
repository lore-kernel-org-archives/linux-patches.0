Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664CC18B0A;
	Wed, 25 Feb 2026 01:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983399; cv=none; b=sQiyu45o8KB6EEGPZDKIcicRFmmLlYI4iQZAIaXETSEqU3SJkrqSQU0BZ4VezJ592T8Vi4Igsr3ihUrV4U/HGscRx5ZK083IAHd3veJGyHIWEouMoTpt+F5WyeLSwG2LTK1qB6r3+mK6tDBPxJKixhBMwqJHgkZhiordV8PiGVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983399; c=relaxed/simple;
	bh=CtcTGdfArZpyiqvxi2NIZBX6xxU7i4JrjfJR0+tU64s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLBDmSFR+2n5uZH4qNi81/q2uKoGdDP3040fmDGrtPsI7z/Qw+/AZ0YjkkC8kBqUXvKJKDGQmQLIDkBCykW+MxiFtDG0taJcCRZvVKbfjzHi+SxCJeP+EbfLPtOQCaL1MKXVZdRZrRVDZaDtr1/w0zyir0sqFUKPs+UIF1juuBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NovfjsbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NovfjsbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABB2C116D0;
	Wed, 25 Feb 2026 01:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983399;
	bh=CtcTGdfArZpyiqvxi2NIZBX6xxU7i4JrjfJR0+tU64s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NovfjsbVTVHRerAyX6kZ4JH1Mp73aFee4Ei8L5QprVNhPp5ILfAkw7sjcTwfGDip4
	 yJXMOullgCJWMv0EQZQdOSifnZgyyQPvuJtNPCTFC2yzGNf6yN0mVTJ4jD4KyCEjP2
	 UixjMNDEaLqKzzQaGcibldSXm/qUsu03jzrZ9bIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 485/781] ata: libata-core: Quirk INTEL SSDSC2KG480G8 max_sectors
Date: Tue, 24 Feb 2026 17:19:54 -0800
Message-ID: <20260225012411.708242893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 5f64ae1ef639a2bab7e39497c55f76cc0682f108 ]

Commit 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP") increased
the default max_sectors_kb from 1280 KiB to 4096 KiB.

INTEL SSDSC2KG480G8 with FW rev XCV10120 times out when sending I/Os of
size 4096 KiB.

Enable ATA_QUIRK_MAX_SEC, with value 8191 (sectors) for this device,
since any I/O with more sectors than that lead to I/O timeouts.

With this, the INTEL SSDSC2KG480G8 is usable again.

Link: https://lore.kernel.org/linux-ide/176839089913.2398366.61500945766820256@eldamar.lan/
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d5151b9ca9141..fb148b1c3bdbf 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4067,6 +4067,7 @@ static const struct ata_dev_quirk_value __ata_dev_max_sec_quirks[] = {
 	{ "LITEON CX1-JB*-HP",		NULL,		1024 },
 	{ "LITEON EP1-*",		NULL,		1024 },
 	{ "DELLBOSS VD",		"MV.R00-0",	8191 },
+	{ "INTEL SSDSC2KG480G8",	"XCV10120",	8191 },
 	{ },
 };
 
@@ -4324,6 +4325,8 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 
 	{ "Micron*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "Crucial*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
+	{ "INTEL SSDSC2KG480G8", "XCV10120",	ATA_QUIRK_ZERO_AFTER_TRIM |
+						ATA_QUIRK_MAX_SEC },
 	{ "INTEL*SSD*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "SSD*INTEL*",			NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
 	{ "Samsung*SSD*",		NULL,	ATA_QUIRK_ZERO_AFTER_TRIM },
-- 
2.51.0




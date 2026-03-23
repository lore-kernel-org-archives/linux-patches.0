Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF68723AB9D;
	Mon, 23 Mar 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277193; cv=none; b=QL110/0hRUpuHknlTOhfKvjDbRFCaFFDMemV4pNLTvIwo5xGWWlklVX0yhgbMJPHt7L5hp50angltIMj+ReNNdWITZ3TbqoHPXiqZ+JYJf3opbkFckZTWh+WvwMMGy97subXG4uqPMb/QRZDDFnehEi85742hIktPnQaDPHLSIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277193; c=relaxed/simple;
	bh=QTe91bstFVYFU6/bDh0FY3PGLew0umcp/joTuVBRvLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnfmSQXEUauEEiCohLjjf3f5w730nS7Ba3JgXE+y1dFu9B3Ko5uWlYhflVv6XhCdU306aM77SKde0qCkJbzzj2zP07GPCcomf3EX4/zF8n/l99wBl1APG+XRk0PXjvy6jhyuOebzSE9hhK/mZLgZaRucL28uiuv7gpPx/uHWSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwyN/K2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwyN/K2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F69FC4CEF7;
	Mon, 23 Mar 2026 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277193;
	bh=QTe91bstFVYFU6/bDh0FY3PGLew0umcp/joTuVBRvLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwyN/K2kU+QZ1oDH/NLtq8Oe8d8QVBccwZuY3k2Da2Hv0g/MDoe8Pf5yqnUXkbgoE
	 aqch2q07rEHdDL15sBBsVNIvhGlUY5m9EbkcQvODhSBZmWi9qZTS3IS0oShkEw9gDf
	 BCo4C7XwiMaE2lxo2aL1wQF+frkOOa1cfWPLZPzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Khaled Bayan <mhd.khaled.bayan@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 334/460] ata: libata-core: disable LPM on ADATA SU680 SSD
Date: Mon, 23 Mar 2026 14:45:30 +0100
Message-ID: <20260323134534.739455995@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit ce5ae93d1a216680460040c7c0465a6e3b629dec upstream.

ADATA SU680 SSDs suffer from NCQ read and write commands timeouts or bus
errors when link power management (LPM) is enabled. Flag these devices
with the ATA_QUIRK_NOLPM quirk to prevent the use of LPM and avoid these
command failures.

Reported-by: Mohammad Khaled Bayan <mhd.khaled.bayan@gmail.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux-hwe-6.17/+bug/2144060
Cc: stable@vger.kernel.org
Tested-by: Mohammad-Khaled Bayan <mhd.khaled.bayan@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4101,6 +4101,9 @@ static const struct ata_dev_quirks_entry
 	{ "ST3320[68]13AS",	"SD1[5-9]",	ATA_QUIRK_NONCQ |
 						ATA_QUIRK_FIRMWARE_WARN },
 
+	/* ADATA devices with LPM issues. */
+	{ "ADATA SU680",	NULL,		ATA_QUIRK_NOLPM },
+
 	/* Seagate disks with LPM issues */
 	{ "ST1000DM010-2EP102",	NULL,		ATA_QUIRK_NOLPM },
 	{ "ST2000DM008-2FR102",	NULL,		ATA_QUIRK_NOLPM },



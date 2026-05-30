Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED5B19D8AC;
	Sat, 30 May 2026 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163283; cv=none; b=ioDYZ+szddS5oP//BnOVSqBHaGN8IAAn+Qv4Dbncc8StaeUGjV8C74C5cGIZtdizxepVvsXQ2+7jOtDubagHvcSphY7BZug7tcjGzQV0Zm58DvRCJ02d6J2Fq1hBWvEktcZrLO/G4e35OWuNU1m5wf985LV1PcWUk43sYw37mn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163283; c=relaxed/simple;
	bh=puy1xcI0pbM7TM57EN1TuTdtk56eOMbof7aAbnXhA7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qspdeQUqLq/fSi1iAR8YuGdJ5xVJBJdHpXzvygQrgzPV/UQDCqlESF9QeYUvU5qz1qEyRup7vgWuscaethZJXcMhYEbuBupIfIhGvRHjuIhhJqAQWmHeDRi9OQM09T+udmIIguBcKjKGNtwVS38FY71m7eojTQsZCS5SxvuE9Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pM3piKv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pM3piKv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C431F00893;
	Sat, 30 May 2026 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163282;
	bh=J9p1EiHhM5FPhEKIADRPOsfG2/4wq5Jp2XCQIu7GZa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pM3piKv+Uw5rqCTEhZ/rEx3kRgR16ktPiruec9vDGqRa4DYvfam/1Tj/zEaBZgk1Y
	 q7WL66tmSPRy6W3sbb/cD424eFd9mJe/KoDfyjNTAvKlDGEKDeSOwEbfEXA6yjFWnm
	 SIvEsF0cevhr0gT1VGSVTaNp0lxyb4MjiYO5lh1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 212/776] nvme-pci: add NVME_QUIRK_DISABLE_WRITE_ZEROES for Kingston OM3SGP4
Date: Sat, 30 May 2026 17:58:46 +0200
Message-ID: <20260530160245.993989938@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Beckett <bob.beckett@collabora.com>

commit a8eebf9699d69987cc49cec4e4fdb4111ab32423 upstream.

The Kingston OM3SGP42048K2-A00 (PCI ID 2646:502f) firmware has a race
condition when processing concurrent write zeroes and DSM (discard)
commands, causing spurious "LBA Out of Range" errors and IOMMU page
faults at address 0x0.

The issue is reliably triggered by running two concurrent mkfs commands
on different partitions of the same drive, which generates interleaved
write zeroes and discard operations.

Disable write zeroes for this device, matching the pattern used for
other Kingston OM* drives that have similar firmware issues.

Cc: stable@vger.kernel.org
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Assisted-by: claude-opus-4-6-v1
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3478,6 +3478,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x502F),   /* KINGSTON OM3SGP4xxxxK NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1f40, 0x1202),   /* Netac Technologies Co. NV3000 NVMe SSD */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */



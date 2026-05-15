Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52687305663;
	Fri, 15 May 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860707; cv=none; b=P/cffA+R2Oxb2aXTdNvGlYYnX25fZduRFg55Akc2CstcRQexKxA2d36oYV7nMVcKyxSXx4yBRjg481M8sU39hdLEMyaZfE+GG9jyAZxNq6Z4uC0DgZ32pRak0BnySQ6Oq6QssjrBeymw+Wbjk8cXvpzK9IV1PNrHDfG0EQcVFW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860707; c=relaxed/simple;
	bh=9QcnrIkWxEsqKq31voilabbB73HmW7dZvVwCfRVss5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im75lOSo1FJqC3wuRoBsPcTqUUA7nJ9jWNslRQZeUtaKRVnWVJBhbGsVU6rUNEzIVzGAg3CEypAqpIq2+Aaa9D7JSCyQJznxJxgU8Xl50uzD6yfFqlICNcZ2P4l31q1to1YwH7VWTNF/fBANEb5hcQ1OxZK4JHfNgK5bM5o3ar4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfBRN7Aq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfBRN7Aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60EFC2BCB0;
	Fri, 15 May 2026 15:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860707;
	bh=9QcnrIkWxEsqKq31voilabbB73HmW7dZvVwCfRVss5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfBRN7AqwoE87KQTpsa5j7GOIuVOHucuQ27hU7XKbSIA0Zohp1FjMmU1jFHnItOuz
	 iO9kgNsA+nl9wRnjG+m9fJ+QX24rsQH9dRQC7RhoqkimYmU3kzwDly6RdDHatxHDZX
	 nHmYFgdAtbmY+1EdcdUzYqs3Qll3hOOmI1AwWGPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 048/474] nvme-pci: add NVME_QUIRK_DISABLE_WRITE_ZEROES for Kingston OM3SGP4
Date: Fri, 15 May 2026 17:42:37 +0200
Message-ID: <20260515154716.086986886@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3589,6 +3589,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x502F),   /* KINGSTON OM3SGP4xxxxK NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1f40, 0x1202),   /* Netac Technologies Co. NV3000 NVMe SSD */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */



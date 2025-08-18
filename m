Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FFF335BAB;
	Mon, 18 Aug 2025 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526055; cv=none; b=YQW1p0udfZqLwHXhDrInIql9iIn6ihLJJ89ccef073oYBAF2yzrJTWRN5J89tko/ewSDohV3yr5ww9awfXqdeGR/4H9z8HNbuHvKtfUH9r46hQhoCUnl62SXT2WVLmfPppf0wSFOIue9jykJIEZFKmcG6ell0zvvSmSSzw3QAGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526055; c=relaxed/simple;
	bh=JK2jwkb+LfjMJNqNrg8lvMm9g/4GuRYdhIA97D4vmJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amiIn9bGmjrXP5XhaIC0uXWuY4zaxxIVmTbEjzrT8ifKfPUHGWvDoEDSe8GjQRwOmp7IPvwMK8xaOXn5UwtdtOXDhaRxwIQT2MqG8V48wwh6yaVevOWOhulZcaIsbKKH10XHojb8YUEze+pyASeyz13DIKx0cvYPAkEpoxcuxHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I89h4pV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I89h4pV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAC0C4CEEB;
	Mon, 18 Aug 2025 14:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526055;
	bh=JK2jwkb+LfjMJNqNrg8lvMm9g/4GuRYdhIA97D4vmJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I89h4pV72ieGyRGdpa8B51S5wvoLsxOTodDU2EuvBmNOtugP5Zwxh6dInLtHnMyNZ
	 tKzp5E8XBNGzKVILy1ejmlxCK3Tj5u9WRSboOqhdtGZ5g6KM2HA2TIGPNA0dlpm4o9
	 xoNYbfcwrEHizAGxRBt0R4nZYT1TLDEfDnK/KiUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 444/570] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
Date: Mon, 18 Aug 2025 14:47:11 +0200
Message-ID: <20250818124522.921185265@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit dafeaf2c03e71255438ffe5a341d94d180e6c88e ]

When PCI_IRQ_AFFINITY is set for calling pci_alloc_irq_vectors(), it
means interrupts are spread around the available CPUs. It also means that
the interrupts become managed, which means that an interrupt is shutdown
when all the CPUs in the interrupt affinity mask go offline.

Using managed interrupts in this way means that we should ensure that
completions should not occur on HW queues where the associated interrupt
is shutdown. This is typically achieved by ensuring only CPUs which are
online can generate IO completion traffic to the HW queue which they are
mapped to (so that they can also serve completion interrupts for that HW
queue).

The problem in the driver is that a CPU can generate completions to a HW
queue whose interrupt may be shutdown, as the CPUs in the HW queue
interrupt affinity mask may be offline. This can cause IOs to never
complete and hang the system. The driver maintains its own CPU <-> HW
queue mapping for submissions, see aac_fib_vector_assign(), but this does
not reflect the CPU <-> HW queue interrupt affinity mapping.

Commit 9dc704dcc09e ("scsi: aacraid: Reply queue mapping to CPUs based on
IRQ affinity") tried to remedy this issue may mapping CPUs properly to HW
queue interrupts. However this was later reverted in commit c5becf57dd56
("Revert "scsi: aacraid: Reply queue mapping to CPUs based on IRQ
affinity") - it seems that there were other reports of hangs. I guess
that this was due to some implementation issue in the original commit or
maybe a HW issue.

Fix the very original hang by just not using managed interrupts by not
setting PCI_IRQ_AFFINITY.  In this way, all CPUs will be in each HW queue
affinity mask, so should not create completion problems if any CPUs go
offline.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20250715111535.499853-1-john.g.garry@oracle.com
Closes: https://lore.kernel.org/linux-scsi/20250618192427.3845724-1-jmeneghi@redhat.com/
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/comminit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 28cf18955a08..726c8531b7d3 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -481,8 +481,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
 		min_msix = 2;
 		i = pci_alloc_irq_vectors(dev->pdev,
-					  min_msix, msi_count,
-					  PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+					  min_msix, msi_count, PCI_IRQ_MSIX);
 		if (i > 0) {
 			dev->msi_enabled = 1;
 			msi_count = i;
-- 
2.39.5




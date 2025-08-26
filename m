Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED19306D3F;
	Tue, 26 Aug 2025 14:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217918; cv=none; b=Y2ygBZUH5GTiH67Yf2qlJNZkSjEgwgm9SCQJ/xVCoOt69S9j0iA+zepn/Snib4R9p+d5x83EFTbiFMamXYautzy9ok+YOStQW6CevApJ3/5/WKcMLoBOafpf11yKynF7Z0TYWi/Gv++/D4xXpOTTTXLDiNTfU+riflPtZMHfX5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217918; c=relaxed/simple;
	bh=bOryP716aK62wqCZrrXns8Wg4ZR1ofuQ9G8z6iPildU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNCBOMD08Us/gBCTqaduoweLKm6bPBVlrIumZYGOKONMvfK2Ugyj6KHTYsBRWEzAJhkJJjefNQ6pl3mxsSqlfWY+5beQl78Zi4BRLRBlF8aGpwgt/zJ2fNzN7MtDkmmdecb1AUpQwSqQzffHJ6GOT++/BdKupE57JdtIxpZtMKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7yXVjTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7yXVjTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2057C4CEF1;
	Tue, 26 Aug 2025 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217918;
	bh=bOryP716aK62wqCZrrXns8Wg4ZR1ofuQ9G8z6iPildU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7yXVjTGmYgrcKnC5VHGqpN9ww7AmvxXOyZGCVcceunfibrkYiBpWLuhrvVWKNYUh
	 CXRdmJRZwWgAttOJhd12spaKJXp4ivB/yFBzNauXhh+Q3Usdz1VAnrq7bnQEOytccq
	 O2CQ7KHStyHYRQF4LT7iue7WYk9lE7spLxGN7mt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/523] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
Date: Tue, 26 Aug 2025 13:08:54 +0200
Message-ID: <20250826110932.461217484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 34e45c87cae0..7b520e824c29 100644
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




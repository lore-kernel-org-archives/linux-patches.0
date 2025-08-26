Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A32F196C7C;
	Tue, 26 Aug 2025 13:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214748; cv=none; b=E+8/WFFYgyVMJbGD090LDZ41liWtyYt0SO/7aKOCF4xd8gsFzAkMS12eC1DPgndlpXn5XB4yv07RIXM2qQN7wQf3zd6/YcNqbyWzg2x9Bk+pJnzY47uVNE0WoX9iSzrQND9WCdLb4mQN4/kKOpUAIq5lSFBJZYwDz6Zxz7TwBMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214748; c=relaxed/simple;
	bh=5LotdrimBg5Z1zDegCcwsUuMxxifAb9VWbfRWIMqqvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0XZWkjnCc/fbAtGo2nyNsuz5xoxoseN07KqcnxksLvqsTJcWVLOu7ExpFXKGgNaMC6fb0pxUJR5ibrm4XVlZ8fSQlag/cRs8b7dEfGUiK0oZ72VNZXEhJazdv3tgGbLcFBW7BV6c//F+WqZgyxXKkZ4EM9l0nWdSyC6vjV65vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkvWkheF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkvWkheF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7E1C4CEF1;
	Tue, 26 Aug 2025 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214748;
	bh=5LotdrimBg5Z1zDegCcwsUuMxxifAb9VWbfRWIMqqvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkvWkheFnGa9K/qGna2tRWewhZq7hC3gRjxZ9ffopWtEFV5+Qpx+9wZAp1zy3Wxtl
	 aRxBHLa972iV1LopH1l7xTZiDoA3gDSIm2D2xhOWvpxjFSaYwcKFg8I+9rIm/HJPON
	 BO5HhbQK/Fhp1kJjtrt3cNA4iYVDby+dJdp/dbns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 223/482] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
Date: Tue, 26 Aug 2025 13:07:56 +0200
Message-ID: <20250826110936.282921897@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f64b0244303..31b95e6c96c5 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D234ABBC0;
	Thu, 17 Sep 2026 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665434; cv=none; b=bvP8I0h2hErp0gvACIvYQpuPiSKDU/fI15svJxUNBmsfa2k92iFV+U8LTpCzcaCUCiLPiY91kpti8uM94/pMoIeBl6nviqzOJhvuchm8E9t6kfkDCiUat++YcvXQ7i589WE4QXVpEXsJo6TLF0rA43qemjRHZYmMR6qbtoWbG6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665434; c=relaxed/simple;
	bh=g2eLDHFZkEEVbwwDwWIzsgDx24SVLzW+UnyzctXMphk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZV12GSHe3yoFseAQlHOhZ1hTuq30P+XZejUUqvIosEm5Vfz8PZCG/dqdqYvf6JxYQ2Y1X9hhlEKLbUhUAVNg3fNj1M+gdJ/jfKmbL+icG0n8Pu1WCFcYSpEpJ8GptfBwH184NEiSFPTbaZzf5EaundkboLvpR0Knvnv7uBj7bOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnaDmI6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnaDmI6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A1F1F000FF;
	Thu, 17 Sep 2026 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665433;
	bh=FwUrjsikplQM++tSDTx0pX3/pYk2I+tT92IIqI2XWD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnaDmI6hohQJZNH9DzBBZ1HVQbE1/2qQy/taFeA5RyHzOEdMw9j3ys/YPlMO+iO+Z
	 QpuPIvNA/mZC4MthcbBwvwaQsDO7+cZj7DHuZWcC10xwRK/yBPp4ljjTDbmiQJR1h3
	 ufqccCh032krqS5AnZmkl4X9Oi8DdqSXHDndcpmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Ivy Lopez <skunkolee@gmail.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0704/1250] scsi: mpt3sas: Avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()
Date: Thu, 17 Sep 2026 16:08:19 +0100
Message-ID: <20260917151610.977663960@linuxfoundation.org>
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

From: Ivy Lopez <skunkolee@gmail.com>

[ Upstream commit e0d26fe176a8db6ccad4ab38c5bab29391c1946b ]

dev_to_node() can return NUMA_NO_NODE (-1) on systems without NUMA
topology information for the PCI device, such as single-socket boards
that don't expose device-to-node affinity. Passing -1 directly into
cpumask_of_node() indexes node_to_cpumask_map[-1], an out-of-bounds
array read caught by UBSAN:

  UBSAN: array-index-out-of-bounds in arch/x86/include/asm/topology.h:72:28
  index -1 is out of range for type 'cpumask *[1024]'

Fall back to cpu_online_mask when no NUMA node is available, rather than
assuming dev_to_node() always returns a valid node index.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221294
Suggested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Fixes: 728bbc6cbff7 ("scsi: mpt3sas: Affinity high iops queues IRQs to local node")
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260825190313.24013-1-skunkolee@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 55888ac6ed3a5..e5e5f0b8f34f5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3238,7 +3238,10 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		 * corresponding to high iops queues.
 		 */
 		if (ioc->high_iops_queues) {
-			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
+			int node = dev_to_node(&ioc->pdev->dev);
+
+			mask = (node == NUMA_NO_NODE) ?
+				cpu_online_mask : cpumask_of_node(node);
 			for (index = 0; index < ioc->high_iops_queues;
 			    index++) {
 				irq = pci_irq_vector(ioc->pdev, index);
-- 
2.53.0




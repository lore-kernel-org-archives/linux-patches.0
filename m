Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264294E77F9;
	Thu, 17 Sep 2026 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668974; cv=none; b=HkMAQYkvtXEwXx17lq8+KkRP3xIte7lSe9ucr6Wmxzoce+/vNTuJt+2SeZmeV9wWV/bcMqk/ziWbelun26Jeo48+VuxAasF3H90693YsoRUbFO2KURFqOz/EZY5P331LeAucyM6Dq/+RsTPGWLQF0GdWA6ZH44qmmto9kFeYKWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668974; c=relaxed/simple;
	bh=/iY8lnshwqVQZx/Evg+WPe4kz1Yfma3hZ3NDtAyURK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDKx00aIs2kxjP2UBTwG81qnP57wVZPu25VRtUZt8/TKf6GISOCYz7VPH6uF8bLrjQ5j9rs3YRluUFi6zziy7VN/2wboO+ykY8RMvM1eKbL0Zpbk4dQevh1ouD/fzf3Mq89rlwLibOpm1LWBhegh17JniBO7G/lqBMujcuvtEZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/jdv4h8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/jdv4h8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5A61F000FF;
	Thu, 17 Sep 2026 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668973;
	bh=oUUHcSKRdZDCPU7flEU65IhF8SXyw/xyxdTaI9J/DdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/jdv4h8urEuDrNKPUERakpj225TKHs4QoSD5sXH5BPnKETj6PxDVz2cdN4E4lXRz
	 lnelimUa5iBVohPefn1GbXG51bEHj4UsPy0IvwkNkpgRdRe+BPDElGj1suJVgaMzFP
	 Ou6FUcuZ63whujcoZ21hg8ARpCsdkpPuYz5kWDJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Ivy Lopez <skunkolee@gmail.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0595/1102] scsi: mpt3sas: Avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()
Date: Thu, 17 Sep 2026 16:08:58 +0100
Message-ID: <20260917151554.921351149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 0d78e9dbf641c..b533898a38601 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3227,7 +3227,10 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
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




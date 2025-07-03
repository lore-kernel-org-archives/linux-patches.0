Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5CC2E7649;
	Thu,  3 Jul 2025 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554311; cv=none; b=Wm0z550X00Jak6jUK209QldD93Np/uBM6jMH+hDH54jdzeWGZiqTED03lI2jMLtmc9ZHLnJ3NRD1s4LPAmGa76vmEYNB8Or3SClWgj/4KGZAaMMwZOTYXwvBqrMEZ+JUMm0oXSO3tOsZhRoQ7OlWcT1BU4GjELc5vSIcQfQzW1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554311; c=relaxed/simple;
	bh=TSVTSSGFULwsJxRT7HzxqweysG18FozcJYw/v2SThsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sni6mtrNd3pEO3266S6IsryhAM/ZNnG0P0qziYitSYldUu6eGzbhR0u6aKaCff1+anwDkULszZVXJNDqeL+bGpEtqe51e5g8EGBW+RXGBHzFj/UaL9GTM+BGIYqFJuAVlotPP/rHt8vxy/ZolAntuDGq9cY8v+BcWbO/m8dIWsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4NNgZ0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4NNgZ0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0A5C4CEE3;
	Thu,  3 Jul 2025 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554311;
	bh=TSVTSSGFULwsJxRT7HzxqweysG18FozcJYw/v2SThsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4NNgZ0DIoBYXxj3sJC3P4CwiP7TS2JoH0xZ+4FlVdihdjca1wSVH10FqEVjFaYDd
	 zVuWPznoiQTfYQk5LnzQtX0IQCVud0eAvUm3kRses1ajpSThoQiJ5beR3fufguhFD6
	 91CIwTPyWtzFZf0hmVa5Ms6KUq1O+negCWDCvNAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 146/218] scsi: megaraid_sas: Fix invalid node index
Date: Thu,  3 Jul 2025 16:41:34 +0200
Message-ID: <20250703144001.959426643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

commit 752eb816b55adb0673727ba0ed96609a17895654 upstream.

On a system with DRAM interleave enabled, out-of-bound access is
detected:

megaraid_sas 0000:3f:00.0: requested/available msix 128/128 poll_queue 0
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in ./arch/x86/include/asm/topology.h:72:28
index -1 is out of range for type 'cpumask *[1024]'
dump_stack_lvl+0x5d/0x80
ubsan_epilogue+0x5/0x2b
__ubsan_handle_out_of_bounds.cold+0x46/0x4b
megasas_alloc_irq_vectors+0x149/0x190 [megaraid_sas]
megasas_probe_one.cold+0xa4d/0x189c [megaraid_sas]
local_pci_probe+0x42/0x90
pci_device_probe+0xdc/0x290
really_probe+0xdb/0x340
__driver_probe_device+0x78/0x110
driver_probe_device+0x1f/0xa0
__driver_attach+0xba/0x1c0
bus_for_each_dev+0x8b/0xe0
bus_add_driver+0x142/0x220
driver_register+0x72/0xd0
megasas_init+0xdf/0xff0 [megaraid_sas]
do_one_initcall+0x57/0x310
do_init_module+0x90/0x250
init_module_from_file+0x85/0xc0
idempotent_init_module+0x114/0x310
__x64_sys_finit_module+0x65/0xc0
do_syscall_64+0x82/0x170
entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fix it accordingly.

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Link: https://lore.kernel.org/r/20250604042556.3731059-1-yu.c.chen@intel.com
Fixes: 8049da6f3943 ("scsi: megaraid_sas: Use irq_set_affinity_and_hint()")
Cc: stable@vger.kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5910,7 +5910,11 @@ megasas_set_high_iops_queue_affinity_and
 	const struct cpumask *mask;
 
 	if (instance->perf_mode == MR_BALANCED_PERF_MODE) {
-		mask = cpumask_of_node(dev_to_node(&instance->pdev->dev));
+		int nid = dev_to_node(&instance->pdev->dev);
+
+		if (nid == NUMA_NO_NODE)
+			nid = 0;
+		mask = cpumask_of_node(nid);
 
 		for (i = 0; i < instance->low_latency_index_start; i++) {
 			irq = pci_irq_vector(instance->pdev, i);



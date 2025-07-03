Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89B2ED143;
	Thu,  3 Jul 2025 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556184; cv=none; b=Yp566E3qrG8secy8eg60zVUOJmNsRjjXmfayEa1NHjWXYrJAbXpJGrEas/Lg9MilRptQJG+kApIgAgZo3PRQG7huUy9Ylbz6ryGK1rbvHULxAyhCGyHP32KMH2+K7bZuaMfjIoriZMCd7eqvsvaKNFT1+aUhShJv9RBnZop3DCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556184; c=relaxed/simple;
	bh=BE3QxL6R2/rwIaJqcxe13pPOR2f948PZHX4jUqp0FUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDYb3JRju/irvtmLyOhg9Qg7SscY7SVxKx2Ed1FbttoZLEUIypgV5APEucxEvabcMast1tDMZ2jcLMFtZEs3PVwXZ5OEpwWZ8scbHVWykD4K3nWJJFYuQ9BtnajgV9/u1Wrcp1CDLcNw+DTBrKsgBBxRptQV9FpZieZ68YFpw/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+TsHuio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+TsHuio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26675C4CEE3;
	Thu,  3 Jul 2025 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556183;
	bh=BE3QxL6R2/rwIaJqcxe13pPOR2f948PZHX4jUqp0FUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+TsHuiopAeX9dkir38l1wGE1+Pf3vXhrerYvrf7JdjoGpTsP5fEoGtbICief5aEx
	 +uI+CNBeujylCHsv1ZRMzmKW3lIcomAoRxlvFczKeajeZ5f8dNh05kyj4Ylp/5cnkD
	 JJS+gndMVWnaaNBR6vXeTVfUtifVGZRraqQEN4cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 101/132] scsi: megaraid_sas: Fix invalid node index
Date: Thu,  3 Jul 2025 16:43:10 +0200
Message-ID: <20250703143943.360499710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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
@@ -5909,7 +5909,11 @@ megasas_set_high_iops_queue_affinity_and
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



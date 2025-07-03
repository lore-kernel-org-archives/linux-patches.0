Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DFA2EE98F;
	Thu,  3 Jul 2025 15:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555172; cv=none; b=U68pBF7ma/fIVzApNCxYcR+PrB2LW+QQFaMeZUGD7z5bwKOFeMdpAP4oXMpYkOJOkW30f0Cs8T2V7DvLUlHlBnpljPHxKmfH/0SbF4+5LrJSSIw/l82myy24Kn3mmicrQLc5cJz+7NyNq7p9iFKIYlD4q2pNS3ZNQ4cPE+ZiV0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555172; c=relaxed/simple;
	bh=WvZ6nmUgHXaEYWqfC9x0Lm+/oWD3gHpR9KzbFR4Y3C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEDo/ZvTtjE5CLjUrXqgEdpewPp1XI17NYMpthuxtThz9CXTLu1S53ih2d76nn0E0tpjE1beEttJPsvMMTLhQ06W66xyavq0LJkHaIcRs/h4sCUQvm2wZpy5t2FXQIHeGpm1SaKTSH7YecI/T1JJNB0q/cuDLdfwthR/eQSDmEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2HXgi+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2HXgi+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F359C4CEE3;
	Thu,  3 Jul 2025 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555171;
	bh=WvZ6nmUgHXaEYWqfC9x0Lm+/oWD3gHpR9KzbFR4Y3C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2HXgi+ivc5Bl17uTP24KSYLeS8893ACPW3K37GWFB7LMsvEuyxQ6Pp/876K4wcfn
	 gq9Zs5ZGpX+Awb040G7sWXA3d+5u5/izO7YIRB0n32xW3T4kC/rY/PqCo23Zwk2aNR
	 URzO1RWA7T8/y97fVZvFh35Pt8NhRL6C6Ly4hBCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.15 198/263] scsi: megaraid_sas: Fix invalid node index
Date: Thu,  3 Jul 2025 16:41:58 +0200
Message-ID: <20250703144012.306344644@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3EAF9D7;
	Sat,  3 Feb 2024 04:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933347; cv=none; b=um+NgTc04SIVEu147fK8livvu3KUJ0+3IYk6LFVISynqRt+g9W85QZekOmV3Ctgt2nmnspFvW2wPgn5sQ/Q7cCjZ2NT64KlFxpL1LJLERB+fFvAa91dbttSzFTTiEXhKOSxBfjUOGhSIX9OnM4ZBuepSKWVT+cFyKxiy/uo5m2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933347; c=relaxed/simple;
	bh=/MnlGyblHDv1PfMYrnVx4N0GfJeK9YucJzsbi4MP39w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz6lJSvs0pmjSfK3GEkOOXPsresYWIifrcES4T+oLAs3VDpOtiU1NoQykbMlRPMATD29U40XHWs7NCcv4c49HbeeWyFNxRRb0bEYFVJRkGyTAneCS2fhNV1L6StS8Im6+XvRB+OTcr3CK8u6hLrQe09Kk/pWE/GnK/cSkzlp9vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XA4rWkN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XA4rWkN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82557C43390;
	Sat,  3 Feb 2024 04:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933347;
	bh=/MnlGyblHDv1PfMYrnVx4N0GfJeK9YucJzsbi4MP39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XA4rWkN07EwiWnF9/qn6SA7OJodwmSGiwce7u+lQsRIZKrhoPqjlX9h3gTGTf254P
	 yMYOW2c3aKmQctJDL9+HoP9v8kLQJ58kaXNTsoj1S13Zy0ZibGul1RTLz8WqsldLLx
	 HMJdWSQBOYIC0n3TWsoZNpcnAtfueYmXvDFrk96E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HariBabu Gattem <haribabu.gattem@xilinx.com>,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/219] soc: xilinx: Fix for call trace due to the usage of smp_processor_id()
Date: Fri,  2 Feb 2024 20:03:43 -0800
Message-ID: <20240203035323.714609905@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: HariBabu Gattem <haribabu.gattem@xilinx.com>

[ Upstream commit daed80ed07580e5adc0e6d8bc79933a35154135a ]

When preemption is enabled in kernel and if any task which can be
preempted should not use smp_processor_id() directly, since CPU
switch can happen at any time, the previous value of cpu_id
differs with current cpu_id. As a result we see the below call trace
during xlnx_event_manager_probe.

[ 6.140197] dump_backtrace+0x0/0x190
[ 6.143884] show_stack+0x18/0x40
[ 6.147220] dump_stack_lvl+0x7c/0xa0
[ 6.150907] dump_stack+0x18/0x34
[ 6.154241] check_preemption_disabled+0x124/0x134
[ 6.159068] debug_smp_processor_id+0x20/0x2c
[ 6.163453] xlnx_event_manager_probe+0x48/0x250

To protect cpu_id, It is recommended to use get_cpu()/put_cpu()
to disable preemption, get the cpu_id and enable preemption respectively.
(For Reference, Documentation/locking/preempt-locking.rst and
Documentation/kernel-hacking/hacking.rst)

Use preempt_disable()/smp_processor_id()/preempt_enable()
API's to achieve the same.

Signed-off-by: HariBabu Gattem <haribabu.gattem@xilinx.com>
Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Link: https://lore.kernel.org/r/20231027055622.21544-1-jay.buddhabhatti@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/xlnx_event_manager.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/xlnx_event_manager.c b/drivers/soc/xilinx/xlnx_event_manager.c
index f9d9b82b562d..56d22d3989bb 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -555,7 +555,7 @@ static void xlnx_disable_percpu_irq(void *data)
 static int xlnx_event_init_sgi(struct platform_device *pdev)
 {
 	int ret = 0;
-	int cpu = smp_processor_id();
+	int cpu;
 	/*
 	 * IRQ related structures are used for the following:
 	 * for each SGI interrupt ensure its mapped by GIC IRQ domain
@@ -592,9 +592,12 @@ static int xlnx_event_init_sgi(struct platform_device *pdev)
 	sgi_fwspec.param[0] = sgi_num;
 	virq_sgi = irq_create_fwspec_mapping(&sgi_fwspec);
 
+	cpu = get_cpu();
 	per_cpu(cpu_number1, cpu) = cpu;
 	ret = request_percpu_irq(virq_sgi, xlnx_event_handler, "xlnx_event_mgmt",
 				 &cpu_number1);
+	put_cpu();
+
 	WARN_ON(ret);
 	if (ret) {
 		irq_dispose_mapping(virq_sgi);
-- 
2.43.0




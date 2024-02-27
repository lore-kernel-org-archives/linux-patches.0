Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12AE54FA5;
	Tue, 27 Feb 2024 13:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040933; cv=none; b=HkBmva+1f0obOQo/dfIENuLrIDyRxaeRsuvZpF5/y9t5eAX3abv2KZRWa1327XARtfV52mz73WvKyFhdUeGCTbsdDjnW6RzIlVgPMN+ZHkFsLHojzl/GWtoTOoGPxgYi/sriHfEQ7z2ADWFrdhNdlsdqTxXZv+zqDKTIlqL5dqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040933; c=relaxed/simple;
	bh=x85VTfm1SclGl/pKFRLXzHv7+jkPPW/vlb+PfkaXs54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdDmtaasKqVTfbHNmFDRXAo3H7o9yT9bRFs+70MdiHCxTr+ukBk5VMrtuRPx4lifzIHZGa8SnHuYQOd6XUIGdw/l5s9rsstECjMVfjqiRIULdRVnOnDbM4NaGANuo5x2BsYW5mb1Gui663yR7qHC4dWlEUEKIbxnjV4emj1R8SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6vVouQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6vVouQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563B8C433F1;
	Tue, 27 Feb 2024 13:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040933;
	bh=x85VTfm1SclGl/pKFRLXzHv7+jkPPW/vlb+PfkaXs54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6vVouQFQ4+WLk8EDH+iCwPqsqCPRY8Sk0yGUs/A9+CbMQP/HSddvGQiSyA8NCTYd
	 PGExXPwIv34Du2DMSVCLfTT7kLSlZ1cVBL+p0hImysqBwJkJz9wOq1X3rWr8VtY+0P
	 J+H6HyDesfv7VkM2SQiub0zX+Zs5Qs5uT3myxT1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.7 160/334] Revert "parisc: Only list existing CPUs in cpu_possible_mask"
Date: Tue, 27 Feb 2024 14:20:18 +0100
Message-ID: <20240227131635.639876145@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 82b143aeb169b8b55798d7d2063032e1a6ceeeb0 upstream.

This reverts commit 0921244f6f4f0d05698b953fe632a99b38907226.

It broke CPU hotplugging because it modifies the __cpu_possible_mask
after bootup, so that it will be different than nr_cpu_ids, which
then effictively breaks the workqueue setup code and triggers crashes
when shutting down CPUs at runtime.

Guenter was the first who noticed the wrong values in __cpu_possible_mask,
since the cpumask Kunit tests were failig.

Reverting this commit fixes both issues, but sadly brings back this
uncritical runtime warning:
register_cpu_capacity_sysctl: too early to get CPU4 device!

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lkml.org/lkml/2024/2/4/146
Link: https://lore.kernel.org/lkml/Zb0mbHlIud_bqftx@slm.duckdns.org/t/
Cc: stable@vger.kernel.org # 6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/processor.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -172,7 +172,6 @@ static int __init processor_probe(struct
 	p->cpu_num = cpu_info.cpu_num;
 	p->cpu_loc = cpu_info.cpu_loc;
 
-	set_cpu_possible(cpuid, true);
 	store_cpu_topology(cpuid);
 
 #ifdef CONFIG_SMP
@@ -474,13 +473,6 @@ static struct parisc_driver cpu_driver _
  */
 void __init processor_init(void)
 {
-	unsigned int cpu;
-
 	reset_cpu_topology();
-
-	/* reset possible mask. We will mark those which are possible. */
-	for_each_possible_cpu(cpu)
-		set_cpu_possible(cpu, false);
-
 	register_parisc_driver(&cpu_driver);
 }



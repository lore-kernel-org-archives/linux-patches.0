Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1901E5B88;
	Wed, 19 Mar 2025 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395113; cv=none; b=CsMnAjH/TQAZLlju2ifgj/7ctQj3Uws2C9UnYGDyAWGfCUIAYZUEtug9pwV7g6JmvnR4nh5Up4plOZ5WaXSvq9DWkesptU4iOd4/ySBafpieTYh87pfrExA4135dU80aUErryXf0upRfVgU+YksERggbVA5yDwhPcfko6AGTbdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395113; c=relaxed/simple;
	bh=OfKCXHWSkuELpeTxfGz0on4hN9g6jVV1/k9Mc6TcPqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQI0JAu2RMpgMtRoTfTcZlTuArVrNTNx5rrT2tX6Q6UqkJR5kwCDIIW6LGFkUfsNmnJBCDiKABS2Oz5KozHa9a/cx22VzXf5xsRye92bWupRc1mJ/Nla5mQpCKwdeN+qDNaW+51Sz5xFup8EQztszzpEFRwrfQonSzyHWXbl7wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZhY/iBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZhY/iBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3114C4CEE8;
	Wed, 19 Mar 2025 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395112;
	bh=OfKCXHWSkuELpeTxfGz0on4hN9g6jVV1/k9Mc6TcPqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZhY/iBIflL1LUUtLba/mDgQF2sViulqiRzAZPNlqlq3ozg29cE5pCRGMt1VyQzBG
	 f8/ahJsUkvcbzl7IUyD6+jMfb3HfCRh+pZNHgLUOXtr/ltALzg2s9obwaBd3SIWKtw
	 0WkNukWQvlEALU1Bf4ixuzc6L+PCEijDptxQy2s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 167/231] x86/microcode/AMD: Fix out-of-bounds on systems with CPU-less NUMA nodes
Date: Wed, 19 Mar 2025 07:31:00 -0700
Message-ID: <20250319143030.968588311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Florent Revest <revest@chromium.org>

commit e3e89178a9f4a80092578af3ff3c8478f9187d59 upstream.

Currently, load_microcode_amd() iterates over all NUMA nodes, retrieves their
CPU masks and unconditionally accesses per-CPU data for the first CPU of each
mask.

According to Documentation/admin-guide/mm/numaperf.rst:

  "Some memory may share the same node as a CPU, and others are provided as
  memory only nodes."

Therefore, some node CPU masks may be empty and wouldn't have a "first CPU".

On a machine with far memory (and therefore CPU-less NUMA nodes):
- cpumask_of_node(nid) is 0
- cpumask_first(0) is CONFIG_NR_CPUS
- cpu_data(CONFIG_NR_CPUS) accesses the cpu_info per-CPU array at an
  index that is 1 out of bounds

This does not have any security implications since flashing microcode is
a privileged operation but I believe this has reliability implications by
potentially corrupting memory while flashing a microcode update.

When booting with CONFIG_UBSAN_BOUNDS=y on an AMD machine that flashes
a microcode update. I get the following splat:

  UBSAN: array-index-out-of-bounds in arch/x86/kernel/cpu/microcode/amd.c:X:Y
  index 512 is out of range for type 'unsigned long[512]'
  [...]
  Call Trace:
   dump_stack
   __ubsan_handle_out_of_bounds
   load_microcode_amd
   request_microcode_amd
   reload_store
   kernfs_fop_write_iter
   vfs_write
   ksys_write
   do_syscall_64
   entry_SYSCALL_64_after_hwframe

Change the loop to go over only NUMA nodes which have CPUs before determining
whether the first CPU on the respective node needs microcode update.

  [ bp: Massage commit message, fix typo. ]

Fixes: 7ff6edf4fef3 ("x86/microcode/AMD: Fix mixed steppings support")
Signed-off-by: Florent Revest <revest@chromium.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250310144243.861978-1-revest@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -1075,7 +1075,7 @@ static enum ucode_state load_microcode_a
 	if (ret != UCODE_OK)
 		return ret;
 
-	for_each_node(nid) {
+	for_each_node_with_cpus(nid) {
 		cpu = cpumask_first(cpumask_of_node(nid));
 		c = &cpu_data(cpu);
 



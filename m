Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17571E7C18;
	Wed, 19 Mar 2025 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394948; cv=none; b=OdFunuCT3mghBimu0WgNXAFzGuPw60DN5OCRNqaXq/1ROCfPRnql0nwykbgRYHetZXgilF2fUli3NL79osBLGwEGuSYC8tto47N9tvM+wH814fDBJ5hxJGbjUnHyqH5QGGnsQcwjAJps4ExlmAHyF/vUfhir4V3NbAQK7BfVYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394948; c=relaxed/simple;
	bh=IncLkhGMLxC1yuoXsbBU87b05B7r8Rv22L+hDi0/chE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPRRcD2p38Mnju1DG9XV5gNdboaYKeJf2XvQp7oGMbzlRj6jVWAO/CDJxLyk0Q+K5/XWcz1tzoiZ6Z+QcgLZDZgBKU6xOo+by1/5x1u007VcQU/NuodUEjoB0DdcMdiH6Hnb68C4hCd15PURMYmUMsicZBlz2PYGf+7Bveq4ofc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fN5oxkbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fN5oxkbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A78DC4CEE4;
	Wed, 19 Mar 2025 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394948;
	bh=IncLkhGMLxC1yuoXsbBU87b05B7r8Rv22L+hDi0/chE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fN5oxkbXbnj7q9opE3/Z3TEIpdx98e/H4YodgUryrI2Sz49kPFeo4LVhjvY+VBn/P
	 fSseHw5Lj3rAErqgXcBmiQarEwr7hIXV3q2EJ6o7dCRIFfhfj4mLCj4xKl+XFL0W9Q
	 oCGss87sMh0+tjtLzdBZoGNXbh7tBUjyFp+7qga0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.13 172/241] x86/microcode/AMD: Fix out-of-bounds on systems with CPU-less NUMA nodes
Date: Wed, 19 Mar 2025 07:30:42 -0700
Message-ID: <20250319143031.988336974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 



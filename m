Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D772192F2;
	Tue,  8 Apr 2025 11:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112407; cv=none; b=W5b8e7S6t4Y2wEVWMBQz91hn9B8SMNpi0y6TN1jTrZGDw+7BjwHWRzj5NczCxTsDusWNuTJtGJEIGhwBb5MRKKMUKxn2ucxZnyxMeYsC4mrejiL2GfWqFrP+HrypmloZ8eXtD7FunE3FNkPrDSZB/ayas2HpCenVuHZptkXJWzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112407; c=relaxed/simple;
	bh=4z7I+tDEnAQP+1hoWg475y7VeX/qYDOAtrL0vr7E0zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Av/epaK2mdWPH/7T08kwliIBUBjeNyNZuRd9iKhZ1pbkJd78mUyz80588yoi2WG9cGEUANoljfmsQdi8RYweJqmh13Xs4J8dsjajIBNb3TjsG9PRQSogrX1+q69V75BCpeHB7qWQMP/XVyKEkoysG170qS5pRkvPEjt3Umz18Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB82TKxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB82TKxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9CAC4CEE5;
	Tue,  8 Apr 2025 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112407;
	bh=4z7I+tDEnAQP+1hoWg475y7VeX/qYDOAtrL0vr7E0zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB82TKxqjXp64vMRXpan5VwVclgwb9nWwyIPWhI0hVbDHDKm8ON5VeD4zfAlIjId7
	 thd5hGTMFvGqhMSynSexcVg1kLAUWccq8qHcR+zJ4dfb2faDtPbjVob3D5d1nWQgTV
	 qW5kqVVg4xHCrnpSEt0h7H/VD5dj6xjw+/cP7PAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 057/279] x86/microcode/AMD: Fix out-of-bounds on systems with CPU-less NUMA nodes
Date: Tue,  8 Apr 2025 12:47:20 +0200
Message-ID: <20250408104827.895636727@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -861,7 +861,7 @@ static enum ucode_state load_microcode_a
 		return ret;
 	}
 
-	for_each_node(nid) {
+	for_each_node_with_cpus(nid) {
 		cpu = cpumask_first(cpumask_of_node(nid));
 		c = &cpu_data(cpu);
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48F228DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClBGYwGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41CCC433C7;
	Mon, 16 Oct 2023 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468119;
	bh=6B02Pn2IJViyGc81ef/UjWQwdkpbdrLfRs8QKQKDL2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClBGYwGgUWleOW8kAmAxo1+2YSddqIw1gpccgYr5FcibxNqIpx+RiKrHAimA7/F31
	 5uHnZvhC1tgBGVais3pJ8OqiEsEIVACjas9xcbyVc25EXbsyIkcLRm2VRx41OlFyZR
	 1nENRFoIUczMCL7Ae3khdJKZ1XAO/EEk65ih52iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.5 144/191] powerpc/pseries: Fix STK_PARAM access in the hcall tracing code
Date: Mon, 16 Oct 2023 10:42:09 +0200
Message-ID: <20231016084018.744228426@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

commit 3b678768c0458e6d8d45fadf61423e44effed4cb upstream.

In powerpc pseries system, below behaviour is observed while
enabling tracing on hcall:
  # cd /sys/kernel/debug/tracing/
  # cat events/powerpc/hcall_exit/enable
  0
  # echo 1 > events/powerpc/hcall_exit/enable

  # ls
  -bash: fork: Bad address

Above is from power9 lpar with latest kernel. Past this, softlockup
is observed. Initially while attempting via perf_event_open to
use "PERF_TYPE_TRACEPOINT", kernel panic was observed.

perf config used:
================
  memset(&pe[1],0,sizeof(struct perf_event_attr));
  pe[1].type=PERF_TYPE_TRACEPOINT;
  pe[1].size=96;
  pe[1].config=0x26ULL; /* 38 raw_syscalls/sys_exit */
  pe[1].sample_type=0; /* 0 */
  pe[1].read_format=PERF_FORMAT_TOTAL_TIME_ENABLED|PERF_FORMAT_TOTAL_TIME_RUNNING|PERF_FORMAT_ID|PERF_FORMAT_GROUP|0x10ULL; /* 1f */
  pe[1].inherit=1;
  pe[1].precise_ip=0; /* arbitrary skid */
  pe[1].wakeup_events=0;
  pe[1].bp_type=HW_BREAKPOINT_EMPTY;
  pe[1].config1=0x1ULL;

Kernel panic logs:
==================

  Kernel attempted to read user page (8) - exploit attempt? (uid: 0)
  BUG: Kernel NULL pointer dereference on read at 0x00000008
  Faulting instruction address: 0xc0000000004c2814
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in: nfnetlink bonding tls rfkill sunrpc dm_service_time dm_multipath pseries_rng xts vmx_crypto xfs libcrc32c sd_mod t10_pi crc64_rocksoft crc64 sg ibmvfc scsi_transport_fc ibmveth dm_mirror dm_region_hash dm_log dm_mod fuse
  CPU: 0 PID: 1431 Comm: login Not tainted 6.4.0+ #1
  Hardware name: IBM,8375-42A POWER9 (raw) 0x4e0202 0xf000005 of:IBM,FW950.30 (VL950_892) hv:phyp pSeries
  NIP page_remove_rmap+0x44/0x320
  LR  wp_page_copy+0x384/0xec0
  Call Trace:
    0xc00000001416e400 (unreliable)
    wp_page_copy+0x384/0xec0
    __handle_mm_fault+0x9d4/0xfb0
    handle_mm_fault+0xf0/0x350
    ___do_page_fault+0x48c/0xc90
    hash__do_page_fault+0x30/0x70
    do_hash_fault+0x1a4/0x330
    data_access_common_virt+0x198/0x1f0
   --- interrupt: 300 at 0x7fffae971abc

git bisect tracked this down to below commit:
'commit baa49d81a94b ("powerpc/pseries: hvcall stack frame overhead")'

This commit changed STACK_FRAME_OVERHEAD (112 ) to
STACK_FRAME_MIN_SIZE (32 ) since 32 bytes is the minimum size
for ELFv2 stack. With the latest kernel, when running on ELFv2,
STACK_FRAME_MIN_SIZE is used to allocate stack size.

During plpar_hcall_trace, first call is made to HCALL_INST_PRECALL
which saves the registers and allocates new stack frame. In the
plpar_hcall_trace code, STK_PARAM is accessed at two places.
  1. To save r4: std     r4,STK_PARAM(R4)(r1)
  2. To access r4 back: ld      r12,STK_PARAM(R4)(r1)

HCALL_INST_PRECALL precall allocates a new stack frame. So all
the stack parameter access after the precall, needs to be accessed
with +STACK_FRAME_MIN_SIZE. So the store instruction should be:
  std     r4,STACK_FRAME_MIN_SIZE+STK_PARAM(R4)(r1)

If the "std" is not updated with STACK_FRAME_MIN_SIZE, we will
end up with overwriting stack contents and cause corruption.
But instead of updating 'std', we can instead remove it since
HCALL_INST_PRECALL already saves it to the correct location.

similarly load instruction should be:
  ld      r12,STACK_FRAME_MIN_SIZE+STK_PARAM(R4)(r1)

Fix the load instruction to correctly access the stack parameter
with +STACK_FRAME_MIN_SIZE and remove the store of r4 since the
precall saves it correctly.

Cc: stable@vger.kernel.org # v6.2+
Fixes: baa49d81a94b ("powerpc/pseries: hvcall stack frame overhead")
Co-developed-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230929172337.7906-1-atrajeev@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/hvCall.S |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -185,7 +185,6 @@ _GLOBAL_TOC(plpar_hcall)
 plpar_hcall_trace:
 	HCALL_INST_PRECALL(R5)
 
-	std	r4,STK_PARAM(R4)(r1)
 	mr	r0,r4
 
 	mr	r4,r5
@@ -197,7 +196,7 @@ plpar_hcall_trace:
 
 	HVSC
 
-	ld	r12,STK_PARAM(R4)(r1)
+	ld	r12,STACK_FRAME_MIN_SIZE+STK_PARAM(R4)(r1)
 	std	r4,0(r12)
 	std	r5,8(r12)
 	std	r6,16(r12)
@@ -297,7 +296,6 @@ _GLOBAL_TOC(plpar_hcall9)
 plpar_hcall9_trace:
 	HCALL_INST_PRECALL(R5)
 
-	std	r4,STK_PARAM(R4)(r1)
 	mr	r0,r4
 
 	mr	r4,r5



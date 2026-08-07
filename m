Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7C44238F;
	Fri,  7 Aug 2026 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117135; cv=none; b=nDB/xc4uYqGdQbMbQ7pPYL1xjzlcogXQ203pZSfscNDdpFoBKma54CwObC5ByyJqXtbVDbsj2bulpvfFE+neoHCJKaFERvIbNLUtqaycKw8zaMDWUvIOq1yr0pShCcbNcgUr9b/81WDvC/oL20m8s1Zlgoh4xoodTEkUIujHAEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117135; c=relaxed/simple;
	bh=v84+PAkRFRx31Yssv+CXs5mwYKZ+j6UAjZ9pyvfwBSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS9bYJcUvoGYODrj04AmSN8Jx/iO0iwa4u7fYywTNzpj34oHfu8I26IdXskiy7Pa1EZLeaB5fiEiV6jnUIS51+ifAofzWaOHZp54xMuQDKDkWbbncg/dVSKGNRyvPQoy2e6bd8dsJL9DICt6UMf8YhiVIR7jAgyc7L7D9979uM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGArWoYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGArWoYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C245D1F000E9;
	Fri,  7 Aug 2026 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117134;
	bh=xUmSb+phCtcvjrxCN179kf6FM2SAsU36zxEcf/VkNW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGArWoYcGSUuh30Kdkm4aeCV9apVMgGDni6noRX5ZgOl7/Qr0qmQ2mET4CYGTckbL
	 iuJlIHCWKnuOXVEwjNEdfzF5EZwToIs6WbQSkxnZ6M2MOEPOuNWn9HCtdmvbB1UhOV
	 Sc4gtyXIjU1e+Ci06iP1Q3ugSZ7VyUDQ8fWFd14g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 168/438] riscv: drop __init from vec_check_unaligned_access_speed_all_cpus
Date: Fri,  7 Aug 2026 16:36:04 +0200
Message-ID: <20260807143431.615350086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

[ Upstream commit f51fed61eea0daba2f95f1a6074085e4cd513c7b ]

This function runs within a kthread and need not necessarily finish
before system finishes boot and free_initmem() unmaps the .init.text
section. This function makes calls to SBI for probing unaligned access
speed, and if this is slow for some reason (say some debug prints were
added to SBI), the kthread can still be running at this point and result
in an instruction page fault when trying to fetch from the freed region.

[   25.642087] Unable to handle kernel paging request at virtual address ffffffff80a04ef8
[   25.646694] Current vec_check_unali pgtable: 4K pagesize, 48-bit VAs, pgdp=0x00004000316e9000
[   25.653170] [ffffffff80a04ef8] pgd=000010004be7e401, p4d=000010004be7e401, pud=000010004be7e001, pmd=000010000c3000e3
[   25.661244] Oops [#1]
[   25.662997] Modules linked in:
[   25.665357] CPU: 3 UID: 0 PID: 42 Comm: vec_check_unali Not tainted 7.0.0-tt-blackhole-asrinivasan-00007-g30ff73f18211 #570 PREEMPTLAZY
[   25.674669] Hardware name: Tenstorrent Blackhole (DT)
[   25.678545] epc : vec_check_unaligned_access_speed_all_cpus+0x18/0x2c
[   25.683458]  ra : vec_check_unaligned_access_speed_all_cpus+0x18/0x2c
[   25.688372] epc : ffffffff80a04ef8 ra : ffffffff80a04ef8 sp : ffff8f8000203e20
[   25.693874]  gp : ffffffff814dc168 tp : ffffaf8001ad9900 t0 : 0000000000000000
[   25.699401]  t1 : fffffffffffffff0 t2 : ffffaf8001ad9a10 s0 : ffff8f8000203e30
[   25.704912]  s1 : ffffaf80018dc780 a0 : 0000000000000000 a1 : 0000000000000002
[   25.710407]  a2 : 00000000000001f0 a3 : 0000000000000018 a4 : 0000000000000000
[   25.715917]  a5 : 0000000000000000 a6 : ffffaf8001c03d98 a7 : ffffaf8001c03e30
[   25.721419]  s2 : ffff8f8000023c98 s3 : ffffaf8001aa1240 s4 : ffffffff80a04ee0
[   25.726937]  s5 : 0000000000000000 s6 : 0000000000000000 s7 : 0000000000000000
[   25.732450]  s8 : 0000000000000000 s9 : 0000000000000000 s10: 0000000000000000
[   25.737944]  s11: 0000000000000000 t3 : 0000000000000002 t4 : 0000000000000402
[   25.743481]  t5 : 0000000000000040 t6 : 0000000000000004 ssp : 0000000000000000
[   25.749024] status: 0000000200000120 badaddr: ffffffff80a04ef8 cause: 000000000000000c
[   25.755060] [<ffffffff80a04ef8>] vec_check_unaligned_access_speed_all_cpus+0x18/0x2c
[   25.760964] [<ffffffff80047a10>] kthread+0xd8/0xfc
[   25.764660] [<ffffffff80010c48>] ret_from_fork_kernel+0x18/0x1c4
[   25.769220] [<ffffffff80895fe6>] ret_from_fork_kernel_asm+0x16/0x18
[   25.774018] Code: cccc cccc cccc cccc cccc cccc cccc cccc cccc cccc (cccc) cccc

Drop __init from its signature so that this doesn't happen.

Fixes: a00e022be531 ("riscv: Annotate unaligned access init functions")
Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Assisted-by: Claude:claude-opus-4-6
Link: https://patch.msgid.link/20260612-vec_unaligned_drop_init-v1-1-df969210ae34@oss.tenstorrent.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/unaligned_access_speed.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 11c781a4de733..557d661364ac5 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -314,7 +314,7 @@ static void check_vector_unaligned_access(struct work_struct *work __always_unus
 }
 
 /* Measure unaligned access speed on all CPUs present at boot in parallel. */
-static int __init vec_check_unaligned_access_speed_all_cpus(void *unused __always_unused)
+static int vec_check_unaligned_access_speed_all_cpus(void *unused __always_unused)
 {
 	schedule_on_each_cpu(check_vector_unaligned_access);
 	riscv_hwprobe_complete_async_probe();
@@ -322,7 +322,7 @@ static int __init vec_check_unaligned_access_speed_all_cpus(void *unused __alway
 	return 0;
 }
 #else /* CONFIG_RISCV_PROBE_VECTOR_UNALIGNED_ACCESS */
-static int __init vec_check_unaligned_access_speed_all_cpus(void *unused __always_unused)
+static int vec_check_unaligned_access_speed_all_cpus(void *unused __always_unused)
 {
 	return 0;
 }
-- 
2.53.0




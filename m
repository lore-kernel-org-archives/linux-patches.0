Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C3AF519;
	Thu, 25 Jul 2024 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918939; cv=none; b=ZfoAFpY/zeGjlJ5QcXeOip9HL221OTHnrYr+f4RJzMEPYoZ3cpMckYyq9QXP5/54sqaWeAeegYS1IxMOgYOWv32f0yA/dpNm+YlZcllrBMNwZu5Tha8HwEQq3VPuDfNNFEhRN3CU4GcOEIRz9e4TobkjfqNNUmMzOnyxdur0BdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918939; c=relaxed/simple;
	bh=SaTTyA1jQuW1SNntK6T0+xpyYgaefbtlHSfDGzudQ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DecHd+vlHxZctnIsFUFZO2l9le7TRrOQ9HTBEjtHzEn3kaZD3aR6l6KjvVYfoWER113z4nRxh5NA/bAX2+oZ/MsPVJgxWC29zAOcVir1AeuUiaHJPK2IMfIrerPxcbwkuXyd251FFOkWqVMG/ptwNzHHjkHYqhJWgKtMuyrdB6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7FkOqLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7FkOqLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF01C116B1;
	Thu, 25 Jul 2024 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918939;
	bh=SaTTyA1jQuW1SNntK6T0+xpyYgaefbtlHSfDGzudQ7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7FkOqLnTswQ/BkjVBezncndqkpMZJ3KP93TlrjYjHkMh1oMWGDw7ezOQAEoNBUFe
	 4JLZVhgR+Fc1xdz5BPERv0vL1LbyE62nrUcZ/TfdbKn5b3783l4T23Gu0OWIEDWWq0
	 3yZ3RzlahlAshkKHluCslZGU22/nYBHs6JaSkQzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Chourasia <vishalc@linux.ibm.com>,
	Anjali K <anjalik@linux.ibm.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/59] powerpc/pseries: Whitelist dtl slub object for copying to userspace
Date: Thu, 25 Jul 2024 16:37:25 +0200
Message-ID: <20240725142734.591357943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anjali K <anjalik@linux.ibm.com>

[ Upstream commit 1a14150e1656f7a332a943154fc486504db4d586 ]

Reading the dispatch trace log from /sys/kernel/debug/powerpc/dtl/cpu-*
results in a BUG() when the config CONFIG_HARDENED_USERCOPY is enabled as
shown below.

    kernel BUG at mm/usercopy.c:102!
    Oops: Exception in kernel mode, sig: 5 [#1]
    LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
    Modules linked in: xfs libcrc32c dm_service_time sd_mod t10_pi sg ibmvfc
    scsi_transport_fc ibmveth pseries_wdt dm_multipath dm_mirror dm_region_hash dm_log dm_mod fuse
    CPU: 27 PID: 1815 Comm: python3 Not tainted 6.10.0-rc3 #85
    Hardware name: IBM,9040-MRX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1060.00 (NM1060_042) hv:phyp pSeries
    NIP:  c0000000005d23d4 LR: c0000000005d23d0 CTR: 00000000006ee6f8
    REGS: c000000120c078c0 TRAP: 0700   Not tainted  (6.10.0-rc3)
    MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 2828220f  XER: 0000000e
    CFAR: c0000000001fdc80 IRQMASK: 0
    [ ... GPRs omitted ... ]
    NIP [c0000000005d23d4] usercopy_abort+0x78/0xb0
    LR [c0000000005d23d0] usercopy_abort+0x74/0xb0
    Call Trace:
     usercopy_abort+0x74/0xb0 (unreliable)
     __check_heap_object+0xf8/0x120
     check_heap_object+0x218/0x240
     __check_object_size+0x84/0x1a4
     dtl_file_read+0x17c/0x2c4
     full_proxy_read+0x8c/0x110
     vfs_read+0xdc/0x3a0
     ksys_read+0x84/0x144
     system_call_exception+0x124/0x330
     system_call_vectored_common+0x15c/0x2ec
    --- interrupt: 3000 at 0x7fff81f3ab34

Commit 6d07d1cd300f ("usercopy: Restrict non-usercopy caches to size 0")
requires that only whitelisted areas in slab/slub objects can be copied to
userspace when usercopy hardening is enabled using CONFIG_HARDENED_USERCOPY.
Dtl contains hypervisor dispatch events which are expected to be read by
privileged users. Hence mark this safe for user access.
Specify useroffset=0 and usersize=DISPATCH_LOG_BYTES to whitelist the
entire object.

Co-developed-by: Vishal Chourasia <vishalc@linux.ibm.com>
Signed-off-by: Vishal Chourasia <vishalc@linux.ibm.com>
Signed-off-by: Anjali K <anjalik@linux.ibm.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240614173844.746818-1-anjalik@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 822be2680b792..8e4a2e8aee114 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -312,8 +312,8 @@ static int alloc_dispatch_log_kmem_cache(void)
 {
 	void (*ctor)(void *) = get_dtl_cache_ctor();
 
-	dtl_cache = kmem_cache_create("dtl", DISPATCH_LOG_BYTES,
-						DISPATCH_LOG_BYTES, 0, ctor);
+	dtl_cache = kmem_cache_create_usercopy("dtl", DISPATCH_LOG_BYTES,
+						DISPATCH_LOG_BYTES, 0, 0, DISPATCH_LOG_BYTES, ctor);
 	if (!dtl_cache) {
 		pr_warn("Failed to create dispatch trace log buffer cache\n");
 		pr_warn("Stolen time statistics will be unreliable\n");
-- 
2.43.0




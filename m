Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9014026B97E;
	Tue,  8 Apr 2025 12:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116042; cv=none; b=lyubeCq67KvPZ5log5zbtzW9/0iUmBA8JAHmCyWHh9TbYluNrqK7CSGJ1EL2I+MK5lFl028TgNeKkje0RE+lE9XylD/qoFbQVz1WsMRmuYNjBY/88RODKoWFY2efJ+ZU4iQveGf7sR1BPZXIibNFANfhjRgCZxn50csXWF/wrDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116042; c=relaxed/simple;
	bh=7pMeQEcpAObUdVL7x3niJzVgoMwDFgLvVl/CEEU2Ne0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VP9hyQvIqvkqQFZTX3upoHSd/w82vqYp010fHCt9ECmw8jmeW9DAnwXCOrVUutRxiwbGDJo0djxkDFgPsG6D0y7kWbzelNnLLj3eBZ+osmHaWqv28NvcKwwBv2MSG6XOm2ybO90ha9AFTCYzlvA3UZegwAzOwW33JDHqwFmuYrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7gFBgKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7gFBgKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238F2C4CEE7;
	Tue,  8 Apr 2025 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116042;
	bh=7pMeQEcpAObUdVL7x3niJzVgoMwDFgLvVl/CEEU2Ne0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7gFBgKtQD6iT8o97E2bECdFE1gxuSi5hW4wrC8bIsok6AXnCS50ktnz6T8NP36Be
	 xAh2Hjfwcr+T8sIxRiZnyJgjwD2090IrVFAnDqle/XWKql1GTDn8QCzfpGb5Jvw+ap
	 VIyo07mnpv/Zf8cdrIoje4riNQevaIKKIWJR6AT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelos Oikonomopoulos <angelos@igalia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 197/204] arm64: Dont call NULL in do_compat_alignment_fixup()
Date: Tue,  8 Apr 2025 12:52:07 +0200
Message-ID: <20250408104826.093905140@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: Angelos Oikonomopoulos <angelos@igalia.com>

commit c28f31deeacda307acfee2f18c0ad904e5123aac upstream.

do_alignment_t32_to_handler() only fixes up alignment faults for
specific instructions; it returns NULL otherwise (e.g. LDREX). When
that's the case, signal to the caller that it needs to proceed with the
regular alignment fault handling (i.e. SIGBUS). Without this patch, the
kernel panics:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Mem abort info:
    ESR = 0x0000000086000006
    EC = 0x21: IABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x06: level 2 translation fault
  user pgtable: 4k pages, 48-bit VAs, pgdp=00000800164aa000
  [0000000000000000] pgd=0800081fdbd22003, p4d=0800081fdbd22003, pud=08000815d51c6003, pmd=0000000000000000
  Internal error: Oops: 0000000086000006 [#1] SMP
  Modules linked in: cfg80211 rfkill xt_nat xt_tcpudp xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo xt_addrtype nft_compat br_netfilter veth nvme_fa>
   libcrc32c crc32c_generic raid0 multipath linear dm_mod dax raid1 md_mod xhci_pci nvme xhci_hcd nvme_core t10_pi usbcore igb crc64_rocksoft crc64 crc_t10dif crct10dif_generic crct10dif_ce crct10dif_common usb_common i2c_algo_bit i2c>
  CPU: 2 PID: 3932954 Comm: WPEWebProcess Not tainted 6.1.0-31-arm64 #1  Debian 6.1.128-1
  Hardware name: GIGABYTE MP32-AR1-00/MP32-AR1-00, BIOS F18v (SCP: 1.08.20211002) 12/01/2021
  pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : 0x0
  lr : do_compat_alignment_fixup+0xd8/0x3dc
  sp : ffff80000f973dd0
  x29: ffff80000f973dd0 x28: ffff081b42526180 x27: 0000000000000000
  x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
  x23: 0000000000000004 x22: 0000000000000000 x21: 0000000000000001
  x20: 00000000e8551f00 x19: ffff80000f973eb0 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
  x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: 0000000000000000 x9 : ffffaebc949bc488
  x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : 0000000000400000 x4 : 0000fffffffffffe x3 : 0000000000000000
  x2 : ffff80000f973eb0 x1 : 00000000e8551f00 x0 : 0000000000000001
  Call trace:
   0x0
   do_alignment_fault+0x40/0x50
   do_mem_abort+0x4c/0xa0
   el0_da+0x48/0xf0
   el0t_32_sync_handler+0x110/0x140
   el0t_32_sync+0x190/0x194
  Code: bad PC value
  ---[ end trace 0000000000000000 ]---

Signed-off-by: Angelos Oikonomopoulos <angelos@igalia.com>
Fixes: 3fc24ef32d3b ("arm64: compat: Implement misalignment fixups for multiword loads")
Cc: <stable@vger.kernel.org> # 6.1.x
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250401085150.148313-1-angelos@igalia.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/compat_alignment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/compat_alignment.c b/arch/arm64/kernel/compat_alignment.c
index deff21bfa680..b68e1d328d4c 100644
--- a/arch/arm64/kernel/compat_alignment.c
+++ b/arch/arm64/kernel/compat_alignment.c
@@ -368,6 +368,8 @@ int do_compat_alignment_fixup(unsigned long addr, struct pt_regs *regs)
 		return 1;
 	}
 
+	if (!handler)
+		return 1;
 	type = handler(addr, instr, regs);
 
 	if (type == TYPE_ERROR || type == TYPE_FAULT)
-- 
2.49.0




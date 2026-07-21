Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC3942A7B4;
	Tue, 21 Jul 2026 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665706; cv=none; b=JzrXIxLh3rQwYnbhGg7e3iLM2xMzx41DR3cjHHzfMZSMPRjeq9sMogtlkC2VkXwaKwlebNGXkvgzykQI6+A32o8/Vq3tGXikOTOUYq/RzzoLMzJuTF7K7xydDWHd2fHlVb/LNnf4a5jrIaER1ITe9uZXx1R61IkPJywqyVjj6tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665706; c=relaxed/simple;
	bh=9afyVMxHX9Gnj2Nrve4lfXYksicDX345pF03epjqtjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeRwZn/F9X40ZFp8v+WOpku05R7aC7AvQkK9Ues7KhC/IgoWhNbLtAyCUuYZ4CbzHKCViRq/fPTOMeHEin4k2/bfMm0bwYPD+EaUAGWksMys9oZgjB4PrmgQMnpXGXUhPXxga1QRNGUwrrMdiywnpr58jyRBog9Nm6XNSbOQtAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGaZ4NAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGaZ4NAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDBD1F000E9;
	Tue, 21 Jul 2026 20:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665700;
	bh=2wBJVY97sDhoBOht0dq3Kkrlx8VVKby5Hk5exbo6Ggk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGaZ4NAlW7ab7eyUCNz1GthY1AZ+Z9KbqyNcprPnm6K+5iby5iW3JuTej9yfEsMMa
	 tBf6KphZVR2rEA079x9Y79noyNcqStDKM3zLCfUxa10f4Ha7biKqTPZhi4E8lzZ7m4
	 cOTvFsllAAPO8RPX+liqjW3TS0v9sDcPo1aGLaH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0402/1266] crypto: ccp - Treat zero-length cert chain as query for blob lengths
Date: Tue, 21 Jul 2026 17:13:59 +0200
Message-ID: <20260721152450.826976238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ef8c9dacda2871accd64e3eda951fef6b788b1ea ]

When handling a PDH export, treat a zero-length userspace cert chain buffer
as a request to query the length of the relevant blobs.  Failure to account
for the zero-length buffer trips a BUG_ON() when running with
CONFIG_DEBUG_VIRTUAL=y due to trying to get the physical address of the
ZERO_SIZE_PTR (returned by kzalloc() on the bogus allocation).

   kernel BUG at arch/x86/mm/physaddr.c:28 !
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 30 UID: 0 PID: 28580 Comm: syz.2.18 Kdump: loaded
  Tainted: G        W           6.18.16-smp-DEV #1 NONE
  Tainted: [W]=WARN
  Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.62.0-0 11/19/2025
   RIP: 0010:__phys_addr+0x16a/0x180 arch/x86/mm/physaddr.c:28
  RSP: 0018:ffffc9008329fc80 EFLAGS: 00010293
  RAX: ffffffff8179110a RBX: 0000778000000010 RCX: ffff8884e6992600
  RDX: 0000000000000000 RSI: 0000000080000010 RDI: 0000778000000010
  RBP: ffffc9008329fdf0 R08: 0000000000000dc0 R09: 00000000ffffffff
  R10: dffffc0000000000 R11: fffffbfff126d297 R12: dffffc0000000000
  R13: 1ffff92010653fc8 R14: 0000000080000010 R15: dffffc0000000000
  FS:  0000555556bec9c0(0000) GS:ffff88aa4ce1c000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fd3159e7000 CR3: 00000004fbc44000 CR4: 0000000000350ef0
  Call Trace:
   <TASK>
    [<ffffffff853d3869>] sev_ioctl_do_pdh_export+0x559/0x7a0 drivers/crypto/ccp/sev-dev.c:2308
    [<ffffffff853d1fdd>] sev_ioctl+0x2cd/0x480 drivers/crypto/ccp/sev-dev.c:2556
    [<ffffffff82549ebc>] vfs_ioctl fs/ioctl.c:52 [inline]
    [<ffffffff82549ebc>] __do_sys_ioctl fs/ioctl.c:598 [inline]
    [<ffffffff82549ebc>] __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
    [<ffffffff8630115f>] do_syscall_x64 arch/x86/entry/syscall_64.c:64 [inline]
    [<ffffffff8630115f>] do_syscall_64+0x9f/0xf40 arch/x86/entry/syscall_64.c:98
   [<ffffffff81000136>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7fd3158eac39
   </TASK>

Thankfully, the bug is benign outside of CONFIG_DEBUG_VIRTUAL=y as getting
the physical address is just arithmetic, and the PSP errors out before
trying to write to the garbage address (which it must, otherwise querying
the blob lengths would clobber memory at pfn=0).

Fixes: 76a2b524a4b1 ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9844ac4f9b86bd..1735729123397a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1016,7 +1016,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	/* Userspace wants to query the certificate length. */
 	if (!input.pdh_cert_address ||
 	    !input.pdh_cert_len ||
-	    !input.cert_chain_address)
+	    !input.cert_chain_address ||
+	    !input.cert_chain_len)
 		goto cmd;
 
 	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
-- 
2.53.0




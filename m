Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7FF253B5C;
	Mon, 22 Sep 2025 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570349; cv=none; b=eUAdNRh5m1rKOH7D7LelEEw9bLw0xcIyO2LtOL1YHFJrG5JYNt6UOGfzakG9IXH8NSE4YCFjOwDOHvCuFl3GU+i1ayS17ZOYr0XjQkoxuESj6eAiRveOsIiSnEk1IdnJ0dt7cwdDmaaf6BQErvsDIl0XPnPZrrlizRcCSs8urhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570349; c=relaxed/simple;
	bh=jQxeocFp3uza2bLTH08KI/WTaJORP6olchx7SOWZP3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQYLxIDhVj+9IJzQEnrqZsSdwDtMj7ottyTrRb7RfcgKUNr1RzZtagOEcvWsvKXNIbXT1wGN3DRu5Dnfzu3BSzaEE9rtcwt95stzoAruATFzWW7XO+4EOgpsquck9S+4ZwrBR74BRkh5/mfExxLQum5R93AeaPWJ+Bg48PIPOtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uNMWuZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uNMWuZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C4EC4CEF0;
	Mon, 22 Sep 2025 19:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570349;
	bh=jQxeocFp3uza2bLTH08KI/WTaJORP6olchx7SOWZP3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uNMWuZMecafWBqYeUbtyIz+ig0KZzyvHXJMobRyCLQVRok1ACm9079jq+Tn91sYs
	 xiunNiqoko1jgDoL1QohXDsez2mFp+qn/TwTYfybeCuAaqTb5fBtoJ/Y8roiwX+VUk
	 3aplh5Nvqgwa9ecaLWQQN9z3L2NgNVBQehidVXjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 102/149] crypto: ccp - Always pass in an error pointer to __sev_platform_shutdown_locked()
Date: Mon, 22 Sep 2025 21:30:02 +0200
Message-ID: <20250922192415.459181420@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 46834d90a9a13549264b9581067d8f746b4b36cc upstream.

When

  9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")

moved the error messages dumping so that they don't need to be issued by
the callers, it missed the case where __sev_firmware_shutdown() calls
__sev_platform_shutdown_locked() with a NULL argument which leads to
a NULL ptr deref on the shutdown path, during suspend to disk:

  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 983 Comm: hib.sh Not tainted 6.17.0-rc4+ #1 PREEMPT(voluntary)
  Hardware name: Supermicro Super Server/H12SSL-i, BIOS 2.5 09/08/2022
  RIP: 0010:__sev_platform_shutdown_locked.cold+0x0/0x21 [ccp]

That rIP is:

  00000000000006fd <__sev_platform_shutdown_locked.cold>:
   6fd:   8b 13                   mov    (%rbx),%edx
   6ff:   48 8b 7d 00             mov    0x0(%rbp),%rdi
   703:   89 c1                   mov    %eax,%ecx

  Code: 74 05 31 ff 41 89 3f 49 8b 3e 89 ea 48 c7 c6 a0 8e 54 a0 41 bf 92 ff ff ff e8 e5 2e 09 e1 c6 05 2a d4 38 00 01 e9 26 af ff ff <8b> 13 48 8b 7d 00 89 c1 48 c7 c6 18 90 54 a0 89 44 24 04 e8 c1 2e
  RSP: 0018:ffffc90005467d00 EFLAGS: 00010282
  RAX: 00000000ffffff92 RBX: 0000000000000000 RCX: 0000000000000000
  			     ^^^^^^^^^^^^^^^^
and %rbx is nice and clean.

  Call Trace:
   <TASK>
   __sev_firmware_shutdown.isra.0
   sev_dev_destroy
   psp_dev_destroy
   sp_destroy
   pci_device_shutdown
   device_shutdown
   kernel_power_off
   hibernate.cold
   state_store
   kernfs_fop_write_iter
   vfs_write
   ksys_write
   do_syscall_64
   entry_SYSCALL_64_after_hwframe

Pass in a pointer to the function-local error var in the caller.

With that addressed, suspending the ccp shows the error properly at
least:

  ccp 0000:47:00.1: sev command 0x2 timed out, disabling PSP
  ccp 0000:47:00.1: SEV: failed to SHUTDOWN error 0x0, rc -110
  SEV-SNP: Leaking PFN range 0x146800-0x146a00
  SEV-SNP: PFN 0x146800 unassigned, dumping non-zero entries in 2M PFN region: [0x146800 - 0x146a00]
  ...
  ccp 0000:47:00.1: SEV-SNP firmware shutdown failed, rc -16, error 0x0
  ACPI: PM: Preparing to enter system sleep state S5
  kvm: exiting hardware virtualization
  reboot: Power down

Btw, this driver is crying to be cleaned up to pass in a proper I/O
struct which can be used to store information between the different
functions, otherwise stuff like that will happen in the future again.

Fixes: 9770b428b1a2 ("crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e058ba027792..9f5ccc1720cb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2430,7 +2430,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 {
 	int error;
 
-	__sev_platform_shutdown_locked(NULL);
+	__sev_platform_shutdown_locked(&error);
 
 	if (sev_es_tmr) {
 		/*
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED46D3AE6EE;
	Mon, 23 Mar 2026 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275077; cv=none; b=UAcz3iD8brMFZ/Z76TPsth7mU3FfNgJdWalJbFxKb558SvI1LqwGg/zWwrWvOkQwzIm33449CGS3HnMNXzgtYQwGdBTz965ZzO+GXMdOB1WAJC7F+MS2SKhpwTahJwb51F68zk0xl1jHAknV9aUX+1vBhqJis/DklpkWrbvePpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275077; c=relaxed/simple;
	bh=0dzu53iFUkaEb09cIxFDQqj+M5YOwxhFL+Q0oHOYN/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbzXSItXOQAxU+WXjknOO2vfuVIbOgnv+TWtVQovb17Ug9xLxhdbNRcPy7hNrMBaD7ldM8E054cdNQUHsIcCSwBHCtJybh5j1C1MYWFOjXoUJg6Kx4AGcPEo0z8RG+f8Iy/F4khQN1DfKki1lxzqD3sZEX7ShwiNzO9LwUr31gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ky87a+UA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ky87a+UA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70732C4CEF7;
	Mon, 23 Mar 2026 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275076;
	bh=0dzu53iFUkaEb09cIxFDQqj+M5YOwxhFL+Q0oHOYN/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ky87a+UA5AQoksLJsmAuhrOuVKGusCPoe6afuOkHIGQPeLsVKY2vZBP7NBxaRDMfg
	 jbZ8gZg8AkogMUnnxoqDRT4wuZp6b3y2436Ac3BhPKpx0n+Au3lNsA2AHpV4Y/izl+
	 V405EHVXZTUgXOa4yIrEJXQj105r0Ux59bCeNjU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/212] arm64: realm: Fix PTE_NS_SHARED for 52bit PA support
Date: Mon, 23 Mar 2026 14:47:12 +0100
Message-ID: <20260323134510.452735844@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 8c6e9b60f5c7985a9fe41320556a92d7a33451df ]

With LPA/LPA2, the top bits of the PFN (Bits[51:48]) end up in the lower bits
of the PTE. So, simply creating a mask of the "top IPA bit" doesn't work well
for these configurations to set the "top" bit at the output of Stage1
translation.

Fix this by using the __phys_to_pte_val() to do the right thing for all
configurations.

Tested using, kvmtool, placing the memory at a higher address (-m <size>@<Addr>).

 e.g:
 # lkvm run --realm -c 4 -m 512M@@128T -k Image --console serial

 sh-5.0# dmesg | grep "LPA2\|RSI"
[    0.000000] RME: Using RSI version 1.0
[    0.000000] CPU features: detected: 52-bit Virtual Addressing (LPA2)
[    0.777354] CPU features: detected: 52-bit Virtual Addressing for KVM (LPA2)

Fixes: 399306954996 ("arm64: realm: Query IPA size from the RMM")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/rsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index c64a06f58c0bc..9e846ce4ef9ca 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -12,6 +12,7 @@
 
 #include <asm/io.h>
 #include <asm/mem_encrypt.h>
+#include <asm/pgtable.h>
 #include <asm/rsi.h>
 
 static struct realm_config config;
@@ -146,7 +147,7 @@ void __init arm64_rsi_init(void)
 		return;
 	if (WARN_ON(rsi_get_realm_config(&config)))
 		return;
-	prot_ns_shared = BIT(config.ipa_bits - 1);
+	prot_ns_shared = __phys_to_pte_val(BIT(config.ipa_bits - 1));
 
 	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
 		return;
-- 
2.51.0




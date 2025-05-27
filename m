Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5BB1D88D7;
	Tue, 27 May 2025 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366619; cv=none; b=J1c6OXYRX/SsROTTNmUVfJouESFmXPmGqM5N2qVHP/ISVlFq+OxjHCiT40Ulu/t0EB0xJj0bpGG2YQcZFn+rKzq6rQda0BfMo1QIM7VRv+eisXXjjsIvArsNBzPxjKKNfccQhXgEPKZj5/ZwyUHpCvO0f2B3+Di+fZLyXBTP/+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366619; c=relaxed/simple;
	bh=GpDTX4KkogO3LGiT/Ny6Lp/HN6/1kqGquiKz25WVpWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh3tXlMyn2PnA6fadYmi7QJCrt00ipcLFQWQGFd9Y4i8Mu0hrgL6gDtdix/5h2eNT9aQdjizzZiZohIFdS1YGVGy2ZUs2cY/E2mUuxbhP7sruMnphkjf0/5PCeFZIN2vywQ0KxAwyKttnQ+dFT2WNdDW9j+rB2yuOYoKWPhk3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dpeg2F6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dpeg2F6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9861EC4CEE9;
	Tue, 27 May 2025 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366619;
	bh=GpDTX4KkogO3LGiT/Ny6Lp/HN6/1kqGquiKz25WVpWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dpeg2F6A7zi0F4vfynY+koesBrGl6b3KXYASTD3BakjvgPFkNfPeDF7Z6mRS6QNLn
	 B6PAHJCN+e7YwHk2VC+FhVwohVrm+47xo9D8IcaHoQTOOR7TjlCpLZURsRrQ6Qxcgz
	 HVAcUaEKX+v/AuPbPiPLu6wqHln7ZJpaVAoWg/WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohil Mehta <sohil.mehta@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 127/783] x86/smpboot: Fix INIT delay assignment for extended Intel Families
Date: Tue, 27 May 2025 18:18:44 +0200
Message-ID: <20250527162518.324500060@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sohil Mehta <sohil.mehta@intel.com>

[ Upstream commit 7a2ad752746bfb13e89a83984ecc52a48bae4969 ]

Some old crusty CPUs need an extra delay that slows down booting. See
the comment above 'init_udelay' for details. Newer CPUs don't need the
delay.

Right now, for Intel, Family 6 and only Family 6 skips the delay. That
leaves out both the Family 15 (Pentium 4s) and brand new Family 18/19
models.

The omission of Family 15 (Pentium 4s) seems like an oversight and 18/19
do not need the delay.

Skip the delay on all Intel processors Family 6 and beyond.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250219184133.816753-11-sohil.mehta@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smpboot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c10850ae6f094..3d5069ee297bf 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -676,9 +676,9 @@ static void __init smp_quirk_init_udelay(void)
 		return;
 
 	/* if modern processor, use no delay */
-	if (((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) && (boot_cpu_data.x86 == 6)) ||
-	    ((boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) && (boot_cpu_data.x86 >= 0x18)) ||
-	    ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && (boot_cpu_data.x86 >= 0xF))) {
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL && boot_cpu_data.x86_vfm >= INTEL_PENTIUM_PRO) ||
+	    (boot_cpu_data.x86_vendor == X86_VENDOR_HYGON && boot_cpu_data.x86 >= 0x18) ||
+	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD   && boot_cpu_data.x86 >= 0xF)) {
 		init_udelay = 0;
 		return;
 	}
-- 
2.39.5




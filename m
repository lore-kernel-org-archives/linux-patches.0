Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926CE37F8C2;
	Wed,  8 Apr 2026 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671804; cv=none; b=Zky18DLIq8X6E5yUEVdhT18rtr7xa/6q0d+U0hvTsvEGRTtaMnUMp6uj7zHVebXTFlR2XefEFdYYrhcRAM3h3S6vRDzRKS21eAPXCfrDZKL/ZOLjZZ4W0PxWtlpWAGvVmUp6o0VCrWHYA5+eXoCJY/+uLoiAhXHMdtjNfQRcGN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671804; c=relaxed/simple;
	bh=F/4GIma4RhjSGZecvlQGQeN6AYotqgisTOY54x+lyJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIQ4zGHRubaYWQn+NVXT3a1jRvnJSqM6iBy+EgWv3U+sJBDsIKnoCTCxnIcXgQ7Ia5m7kg1di/SB+ChCBDVvbz3t+gTtND+TIalbj3sCAkzuudJo7Lq5dPKASXy3I5scIWXSdLtAAohvpCeQr15feVlLDVH6NMNo5vpjWtNQIas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1u1UyjCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1u1UyjCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B7AC19421;
	Wed,  8 Apr 2026 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671804;
	bh=F/4GIma4RhjSGZecvlQGQeN6AYotqgisTOY54x+lyJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1u1UyjCE9IKs4kX6M7p/OPoTjf9jzICZpRCIvig6JgexIge4KekNMJss2buGLbCjt
	 2hS2TeYagWnb9cqrj9kYY9dOK+4PUDbXoFF8GygetCJAQuYMacHgl9MEZeLX+Kxl0E
	 SUYtmQ7T00lCEuDNYvGTIRq0VW1vGAl2zlDjv7f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/312] x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size
Date: Wed,  8 Apr 2026 19:59:51 +0200
Message-ID: <20260408175936.506460858@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb ]

ranges_to_free array should have enough room to store the entire EFI
memmap plus an extra element for NULL entry.
The calculation of this array size wrongly adds 1 to the overall size
instead of adding 1 to the number of elements.

Add parentheses to properly size the array.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/efi/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index e3b00f05a2532..b0d0376940ba8 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -416,7 +416,7 @@ void __init efi_unmap_boot_services(void)
 	if (efi_enabled(EFI_DBG))
 		return;
 
-	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
+	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
 	ranges_to_free = kzalloc(sz, GFP_KERNEL);
 	if (!ranges_to_free) {
 		pr_err("Failed to allocate storage for freeable EFI regions\n");
-- 
2.53.0




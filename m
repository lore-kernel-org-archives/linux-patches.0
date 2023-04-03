Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F336FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C34C433EF;
	Mon,  3 Apr 2023 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532557;
	bh=M82enYK/u3Lq+IAhCORnNPaErd0b2l+VW4A9UX58ASQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZg1+FNXCBzJ2YdpK4kSKP/RSUdNaL9usU/8r7O/uLJguI3MeWqmtcA14BnJOrzlY
	 9G6d2dBve//XKYckWdPIni5rQLmuVnLdGEg0xs2rPW7GjANDSppqvGJG3rAmGDRq5I
	 mRzcUTL3cyTnk11QrB0FNjc5tmiFjZP5FApOixk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/181] arm64: efi: Set NX compat flag in PE/COFF header
Date: Mon,  3 Apr 2023 16:07:44 +0200
Message-Id: <20230403140416.123277378@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 3c66bb1918c262dd52fb4221a8d372619c5da70a ]

The PE/COFF header has a NX compat flag which informs the firmware that
the application does not rely on memory regions being mapped with both
executable and writable permissions at the same time.

This is typically used by the firmware to decide whether it can set the
NX attribute on all allocations it returns, but going forward, it may be
used to enforce a policy that only permits applications with the NX flag
set to be loaded to begin wiht in some configurations, e.g., when Secure
Boot is in effect.

Even though the arm64 version of the EFI stub may relocate the kernel
before executing it, it always did so after disabling the MMU, and so we
were always in line with what the NX compat flag conveys, we just never
bothered to set it.

So let's set the flag now.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/efi-header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 28d8a5dca5f12..d731b4655df8e 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -66,7 +66,7 @@
 	.long	.Lefi_header_end - .L_head		// SizeOfHeaders
 	.long	0					// CheckSum
 	.short	IMAGE_SUBSYSTEM_EFI_APPLICATION		// Subsystem
-	.short	0					// DllCharacteristics
+	.short	IMAGE_DLL_CHARACTERISTICS_NX_COMPAT	// DllCharacteristics
 	.quad	0					// SizeOfStackReserve
 	.quad	0					// SizeOfStackCommit
 	.quad	0					// SizeOfHeapReserve
-- 
2.39.2




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063274;
	b=ItUzwzGxQOBw73Wl4cNg7HZb8tFm6OlfOBPKYDdgn4Gr/0/R90HsHNNmmKYV4z1eqa5d
	 zvn9QjJ0Hv403ew7KqXbyKaIn28gTXwgUIJvWbd5KWksWvVKDfI4rTlcwWqHk/0boeT1x
	 V52LPhNxXN29xHWxsdkjwzxvsg5HjrMgDviAsy/PHCe50AFRelryQbYp6rVpqdriutDQp
	 ggB+9wxcY2X24n52w1snlqdOD8g9MKXY+BdxyJeT3A45YRl6TDNpkqOWB/P+Jd1w8jaBD
	 JK7CmecXPAQyfVCv5+9+9C4ObugzQhjf1CM3QDVJFvym0NwAUToGEmf/tHfqtPs4AaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bIkqdFxQQV/odUxUvVsPnYTnqi5nYmStDO+TkBGEzrM=;
	b=Y8XuFDzzb6t1OqmVLTuHMQ4lRCme7W08HvpNxqCBNzEDoPEoxI5iL+9/KvLR0zh2ByXL
	 xFKz2JW/CCOg/AN/nY8czER5V5zfsnD4pZeOn74kbI5t2uq3HNSu471pcXGO63Ye9Q3WA
	 fZO2M2wip12AvA6rPO//WX/3h7r3x2VAsclxiuuCQQ7Bs9B5AW3vYd58KlfyL2xYcReSD
	 jpk9ALLelGmrpy0yY7lxk7I8WAlWywGUYSH7ezWBF1AYQ7ts4CJFnZwkL1HvNDmHovkbu
	 i3z3alweJlA95NYS6jhjBI3NHqUaVPdD9j7FmipLcT0XWdHeJpVDc7uYuSIVCeRbYAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0KYjkfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9DF606D80B;
	Sat,  7 Nov 2026 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0KYjkfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2F51F0089F;
	Sat,  7 Nov 2026 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063274;
	bh=bIkqdFxQQV/odUxUvVsPnYTnqi5nYmStDO+TkBGEzrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0KYjkfdKDj2hwGhdktHqUm4p9h4InpBphSpyuPXbC40lUyq7op6Onats0y3O1k8K
	 d4uJ8+kdkcnTASg7w3mhYFlz7/RXTmsjpIewNjdcmaqvfupeIASDGEfH9aIBu00+VV
	 EpYD5k0xkO85pfVys6UNF6Pjd83XUMCDW9mseMck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 470/869] arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO
Date: Sat,  7 Nov 2026 08:52:32 -0500
Message-ID: <20261107134909.569316190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 215d7b6622733603751f546b9faf9b84b0c281d4 ]

set_permissions() sets PTE_RDONLY for regions that the Memory Attributes
Table describes as read-only, but leaves PTE_WRITE set.  PTE_WRITE is
the DBM bit, so when hardware dirty state management is enabled
(TCR_EL1.HD), such a descriptor is writable-clean rather than read-only,
and a write by the firmware will be permitted by the hardware (which
marks the entry dirty) instead of faulting.

Clear PTE_WRITE as well, as pte_wrprotect() does.

Cc: stable@vger.kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/efi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 6c371b158b99f..a3c0d5c2e9f74 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -116,8 +116,14 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 	const efi_memory_desc_t *md = spd->md;
 	pte_t pte = __ptep_get(ptep);
 
+	/*
+	 * Clear PTE_WRITE as well: it doubles as the DBM bit, and leaving it
+	 * set would permit the hardware to make the mapping writable again
+	 * when TCR_EL1.HD is set.
+	 */
 	if (md->attribute & EFI_MEMORY_RO)
-		pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
+		pte = set_pte_bit(clear_pte_bit(pte, __pgprot(PTE_WRITE)),
+				  __pgprot(PTE_RDONLY));
 	if (md->attribute & EFI_MEMORY_XP)
 		pte = set_pte_bit(pte, __pgprot(PTE_PXN));
 	else if (system_supports_bti_kernel() && spd->has_bti)
-- 
2.53.0




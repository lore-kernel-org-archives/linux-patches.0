Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038052;
	b=ewBYH6W9RNZ/+nM1yRymK/uvKc//4uy4UvdIL+I/L2W3dVurvn5/hSbC3kNThxN1KHQ/
	 rU2PA41HhPR9L3y9eDKMykO8PwYQPwi6Fc8BImPoVbH+ngOtrDHI+YrQ5LhF9sNyh0woX
	 s6epjR6LDAxP7Vn5RGXIoCz3P3Z6dNagYhC2R9HZnPjpBpemABLTP57OXnCp3q8xrQ76Z
	 sLWpqjtJV6tCxVil9oSETN3IdSzmGKydHfsPGlJMx6Oy7soZ7ooqc2u4FiolVhE9W3VRx
	 Nr67JHEejtmDU2SzM/COtGAxmCjqpja8kfuV/IvKfvrtjlyf+UdsSwiJdgabCd7YEbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZJtOjLCdIXyfNt2H1On6gQI/UuvdXnliTajzaFgFlZY=;
	b=KaayoAoziwbc2muuf+acbVX5wez1P0P0M4a/TDx6cZ14DIYEE6CAgyj4mlB78tz0kw1J
	 GMTNEBEtDKQNYgG9b0aBAn4LykriVKgjIo9UELqvhgWTu/IDxPkdBAicGTzUmPib3WSE2
	 mHtrmeI8VuG2Y5oA4pqd+ONeui2adIqwnRXTTCOxDBNYiv1XoXyRpPOlHTbzp97x75ewU
	 RBtVinEJ7lTgNK0MI+7J1z4GplO2CKzMFFPityB9Qrz7vUAGUB3B9foSPy5sNceUq0JgU
	 /YOvWkMgsHY3YtJq9WbKKDkAT+S/hY79MCM+i6i9f4WA5r745BYnqXO+tY3SPXldlkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osH0p8MI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035A9606A32C;
	Wed, 18 Nov 2026 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osH0p8MI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567CA1F000C5;
	Wed, 18 Nov 2026 21:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038051;
	bh=ZJtOjLCdIXyfNt2H1On6gQI/UuvdXnliTajzaFgFlZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osH0p8MI9eOmA3betu3iUG3SEti+8J67A7Ei/w42FBvgkP4w4oixXfcLYvyyAlvqi
	 RBShwjDXCRBZ9et6v+hb6CwsMONWMhjvybikWiT1rj0to0hEqINRQERtW9licVFryy
	 P+X6o346BuwDSDZYQ7tnRirX3hPWfpbDGIzUFFuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1566/3318] x86/boot: Fix off-by-one error in sme_clear_pgd()
Date: Wed, 18 Nov 2026 15:36:28 +0100
Message-ID: <20261118150408.019104608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit cb319926808b1cca522d2087a13205e840beb45b ]

The mapping helpers __sme_map_range_pmd() and __sme_map_range_pte(), and
therefore sme_encrypt_kernel(), use exclusive end addresses and stop
before vaddr reaches vaddr_end.

However, sme_clear_pgd() treats vaddr_end as inclusive when calculating
the last PGD entry to clear. If vaddr_end is PGD-aligned, the first PGD
entry outside the range is cleared too.

Use vaddr_end - 1 to calculate the last PGD entry within the range.

Fixes: 6ebcb060713f ("x86/mm: Add support to encrypt the kernel in-place")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260918142714.242711-2-blum@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/mem_encrypt_identity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index b922b9fea6b64..1bbc117f91ab9 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -101,7 +101,7 @@ static void __head sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 	pgd_t *pgd_p;
 
 	pgd_start = ppd->vaddr & PGDIR_MASK;
-	pgd_end = ppd->vaddr_end & PGDIR_MASK;
+	pgd_end = (ppd->vaddr_end - 1) & PGDIR_MASK;
 
 	pgd_size = (((pgd_end - pgd_start) / PGDIR_SIZE) + 1) * sizeof(pgd_t);
 
-- 
2.53.0




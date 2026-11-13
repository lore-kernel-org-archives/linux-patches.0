Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591269;
	b=5Lzx8lHYkRj157ROkZWuuAn7vMw641s/fbf9eTjoh6z0w3MtKKdZLMEnfMSDUseRjieg
	 5KV4/Rv2wQcAp1q7xreKzVroA3TjD4BTBfwg/QzGDjUYuLfsoqj2xvTcbuNqBJh333C8X
	 L1AIb3zCyTp2su+Xi/GPx7vOOKcy9KctVYFzKg3vpcYDgikiITI/3gPXQ8fFJT/S+nJvd
	 d9YMP6j0Q+HB+oXSbBpjR/RZVzDmulcxH8YjImZRiIVJlyZBIUKnyrhNpTHvSkma7huwM
	 tOzayo3WtVSnVFTavAr7lv4UiFKN43IZsEyjfHNhW3soG02S2K7goW1FlXYKbJCn+KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hlIkOnQykw/VowkmWGxrsy6wTm+0JH8NiTGd3fNRyz4=;
	b=5iTwyC80Umpl5+8OcbrhSyahQJGwZCFph3hjfqySZnYjSCPAnp3FQZKc07k+oPnTGjjx
	 qzH2Qqra6Yiv3AFWZq3Mxr8zR1vKaLyVjdDKGMuffeNOodQimoyjlBk2KtMPpz+vAbK/y
	 Ns7bLyWb89/LdypjUo+HqGgpUKHMH76cQOohXVkVAQwms3qzMiWJHCcwIGA08UtLACRhp
	 UctWCBQRXE13mUbBzyIKHDlp7jbioVqfvlxwH4lyFFRwxpXAJXIp+5QCBSeCI+d+DjFNn
	 uVgS9NCTkEHRcetf69MYaEixCqVEzfVPpwY1hep3OBm3CXfXdX5yoRv0shHLchrjPTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOVHpKkj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE1A6076F93;
	Fri, 13 Nov 2026 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOVHpKkj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4351F000C4;
	Fri, 13 Nov 2026 17:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591269;
	bh=hlIkOnQykw/VowkmWGxrsy6wTm+0JH8NiTGd3fNRyz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOVHpKkjkL8Y+YLJrFh6Q1dMg1v+ucPsBQ8jG/IKva6qVDqm7fcrIUa9OGoQH3IUP
	 eBLqC4ItUqeMt/X386GqRKsY4zvLrdYHr2JvJZgEkyFrZ3vC539qPJ4dv8mgJoujiQ
	 IkXzLMoKWUdBJb0r5LZHd9qu90sMcj1RYQQVcs24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/670] x86/boot: Fix off-by-one error in sme_clear_pgd()
Date: Fri, 13 Nov 2026 10:49:16 -0500
Message-ID: <20261113153825.038034049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




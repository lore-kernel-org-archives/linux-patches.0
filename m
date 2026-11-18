Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046542;
	b=U4t6Z9ApZ6fUigK2s62BMlbmrwGsE0r4rZSJgkNneczoT9INznwBQ9NIb36gFDm6rSpY
	 Rxb+HzXZGA6zI0TATKSRC+/VBpLKKIiAXZxbKi6U8hg1eAOqmrfO0Yz74zGAKaYgSQzpI
	 4pPLptBIoYB32onVeF72hsLaW4xRnkEr20xFp0defAhxsrQlyRKm58Slh9TScTgphad2b
	 wy0B4ymRWJvKxbyc1EZ+S6sxLGO7kihFk4Z36u/1Y6okLpVHkBBeU5I16Xtr/O7kPkCQm
	 eaO7W+7H8yHl+J1AuB75dCNABNmlsGPYg931nsWkpCFjuI13T8lfr4b1jf/UuLpDa0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eoBt879m3I81WwGbANVO/z9W35SUJmQyqPgcFGCPcVI=;
	b=bHdlCLYoDYYVVEUxPcum+JaDDkIK8eqDmz7j98MkOYOv/HjrendMR4QVvP56hDcipDst
	 bnYAs2XGVy5w1PMDN7n9ZyHVvVBY64nwFIEQa5KE6ZVpUe1SwLrFJS3xVST9oSRDaGEsB
	 H114xUbbmecsXbr24d9YmMdo+cfCPWiaghLgMhauUY6vJ8rhahnl6Eb44fCIUba77dCxi
	 TyyYTRWEHeCQlKHn+fknURuOAt6E1Xo3W/sGnhf+iZzR5XNS5/09n+TGpO3N8H4Sv8Zj+
	 1Wd7GYoxh08rScj4Ilz/H7eX1/svaCz4FwsPy7hSfIKzctzdU0FNu1fGI4TdJ+tqQfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p/IVtyUe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562ED606A334;
	Thu, 19 Nov 2026 00:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p/IVtyUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0C51F000C4;
	Thu, 19 Nov 2026 00:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046541;
	bh=eoBt879m3I81WwGbANVO/z9W35SUJmQyqPgcFGCPcVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/IVtyUeOJNJf0h2YuWQVi5Cia6nwm7d0dQoR/Bntg2izGWsnqeE9wW/chEf1VQug
	 HpZEDDbu93vjJpX8HlNv4PeoYmzr7iAQo3iSr6OQSa+w9zM3S6iozHj/dqeSYUvLkQ
	 K9LmlFPHrNIGkf6NFk+MKxe2jthdO5DKXUxz0grY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1318/2857] x86/boot: Fix off-by-one error in sme_clear_pgd()
Date: Wed, 18 Nov 2026 15:39:12 +0100
Message-ID: <20261118150248.904500436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 839d8a4a1cd08..7642b2c9ace17 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -105,7 +105,7 @@ static void __head sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 	pgd_t *pgd_p;
 
 	pgd_start = ppd->vaddr & PGDIR_MASK;
-	pgd_end = ppd->vaddr_end & PGDIR_MASK;
+	pgd_end = (ppd->vaddr_end - 1) & PGDIR_MASK;
 
 	pgd_size = (((pgd_end - pgd_start) / PGDIR_SIZE) + 1) * sizeof(pgd_t);
 
-- 
2.53.0




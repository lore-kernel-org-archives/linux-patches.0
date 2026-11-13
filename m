Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590545;
	b=i8pZsNy57+VnsvNb6+lXtsP3caeDb4QA/lbeCm3o4doqjuloBB10lyqoDrDdWUNykfQZ
	 LvMS1yZQ2OOanp7H0z1CTX8nPHkqYh7dCZr7nnfUKgvDecANl7Cn3vr9L/iPh4EP6OVS1
	 X11jUteai6wH3pWfY9/8eEsYVGcHwPq6OxbCBKYydma1sqrWN3LWwrXBF6kZzMhzOOjgn
	 A95DEaC0yAPv3k7KOxYJPmAmq5pLQNiOJUy1CKyThp5+Gi0A7W1bhVRVoQ2jPobaQ9ur+
	 MbUZUzEhZT8+VxL6I6tQignetQrw8qCH/oCfYmpi8sB4F08JtW21gTZIf6678KELl/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IGiv1H619qDoN7gpLSalnQjkNfy8rums+IoXazyzj08=;
	b=YlNIY7PH88Kxoo4Kp3WBWAH8N8TlQKv67H0Oloz65HtjOJ5JJsoafaF5pRY7WR6O7eJQ
	 JD85RRG98IYYXQjt1Oz2xRIAxIqvvG68G2NQkJtNiiRZqn8ITG4+yOUChHGez0Fj5oBEg
	 Ok4pR6tkbtSn6Z9adT4eBtY2Gv5JCavLhwviciotsMb4AYEKnt60Fmm4UFMmMBTBXEEXB
	 HqPVp7lfu7LwmZs6lkBZztM0vWiQybsoJEB28sROzvpNBCHvGb05WKgKnTx27fcUvcHOu
	 NJ5mYP03vChqUW8GWujoC6pTyfCErz34Z0pIq3+5MA+HtvgZOgppHsrkHPL7n73tNtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f+cD/i6N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F3C606B355;
	Fri, 13 Nov 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f+cD/i6N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929AF1F000C6;
	Fri, 13 Nov 2026 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590544;
	bh=IGiv1H619qDoN7gpLSalnQjkNfy8rums+IoXazyzj08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+cD/i6NnMba4NpiArOIZq3/pl9z/YMzWOzRXS71XzZe5TIwHGt7cnvec23V9Q+2s
	 YVqzYo8XrJai9gTWlLFraRaZnhcsVRVNx/cNLG5HHceZogJoazmuPGa7cf73q/LSgi
	 VpRqxDnhduDcisxkkDiHTJLzNKpQ9I7ioqVY2JDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/686] x86/boot: Fix off-by-one error in sme_clear_pgd()
Date: Fri, 13 Nov 2026 10:49:50 -0500
Message-ID: <20261113153836.355229506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
 arch/x86/boot/startup/sme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
index e7ea65f3f1d6a..1528199e3a3ff 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -97,7 +97,7 @@ static void __init sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 	pgd_t *pgd_p;
 
 	pgd_start = ppd->vaddr & PGDIR_MASK;
-	pgd_end = ppd->vaddr_end & PGDIR_MASK;
+	pgd_end = (ppd->vaddr_end - 1) & PGDIR_MASK;
 
 	pgd_size = (((pgd_end - pgd_start) / PGDIR_SIZE) + 1) * sizeof(pgd_t);
 
-- 
2.53.0




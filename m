Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585851;
	b=G1uRpIjrt1hP284iAih1H96LfHjktx4ZnTqdqGCCg107AAb7PGTbyvXRiuo3ADkDhQ/x
	 oIgWAovQDwSMTCEuG4FhP4b0KCGxzNfuqanQzuN9gihHmXTVbo8Mrcih2pdRNvK+KIlVS
	 ujyCjhdhMBY7jHa8Y5We3WRyBvUxgHDMbwQM95CGcsZ6z2cjl+ZlJABS8M8SkMZwJQ2hQ
	 jEJEmjxZuaPrVF6yayaIii18wajcySzeVSbeTMjKcRgphhgIgMgzwJqz1Fm4JoRU4EuKk
	 jt9rg2Kqofg7fUjUeG8Bn6QjRzZF62lXPvIE+of4Gx7/ATC594uAjRWLp+7iIUmMoaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TkXeQyQKdFb8XsWL1p4EMXM6AUCCCcLtkyQYLhp8rBI=;
	b=i1f+KpFT9t0GfeV/lQc1N8mN87gFclmjE/AXL5mCcmXNp0clG8RkHdbUYugyclAfWjxX
	 P9Li+zjLat+lMkwKG+1K80NZxkpxA3JTElm0TG9RqWooFH8x2SXxTj0cCVMaU0m3xRy4/
	 ox7xZ040HSauqARONSPO6vOfiZNyHnTJ5UjhPm/vARHLbEQjah4aju1VsB9g7r3SYD17Z
	 TPxcOkxnfNQiQuQQ6t8fVUPsGZJngL+XsuCEQ5CU5/yG/M6RSf5/Lc3sfDcmr4KRBmO2N
	 257XqCd29QS0dwJIqN6/HG2WzrErmQAh78ToB2N5su282kOMLK5QlYlxFE7OEq8cn0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zNfP/TXW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D392606D2E1;
	Fri, 13 Nov 2026 16:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNfP/TXW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179591F000C4;
	Fri, 13 Nov 2026 16:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585851;
	bh=TkXeQyQKdFb8XsWL1p4EMXM6AUCCCcLtkyQYLhp8rBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNfP/TXWOp507S6OGdFJc+WG0vBTw6k7ZP7lGx8rm17Ctc1kq/0NXUSZxHkFFJ3sk
	 DW8egW5LRwBxQeEaKYih3EIRLFf+Cfyr/gndV/+x/gYpxvGYnwXAqoEQcDRRRojcBN
	 JWfUBZs8cjAa9iiHIP52QuU41wfUpDwdNaEeuirY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 428/507] x86/boot: Fix off-by-one error in sme_clear_pgd()
Date: Fri, 13 Nov 2026 10:52:12 -0500
Message-ID: <20261113153811.250938951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c07a2c381ed1f..2d5cb3f7eee63 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -99,7 +99,7 @@ static void __init sme_clear_pgd(struct sme_populate_pgd_data *ppd)
 	pgd_t *pgd_p;
 
 	pgd_start = ppd->vaddr & PGDIR_MASK;
-	pgd_end = ppd->vaddr_end & PGDIR_MASK;
+	pgd_end = (ppd->vaddr_end - 1) & PGDIR_MASK;
 
 	pgd_size = (((pgd_end - pgd_start) / PGDIR_SIZE) + 1) * sizeof(pgd_t);
 
-- 
2.53.0




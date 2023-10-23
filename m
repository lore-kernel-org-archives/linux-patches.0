Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9291514282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKQxTgiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A264C433C7;
	Mon, 23 Oct 2023 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059825;
	bh=SQ9ZC2BRDP9SkAekIY73z4Y7n3g/d/hhZV2IRquSdd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKQxTgiJy2o5GzD1A1QLoY/7rP6NpveBIh473bZmvqSPUKUuWgXyUifRkEx1TAD62
	 BNR1jAD7QFFY8BgHAz7b9OezGyNWaI8nQx4biEb5Ax7WUSGUJz+eVcptjswT/Bxgw+
	 fzZvwrO5RtTXjx0FAeRPcP1hWkISRptKgHoIhGm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/98] powerpc/64e: Fix wrong test in __ptep_test_and_clear_young()
Date: Mon, 23 Oct 2023 12:56:27 +0200
Message-ID: <20231023104814.940130741@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 5ea0bbaa32e8f54e9a57cfee4a3b8769b80be0d2 ]

Commit 45201c879469 ("powerpc/nohash: Remove hash related code from
nohash headers.") replaced:

  if ((pte_val(*ptep) & (_PAGE_ACCESSED | _PAGE_HASHPTE)) == 0)
	return 0;

By:

  if (pte_young(*ptep))
	return 0;

But it should be:

  if (!pte_young(*ptep))
	return 0;

Fix it.

Fixes: 45201c879469 ("powerpc/nohash: Remove hash related code from nohash headers.")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/8bb7f06494e21adada724ede47a4c3d97e879d40.1695659959.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/nohash/64/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/nohash/64/pgtable.h b/arch/powerpc/include/asm/nohash/64/pgtable.h
index 7cd6809f4d332..30fcffc02caad 100644
--- a/arch/powerpc/include/asm/nohash/64/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/64/pgtable.h
@@ -215,7 +215,7 @@ static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
 {
 	unsigned long old;
 
-	if (pte_young(*ptep))
+	if (!pte_young(*ptep))
 		return 0;
 	old = pte_update(mm, addr, ptep, _PAGE_ACCESSED, 0, 0);
 	return (old & _PAGE_ACCESSED) != 0;
-- 
2.40.1




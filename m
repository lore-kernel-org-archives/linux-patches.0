Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E261944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsrPPPNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AD6C433C9;
	Mon, 16 Oct 2023 08:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446278;
	bh=ausUvg5r0XEZz7yqKG9aTK5gXv8Nhhsr0XESIRfohA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsrPPPNPU+01O9M9qepZ6uDzC/R8wWKhrfA7joNVRW/QyiBO6O6JvVpSVKD8aHiAW
	 LIlxobzF6OvPGjJmHKLp3Xp+iof76jCbi8or+peK9M230/Bya7sv6KuC4b2CzZZuTv
	 dnMH1xANj+nuP6bpjZjdY9+S0Rc8nVQMmPT/SZyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/102] powerpc/8xx: Fix pte_access_permitted() for PAGE_NONE
Date: Mon, 16 Oct 2023 10:41:22 +0200
Message-ID: <20231016083955.907088323@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 5d9cea8a552ee122e21fbd5a3c5d4eb85f648e06 ]

On 8xx, PAGE_NONE is handled by setting _PAGE_NA instead of clearing
_PAGE_USER.

But then pte_user() returns 1 also for PAGE_NONE.

As _PAGE_NA prevent reads, add a specific version of pte_read()
that returns 0 when _PAGE_NA is set instead of always returning 1.

Fixes: 351750331fc1 ("powerpc/mm: Introduce _PAGE_NA")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/57bcfbe578e43123f9ed73e040229b80f1ad56ec.1695659959.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/nohash/32/pte-8xx.h | 7 +++++++
 arch/powerpc/include/asm/nohash/pgtable.h    | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
index 1a89ebdc3acc9..0238e6bd0d6c1 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -94,6 +94,13 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
 #define pte_wrprotect pte_wrprotect
 
+static inline int pte_read(pte_t pte)
+{
+	return (pte_val(pte) & _PAGE_RO) != _PAGE_NA;
+}
+
+#define pte_read pte_read
+
 static inline int pte_write(pte_t pte)
 {
 	return !(pte_val(pte) & _PAGE_RO);
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index ac75f4ab0dba1..7ad1d1b042a60 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -45,7 +45,9 @@ static inline int pte_write(pte_t pte)
 	return pte_val(pte) & _PAGE_RW;
 }
 #endif
+#ifndef pte_read
 static inline int pte_read(pte_t pte)		{ return 1; }
+#endif
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_special(pte_t pte)	{ return pte_val(pte) & _PAGE_SPECIAL; }
 static inline int pte_none(pte_t pte)		{ return (pte_val(pte) & ~_PTE_NONE_MASK) == 0; }
-- 
2.40.1




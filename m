Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2A3187332;
	Mon, 12 Aug 2024 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479250; cv=none; b=scJruX9DofIPkJH6r2XeSkSQb4vUiUja7DK3/VaB4JGs4UsfAIqZpYlso9nP3bbUs7Vm/lQ2ukHiYzIhTzGUiHR0ZNT7P9JQ4qk+Mr2bMvEJtKzcSyKMS7B+tF3Xv254vz3DuUoDTymfXWomOs+Sqmtr++5yZxILP+V0i9XlD3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479250; c=relaxed/simple;
	bh=rQoa9YVR5tnlULIa8Z5bgma87IUvfiNz+v5Osn6f8Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smz2HS7otIzflDYqHXOT4zRJFhh3+iIjwUhMIvDyxSsmsBNTbjEcyVxCfPSv+rv5a4c/vYF2NMFzxZQ0hK1MBeysK7qZ3MWPaOiP6ZSNqoDc0Qu5Gqh2Jmd8tpt3XX2RRbTx4EjoRBeLINgBDYHJ2H7xuxyHABNtfUtEMwhruc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+xDpcvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+xDpcvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13349C4AF0F;
	Mon, 12 Aug 2024 16:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479250;
	bh=rQoa9YVR5tnlULIa8Z5bgma87IUvfiNz+v5Osn6f8Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+xDpcvOXwAe9VabSoZcuYfDmbGf+Z71QgJsR0w9nWfqfYM03bsWysLaJaLNT9Qdm
	 2syTQvPOyOzMnwKgwX9hY7QrQvdTpHTgdH0d7yH5hEdCw+KPeBkwHLzF/qRBFQ8RNy
	 FJyBZPhHeYFSVLjsp87FGlJm9CN5EPkjA1Bk4qFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/189] x86/mm: Fix pti_clone_pgtable() alignment assumption
Date: Mon, 12 Aug 2024 18:01:02 +0200
Message-ID: <20240812160132.384648317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 41e71dbb0e0a0fe214545fe64af031303a08524c ]

Guenter reported dodgy crashes on an i386-nosmp build using GCC-11
that had the form of endless traps until entry stack exhaust and then
#DF from the stack guard.

It turned out that pti_clone_pgtable() had alignment assumptions on
the start address, notably it hard assumes start is PMD aligned. This
is true on x86_64, but very much not true on i386.

These assumptions can cause the end condition to malfunction, leading
to a 'short' clone. Guess what happens when the user mapping has a
short copy of the entry text?

Use the correct increment form for addr to avoid alignment
assumptions.

Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bit")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20240731163105.GG33588@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pti.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index 51b6b78e6b175..f7d1bbe76eb94 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -374,14 +374,14 @@ pti_clone_pgtable(unsigned long start, unsigned long end,
 			 */
 			*target_pmd = *pmd;
 
-			addr += PMD_SIZE;
+			addr = round_up(addr + 1, PMD_SIZE);
 
 		} else if (level == PTI_CLONE_PTE) {
 
 			/* Walk the page-table down to the pte level */
 			pte = pte_offset_kernel(pmd, addr);
 			if (pte_none(*pte)) {
-				addr += PAGE_SIZE;
+				addr = round_up(addr + 1, PAGE_SIZE);
 				continue;
 			}
 
@@ -401,7 +401,7 @@ pti_clone_pgtable(unsigned long start, unsigned long end,
 			/* Clone the PTE */
 			*target_pte = *pte;
 
-			addr += PAGE_SIZE;
+			addr = round_up(addr + 1, PAGE_SIZE);
 
 		} else {
 			BUG();
-- 
2.43.0




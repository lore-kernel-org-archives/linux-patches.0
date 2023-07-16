Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294638F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF24C433CA;
	Sun, 16 Jul 2023 19:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537437;
	bh=G3MfMjPT8TmOP1ULgp5UFNYbOu650UDH9ztQ6U3ZatI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lKQkfZjS0ltDvk7ShTx8HZcaeFEdVbMqm4Re5S2rn0DODs5KNIV9Hl9UnpL3L0Hw
	 F/sss6LxKCOU8ExcydfbGSyvD0Swh1ts4YdDmg+4Uzd+JvM6vwOLWidsiaILwpSB74
	 fygR1ZTfuXv3gt/I+LTF1uVRI61ZTb3G9P4I9kOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 096/800] x86/mm: Fix __swp_entry_to_pte() for Xen PV guests
Date: Sun, 16 Jul 2023 21:39:09 +0200
Message-ID: <20230716194951.343397968@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 0f88130e8a6fd185b0aeb5d8e286083735f2585a ]

Normally __swp_entry_to_pte() is never called with a value translating
to a valid PTE. The only known exception is pte_swap_tests(), resulting
in a WARN splat in Xen PV guests, as __pte_to_swp_entry() did
translate the PFN of the valid PTE to a guest local PFN, while
__swp_entry_to_pte() doesn't do the opposite translation.

Fix that by using __pte() in __swp_entry_to_pte() instead of open
coding the native variant of it.

For correctness do the similar conversion for __swp_entry_to_pmd().

Fixes: 05289402d717 ("mm/debug_vm_pgtable: add tests validating arch helpers for core MM features")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230306123259.12461-1-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pgtable_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 7929327abe009..a629b1b9f65a6 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -237,8 +237,8 @@ static inline void native_pgd_clear(pgd_t *pgd)
 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val((pte)) })
 #define __pmd_to_swp_entry(pmd)		((swp_entry_t) { pmd_val((pmd)) })
-#define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
-#define __swp_entry_to_pmd(x)		((pmd_t) { .pmd = (x).val })
+#define __swp_entry_to_pte(x)		(__pte((x).val))
+#define __swp_entry_to_pmd(x)		(__pmd((x).val))
 
 extern void cleanup_highmap(void);
 
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1E7495C2;
	Thu, 30 Nov 2023 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlo309la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF28C433C9;
	Thu, 30 Nov 2023 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361794;
	bh=bM+l8+dieA2EloDaMTuxQu/9HPeShOIz/n2oRH4ZdMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlo309laxw2evxpYhDTwz+/JZ1JyubhbEbf8XX7G47pj1aXj3SXAeOKP5Wmh6DYgk
	 XZAtSOMP4G8zN1UqCj0us51pYcNTT83cDT1x2ElqQut7vN9FvUhxZmrM7i+I9DztZC
	 /3n0g2VcN+2EfDDOpTqGmCvYkeqUBzp6UTQm3KlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/82] arm64: mm: Fix "rodata=on" when CONFIG_RODATA_FULL_DEFAULT_ENABLED=y
Date: Thu, 30 Nov 2023 16:21:56 +0000
Message-ID: <20231130162136.750516183@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

[ Upstream commit acfa60dbe03802d6afd28401aa47801270e82021 ]

When CONFIG_RODATA_FULL_DEFAULT_ENABLED=y, passing "rodata=on" on the
kernel command-line (rather than "rodata=full") should turn off the
"full" behaviour, leaving writable linear aliases of read-only kernel
memory. Unfortunately, the option has no effect in this situation and
the only way to disable the "rodata=full" behaviour is to disable rodata
protection entirely by passing "rodata=off".

Fix this by parsing the "on" and "off" options in the arch code,
additionally enforcing that 'rodata_full' cannot be set without also
setting 'rodata_enabled', allowing us to simplify a couple of checks
in the process.

Fixes: 2e8cff0a0eee ("arm64: fix rodata=full")
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20231117131422.29663-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/setup.h | 17 +++++++++++++++--
 arch/arm64/mm/pageattr.c       |  7 +++----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/setup.h b/arch/arm64/include/asm/setup.h
index f4af547ef54ca..2e4d7da74fb87 100644
--- a/arch/arm64/include/asm/setup.h
+++ b/arch/arm64/include/asm/setup.h
@@ -21,9 +21,22 @@ static inline bool arch_parse_debug_rodata(char *arg)
 	extern bool rodata_enabled;
 	extern bool rodata_full;
 
-	if (arg && !strcmp(arg, "full")) {
+	if (!arg)
+		return false;
+
+	if (!strcmp(arg, "full")) {
+		rodata_enabled = rodata_full = true;
+		return true;
+	}
+
+	if (!strcmp(arg, "off")) {
+		rodata_enabled = rodata_full = false;
+		return true;
+	}
+
+	if (!strcmp(arg, "on")) {
 		rodata_enabled = true;
-		rodata_full = true;
+		rodata_full = false;
 		return true;
 	}
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 47f532e13d532..826cb200b204f 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -29,8 +29,8 @@ bool can_set_direct_map(void)
 	 *
 	 * KFENCE pool requires page-granular mapping if initialized late.
 	 */
-	return (rodata_enabled && rodata_full) || debug_pagealloc_enabled() ||
-		arm64_kfence_can_set_direct_map();
+	return rodata_full || debug_pagealloc_enabled() ||
+	       arm64_kfence_can_set_direct_map();
 }
 
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
@@ -105,8 +105,7 @@ static int change_memory_common(unsigned long addr, int numpages,
 	 * If we are manipulating read-only permissions, apply the same
 	 * change to the linear mapping of the pages that back this VM area.
 	 */
-	if (rodata_enabled &&
-	    rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
+	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
 			    pgprot_val(clear_mask) == PTE_RDONLY)) {
 		for (i = 0; i < area->nr_pages; i++) {
 			__change_memory_common((u64)page_address(area->pages[i]),
-- 
2.42.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54B34FF4E;
	Tue, 16 Dec 2025 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885678; cv=none; b=qpSIrylokjZkLvaISIVV7hMWsp2YJvGp+8f0AlJStF1ZnsVKp1J+B192tIQj+Kt2wscxyJA1muYqMjO8cbnNUZropOomrS9egO/CWFof6zHCzutyD78vy55bIQ5RUaYZ152i9RUFgrcF7bz5suzvjrUWVCJJCMT3EEVBD48q37Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885678; c=relaxed/simple;
	bh=vh8wfOeBhOPJTpctlyuavo+kSgRjl3vZzD30n2sajXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G42apVFLqxPuqlQWbMv1LRvfHsGQNkXAAb6ltz9ajwXKet/UCXejvxFBiYkjz3FYgF3tqmgFX6kuJ/sSrk8KXitjxCADPRrbiUbTNr9ujIDTVlXEHAI+j4veGH2pgWuKPxnn3jKDAco/HxsfyekviZrD5ULU/LwxL+0K+JUUa0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNBZyDYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNBZyDYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E03AC4CEF1;
	Tue, 16 Dec 2025 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885678;
	bh=vh8wfOeBhOPJTpctlyuavo+kSgRjl3vZzD30n2sajXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNBZyDYtQifwAeGr4i6MimdBjwcHnaWxaAYtjlzFp9XuZ/9Z3ZjqhcroYzoHlpy2/
	 viL57KeNu7dh5sJXye/gP8LqEqiXIUN6Lrmc7pKKJOFzaEDHyCMf3HXz9PyqhL3F2Q
	 TI8E78kDpskyK714970AviVw5rqbN7uiLgcPvTfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael van der Westhuizen <rmikey@meta.com>,
	Tobias Fleig <tfleig@meta.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 178/507] efi/libstub: Fix page table access in 5-level to 4-level paging transition
Date: Tue, 16 Dec 2025 12:10:19 +0100
Message-ID: <20251216111351.964780033@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usamaarif642@gmail.com>

[ Upstream commit 84361123413efc84b06f3441c6c827b95d902732 ]

When transitioning from 5-level to 4-level paging, the existing code
incorrectly accesses page table entries by directly dereferencing CR3 and
applying PAGE_MASK. This approach has several issues:

- __native_read_cr3() returns the raw CR3 register value, which on x86_64
  includes not just the physical address but also flags Bits above the
  physical address width of the system (i.e. above __PHYSICAL_MASK_SHIFT) are
  also not masked.

- The pgd value is masked by PAGE_SIZE which doesn't take into account the
  higher bits such as _PAGE_BIT_NOPTISHADOW.

Replace this with proper accessor functions:

- native_read_cr3_pa(): Uses CR3_ADDR_MASK to additionally mask metadata out
  of CR3 (like SME or LAM bits). All remaining bits are real address bits or
  reserved and must be 0.

- mask pgd value with PTE_PFN_MASK instead of PAGE_MASK, accounting for flags
  above bit 51 (_PAGE_BIT_NOPTISHADOW in particular). Bits below 51, but above
  the max physical address are reserved and must be 0.

Fixes: cb1c9e02b0c1 ("x86/efistub: Perform 4/5 level paging switch from the stub")
Reported-by: Michael van der Westhuizen <rmikey@meta.com>
Reported-by: Tobias Fleig <tfleig@meta.com>
Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20251103141002.2280812-3-usamaarif642@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/x86-5lvl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/x86-5lvl.c b/drivers/firmware/efi/libstub/x86-5lvl.c
index f1c5fb45d5f7c..c00d0ae7ed5d5 100644
--- a/drivers/firmware/efi/libstub/x86-5lvl.c
+++ b/drivers/firmware/efi/libstub/x86-5lvl.c
@@ -66,7 +66,7 @@ void efi_5level_switch(void)
 	bool have_la57 = native_read_cr4() & X86_CR4_LA57;
 	bool need_toggle = want_la57 ^ have_la57;
 	u64 *pgt = (void *)la57_toggle + PAGE_SIZE;
-	u64 *cr3 = (u64 *)__native_read_cr3();
+	pgd_t *cr3 = (pgd_t *)native_read_cr3_pa();
 	u64 *new_cr3;
 
 	if (!la57_toggle || !need_toggle)
@@ -82,7 +82,7 @@ void efi_5level_switch(void)
 		new_cr3[0] = (u64)cr3 | _PAGE_TABLE_NOENC;
 	} else {
 		/* take the new root table pointer from the current entry #0 */
-		new_cr3 = (u64 *)(cr3[0] & PAGE_MASK);
+		new_cr3 = (u64 *)(native_pgd_val(cr3[0]) & PTE_PFN_MASK);
 
 		/* copy the new root table if it is not 32-bit addressable */
 		if ((u64)new_cr3 > U32_MAX)
-- 
2.51.0




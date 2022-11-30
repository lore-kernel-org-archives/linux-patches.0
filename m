Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303A179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D05FC433C1;
	Wed, 30 Nov 2022 18:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833026;
	bh=wrwmUT9CGF7VPCAMKuCM/INJr3l8x1wMFRTeW9wPXOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvX8J+KlRW8c7HaG2Gf3NnuCcCQhKW5X1piLYhatkpiI3yWP3cP3BfddVvF9FFM3B
	 JwyGzXQrCU1qXzCSsEzHRrTPXjy6h8avsoZeow9jWtPnV2q7X7dxEKObNTJ1y0+gtJ
	 +fUdWNZknvCAA+m3AQJybzbYceRYafleKmBxyib8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Borislav Petkov <bp@suse.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 124/162] x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
Date: Wed, 30 Nov 2022 19:23:25 +0100
Message-Id: <20221130180531.851837895@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

commit 4dbd6a3e90e03130973688fd79e19425f720d999 upstream.

Current code re-calculates the size after aligning the starting and
ending physical addresses on a page boundary. But the re-calculation
also embeds the masking of high order bits that exceed the size of
the physical address space (via PHYSICAL_PAGE_MASK). If the masking
removes any high order bits, the size calculation results in a huge
value that is likely to immediately fail.

Fix this by re-calculating the page-aligned size first. Then mask any
high order bits using PHYSICAL_PAGE_MASK.

Fixes: ffa71f33a820 ("x86, ioremap: Fix incorrect physical address handling in PAE mode")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/1668624097-14884-2-git-send-email-mikelley@microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/ioremap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -216,9 +216,15 @@ __ioremap_caller(resource_size_t phys_ad
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PHYSICAL_PAGE_MASK;
+	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
+	/*
+	 * Mask out any bits not part of the actual physical
+	 * address, like memory encryption bits.
+	 */
+	phys_addr &= PHYSICAL_PAGE_MASK;
+
 	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
 	if (retval) {



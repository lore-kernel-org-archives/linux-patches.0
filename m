Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1297FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3667C433EF;
	Mon, 15 May 2023 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169952;
	bh=n/jF8GJHXx0IsOirldqpSobt7hxHOwb1eQXwmAdpSSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAEkkIoYmNecimAhlhKVQhkdHE5PkVFNndGU0bvAGBdjDf94hMJ2Dcy7q4iSLLhhZ
	 p83WBWB7Fvu/dCUY8OZJnYUMJOEWshPGeGkEWubVDvc0N9hxZyBn4LPx7v9kE13Tm3
	 3VtDGSrx4QyVoKXxg6EVuNxfGxY2kHOvjhqPx/h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
	David Hildenbrand <david@redhat.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.3 224/246] parisc: Fix encoding of swp_entry due to added SWP_EXCLUSIVE flag
Date: Mon, 15 May 2023 18:27:16 +0200
Message-Id: <20230515161729.309596490@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 6f9e98849edaa8aefc4030ff3500e41556e83ff7 upstream.

Fix the __swp_offset() and __swp_entry() macros due to commit 6d239fc78c0b
("parisc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE") which introduced the
SWP_EXCLUSIVE flag by reusing the _PAGE_ACCESSED flag.

Reported-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Tested-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 6d239fc78c0b ("parisc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE")
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/pgtable.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -413,12 +413,12 @@ extern void paging_init (void);
  *   For the 64bit version, the offset is extended by 32bit.
  */
 #define __swp_type(x)                     ((x).val & 0x1f)
-#define __swp_offset(x)                   ( (((x).val >> 6) &  0x7) | \
-					  (((x).val >> 8) & ~0x7) )
+#define __swp_offset(x)                   ( (((x).val >> 5) & 0x7) | \
+					  (((x).val >> 10) << 3) )
 #define __swp_entry(type, offset)         ((swp_entry_t) { \
 					    ((type) & 0x1f) | \
-					    ((offset &  0x7) << 6) | \
-					    ((offset & ~0x7) << 8) })
+					    ((offset & 0x7) << 5) | \
+					    ((offset >> 3) << 10) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 



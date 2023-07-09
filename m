Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D5B522D
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F44AC433C7;
	Sun,  9 Jul 2023 11:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901404;
	bh=eWUD0JCjdAlO6MgKHYvybEqDaVxmuzCvYvA/tzXVLE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFKlqEWH468+ItmiJTExii2QuREd/5ZH3hsE5CEsFneGPbMd9NT5vKTxmMrbAOJzP
	 HouBjKx8Qkeg7dpNiON6dD3x+U+yPZ/NhzEvEpaDfr5UGxzccQWpk805J3L12MFqHr
	 GFnz9MCP41lsg2ZWhm+2tY11UH3mGrX6Re+C9CCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Qun-wei Lin <Qun-wei.Lin@mediatek.com>,
	David Hildenbrand <david@redhat.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 001/431] mm: call arch_swap_restore() from do_swap_page()
Date: Sun,  9 Jul 2023 13:09:09 +0200
Message-ID: <20230709111451.140448187@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Collingbourne <pcc@google.com>

commit 6dca4ac6fc91fd41ea4d6c4511838d37f4e0eab2 upstream.

Commit c145e0b47c77 ("mm: streamline COW logic in do_swap_page()") moved
the call to swap_free() before the call to set_pte_at(), which meant that
the MTE tags could end up being freed before set_pte_at() had a chance to
restore them.  Fix it by adding a call to the arch_swap_restore() hook
before the call to swap_free().

Link: https://lkml.kernel.org/r/20230523004312.1807357-2-pcc@google.com
Link: https://linux-review.googlesource.com/id/I6470efa669e8bd2f841049b8c61020c510678965
Fixes: c145e0b47c77 ("mm: streamline COW logic in do_swap_page()")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
Closes: https://lore.kernel.org/all/5050805753ac469e8d727c797c2218a9d780d434.camel@mediatek.com/
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3915,6 +3915,13 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/*
+	 * Some architectures may have to restore extra metadata to the page
+	 * when reading from swap. This metadata may be indexed by swap entry
+	 * so this must be called before swap_free().
+	 */
+	arch_swap_restore(entry, folio);
+
+	/*
 	 * Remove the swap entry and conditionally try to free up the swapcache.
 	 * We're already holding a reference on the page but haven't mapped it
 	 * yet.



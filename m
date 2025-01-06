Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42C816D9B8;
	Mon,  6 Jan 2025 15:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178039; cv=none; b=Z1L9FGEDY3CgN8bU3ROeSrDMDx2hbhWyLsxUoZohjzScGNnoQpFFBtwIUrwJ4WBGzl+P5y4TSk5forXWmekOuuAIXMXHQ43slZurqfi4fbkw0HEImRE+ST7vugB6bHU6SsXEnQKJNUOJTTL8z6R6quvJUeG5ndrPujhCd+8p9fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178039; c=relaxed/simple;
	bh=vE3zw5jqLcgWWtZK0Z5TlLpzHrNrSKghtxwRaUk3t4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzjZCbmelvQM9ST8pVbRormEUpxtqyuc7BoXwM2hu5KCn7rpYNyq17UO1NcYhJPgZdNYMiJP78UCCmIRPc1mLlXzKQuu7nBke3d2/aYokHZqcZgRPx8Eq8cIVMInN3hku4bKYWqUNAsaqzHl8P2mvxZmPLnfYnt37sBL9LlmGbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hPxIOkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hPxIOkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFF2C4CED2;
	Mon,  6 Jan 2025 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178039;
	bh=vE3zw5jqLcgWWtZK0Z5TlLpzHrNrSKghtxwRaUk3t4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hPxIOkNxUFUShKEpEWqPubRvWtu/UeisdHAmoYM9fNGgCuwZsJqTvRTYEixTK7Lq
	 XtqvtgbEq9Rfo6FbaL0hyLkPY5lcLL0FraJMQsC6L0hBiBkoqPUPsKtqmp9C2YnTH3
	 LPNoazg0aJ94Cyu9WAb76mK/saTpTmjByEK8itO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 141/156] mm: shmem: fix incorrect index alignment for within_size policy
Date: Mon,  6 Jan 2025 16:17:07 +0100
Message-ID: <20250106151147.040835743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit d0e6983a6d1719738cf8d13982a68094f0a1872a upstream.

With enabling the shmem per-size within_size policy, using an incorrect
'order' size to round_up() the index can lead to incorrect i_size checks,
resulting in an inappropriate large orders being returned.

Changing to use '1 << order' to round_up() the index to fix this issue.
Additionally, adding an 'aligned_index' variable to avoid affecting the
index checks.

Link: https://lkml.kernel.org/r/77d8ef76a7d3d646e9225e9af88a76549a68aab1.1734593154.git.baolin.wang@linux.alibaba.com
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1664,6 +1664,7 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma ? vma->vm_flags : 0;
+	pgoff_t aligned_index;
 	bool global_huge;
 	loff_t i_size;
 	int order;
@@ -1698,9 +1699,9 @@ unsigned long shmem_allowable_huge_order
 	/* Allow mTHP that will be fully within i_size. */
 	order = highest_order(within_size_orders);
 	while (within_size_orders) {
-		index = round_up(index + 1, order);
+		aligned_index = round_up(index + 1, 1 << order);
 		i_size = round_up(i_size_read(inode), PAGE_SIZE);
-		if (i_size >> PAGE_SHIFT >= index) {
+		if (i_size >> PAGE_SHIFT >= aligned_index) {
 			mask |= within_size_orders;
 			break;
 		}



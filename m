Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D5C267F57;
	Fri, 21 Nov 2025 13:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731506; cv=none; b=oOoGM8hjazTkc2j9hy8dhjIN9rzXhhsKayRwu7ExmkHN0JUZjO/xQ47XxR0QReDCNOOOqQfntkhPVy8TWvnG98a0++hdxahoYlFScoYHuvssXeGiVQQVLWKnv3O+2VYMf5IQ/XGPWAa90E8Tnq8TT/1c45Og4j9K9bF+tqLPey0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731506; c=relaxed/simple;
	bh=8uPidkjyXiV3086O5t2cIdQhqkJCR91KTnD6z8r6Pzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucMR+H+J/9osN/f9SzBKVJMmZ8wnkPXq2ocX2KfwBaLLrEEYPNWWw0kp00Qraqz1x7ZWddqLkzuXP60YbQTHdu8GhvPg19UvAhJV3bHVrVJ9gAgvhWGtqwVbGQU9f+/0ode9hLg5BH5ulVvwyPPMeRVMTitw+AdduI0gj9AfG94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylHZXJC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylHZXJC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91973C4CEF1;
	Fri, 21 Nov 2025 13:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731506;
	bh=8uPidkjyXiV3086O5t2cIdQhqkJCR91KTnD6z8r6Pzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylHZXJC8GwinRLkhw3p/74VqOiZA3GwFqxkVKSbBvBFaFYnbUvPhv1DO2TsimCndr
	 s4IEI3+cG2ViY12XeP0qamQZNIgS55FhS5yQpaRqLBl9c3AZHxrHyrqjWowX53uumD
	 S/wBUC3JR6QtmBpOQynLhk70Ao6fUTahb4Sm0YYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 187/247] mm/mremap: honour writable bit in mremap pte batching
Date: Fri, 21 Nov 2025 14:12:14 +0100
Message-ID: <20251121130201.434661089@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Dev Jain <dev.jain@arm.com>

commit 04d1c9d60c6ec4c0003d433572eaa45f8b217788 upstream.

Currently mremap folio pte batch ignores the writable bit during figuring
out a set of similar ptes mapping the same folio.  Suppose that the first
pte of the batch is writable while the others are not - set_ptes will end
up setting the writable bit on the other ptes, which is a violation of
mremap semantics.  Therefore, use FPB_RESPECT_WRITE to check the writable
bit while determining the pte batch.

Link: https://lkml.kernel.org/r/20251028063952.90313-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
Reported-by: David Hildenbrand <david@redhat.com>
Debugged-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index bd7314898ec5..419a0ea0a870 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -187,7 +187,7 @@ static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr
 	if (!folio || !folio_test_large(folio))
 		return 1;
 
-	return folio_pte_batch(folio, ptep, pte, max_nr);
+	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, FPB_RESPECT_WRITE);
 }
 
 static int move_ptes(struct pagetable_move_control *pmc,
-- 
2.52.0




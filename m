Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DAADF71;
	Mon,  6 Jan 2025 15:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178042; cv=none; b=CWxHiB6ED9zm++d1n/31D1/L/f3AmTpQVtrdS2bzorFIrtDIfHSkizex7JtvxOX0Xc4hcls7BFeTAhl7cvQDf8oMsjZz7734j8Bbq3dUy3LRmvNWn+VkJqSv3knWiPyGGF9V6z+jTnMWrlAN1VDps8XA4t7e/UuCvpbxhkKqEfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178042; c=relaxed/simple;
	bh=MAXLtjEf6XzUs/ZMKB0JJVESY+YlO/2y4g83vl1oP8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEnpZGEP6JDD98oIVVmB+iKrLo3oHCtJoWRu7gD8FcTPTlUmro9srlAX6ZPRd54gzbWz15VLdZAnfiWt2Nzcige9l9JiwZH2vUtaRObhqtoRdFmu3HCX4U4eh5/k/1USa0BcM8iPB+ThkUhjD3vFT1TDpYMcdxVl3IHGPn9HK4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fttkE5D3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fttkE5D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FCEC4CEDF;
	Mon,  6 Jan 2025 15:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178042;
	bh=MAXLtjEf6XzUs/ZMKB0JJVESY+YlO/2y4g83vl1oP8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fttkE5D35LruBORjOWhPIHgaQPAvhZgea5dvb1e4gG5HwJdqyH/nsbkyWca+lqc8T
	 7kRpyLMCmRAkjZZkmrFX14sDd8Ll9xSGb0zKQlEFsXh8wfhq4jb5qZJdWoUZWh+uB0
	 bO8VS8WxTlku16dD4HGPo4E0swic2pCHLjKpEg54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 142/156] fs/proc/task_mmu: fix pagemap flags with PMD THP entries on 32bit
Date: Mon,  6 Jan 2025 16:17:08 +0100
Message-ID: <20250106151147.077898209@linuxfoundation.org>
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

From: David Hildenbrand <david@redhat.com>

commit 3754137d263f52f4b507cf9ae913f8f0497d1b0e upstream.

Entries (including flags) are u64, even on 32bit.  So right now we are
cutting of the flags on 32bit.  This way, for example the cow selftest
complains about:

  # ./cow
  ...
  Bail Out! read and ioctl return unmatched results for populated: 0 1

Link: https://lkml.kernel.org/r/20241217195000.1734039-1-david@redhat.com
Fixes: 2c1f057e5be6 ("fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1810,7 +1810,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		}
 
 		for (; addr != end; addr += PAGE_SIZE, idx++) {
-			unsigned long cur_flags = flags;
+			u64 cur_flags = flags;
 			pagemap_entry_t pme;
 
 			if (folio && (flags & PM_PRESENT) &&



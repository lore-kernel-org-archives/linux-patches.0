Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047220;
	b=hvBLWVaGmONT2yKsqvR7ojUdcFt0xEf/ZZx4YgtbOx5SlntyD0QokDBK07c/6+l+9+ZA
	 SIBgCVU4n7Aedpo584Mo51F9RUyspymAh0AvpTQ3NQw37Ti/OUBrCBkag9VjJHmGqLYl0
	 t4xidvMidLywStkSTyfpZeJDPvcs++S1b02nm1Uj95olCtr/jr6xMqva15RMzCjtgXU78
	 AaaBQqlIG9s8QI6aDUaFjjemET2kzf6Fop9FWfeSFNFD8tj4uAkEaLGnJ1YUtz7ZCe954
	 PuQTlqnlJbw1vPybmjyu6vSLy8bb+THiMNrQa1XzPv49SVGzyDPC5ImKebAYLJk7ViQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IyPHK0iKLZVfpyD7YRJ46m4mPpm1W+hU3of7udm5UBM=;
	b=kPkgwrdSTVOCqsW6KbwXP1VYFUL72p4Ynx1wdXCByagt9RGTyQcfDNiO6qLM4r/MzG6i
	 /TN1lWXlqRfkOGebzE9RKY6Qc3BTt/7OrZf+9RSeZoKh07n8PoPGHde0ntcXU5v+izdH9
	 npCSDupYiw8QOnBX3qAYnzP7/LI+G5wQZJZIhn8ak7AgmFMd9BYRMRjIG9O97fvcvjERY
	 XR2i4lNWbo96aMalbPwstTh1kNfWYJa7I8KPEA5fQJG5szYNtH30pL4SKnz68rJRpDsh5
	 1o74qjXV+chmJPg+BFTZpwG9XYgwFpUK5KqtlPpmjuN2+g/69NPq/Wy7cTGcX3cTYGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+jDfkNW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AB060A2608;
	Thu, 19 Nov 2026 00:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+jDfkNW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36271F000C5;
	Thu, 19 Nov 2026 00:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047220;
	bh=IyPHK0iKLZVfpyD7YRJ46m4mPpm1W+hU3of7udm5UBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+jDfkNWnM1FZVdRV2Yh3FJMo+2ZJ/5+61kFkL2eWXU/yJdkfzBl7bxXcIuOhAIqJ
	 /npCYdzTw6LOzJ7v0IBDrQLIM5duKNh0Q3yKvxNE7cRGec04JJrIwE4fVhGG5BO3Gb
	 2Wd4E1ooHvKAVbhdDXS4Xp8ZQrQwRCQ9di8KQ/RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brian Geffon <bgeffon@google.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1562/2857] mm/mremap: correctly uncharge accountable VMAs in error path
Date: Wed, 18 Nov 2026 15:43:16 +0100
Message-ID: <20261118150257.634598028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 65e722a74df992719676ead85a9e93fb2b5a0983 ]

The mremap error path is a fragile and unwieldy beast - it reverses the
page table move then updates vma_remap_struct state to swap VMA, length and
address between old and new VMAs in copy_vma_and_data().

If the mremap() operation didn't specify MREMAP_DONTUNMAP then its caller,
move_vma(), invokes unmap_source_vma(), which unmaps the new VMA rather
than the old one.

For accountable VMAs when MREMAP_DONTUNMAP is not specified,
unmap_source_vma() unsets VMA_ACCOUNT_BIT during this unmap in order that
only the delta of a VMA expansion is charged (performed by
vrm_calc_charge() earlier).

Therefore nothing uncharges the expanded VMA size, and there is a permanent
leak in global Committed_AS.

Resolve the issue by uncharging when MREMAP_DONTUNMAP is not specified.

Link: https://lore.kernel.org/20261019-other-mremap-charge-leak-v1-1-d94477fe6545@kernel.org
Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: adapted vrm_uncharge() to a direct vm_unacct_memory() call with an explicit VM_ACCOUNT check in move_vma() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index ec66e7be8afea..9a53eeb2191f5 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -692,6 +692,19 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		 */
 		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len,
 				 true);
+
+		/*
+		 * The new VMA will be unmapped rather than the old one.
+		 *
+		 * When an accountable move is being performed, this unmapping
+		 * will not uncharge any expansion, so do that now.
+		 *
+		 * A move is accountable if the VMA is accountable and
+		 * MREMAP_DONTUNMAP is not specified.
+		 */
+		if (vm_flags & VM_ACCOUNT && !(flags & MREMAP_DONTUNMAP))
+			vm_unacct_memory(to_account >> PAGE_SHIFT);
+
 		vma = new_vma;
 		old_len = new_len;
 		old_addr = new_addr;
-- 
2.53.0




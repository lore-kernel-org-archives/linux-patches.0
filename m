Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063641;
	b=v+NyKB7IhLjXvhfCGZvb+IbjOzffasaOq8QtzSpoFYCBf0/M1WdkDGoeOMiNHwPR0J7D
	 EJ4TdjQz/TwKi2yc/x9eKIEePPp6eCacf6iBq4U6nvHI9ag3xS283MwhyD1kDfNXWVwYV
	 CMSworpogh1qhze14mxLwdK/Sa855KJQCvwSWNvaOD2Nqrz4C174bztqmIjepvTeELMjf
	 zLSGqLZzN4PbDi2Rp05Yo7tjngyjOSJogBf3yZB8WLPgCK4KGC7wX/G/NNp9rKY73a1nI
	 gxsAWAFLRSSr3diOj/zjkoEUkxdm+0TGdI692dOXXRWZUrisnL3IQ1GAwHSDEcABNCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tdc5n407z0SjVrYQFS0J6Pw3S84mdgjS5kOD3Ryhl9Y=;
	b=Hj2Ppo/+T5LC8Ho20LdM84v1lopxpUR9Kijly2Lqb0ESPGNdAssGXTzdzNm+xs0VGX+D
	 QXxBl5V44C7lYL6JCmwCqXbsbviSX67fuWpbcyS6rMoRga09HLtugXkOjFyd4509U2S2F
	 3C3FolZBBxipGBj1o/Ojxk1q8olaED/mdWana1W1NcVuIVSj3fV+huCaDAvmIHc/gZyGN
	 nne9snqDPYZhuC78SSBzoc9Epn5W/nZxf/uNO+Scj4qBMDaQxQQEIwgJteagu9qwaRn1i
	 Kf3dcXgGDEiOpWw4+X1gQphQruMnhmMJZDZzBdEdKEqKM0QAB7d3AIOVHiYq7zoRZlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2icX2af;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DEC6082BF3;
	Sat,  7 Nov 2026 15:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2icX2af
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377001F0089F;
	Sat,  7 Nov 2026 15:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063641;
	bh=tdc5n407z0SjVrYQFS0J6Pw3S84mdgjS5kOD3Ryhl9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2icX2afX/qAMKojVYDC4o91CqFU4/lYRkCLC1wfYkzXQEj9QsPPlGUkyD6pR713c
	 dbxbeLnbSGSLw1ItcbrxhOSAQnzYGMQpA9uVfzGVwlwEaKgGat7PEJ2KAGYTuSuInw
	 odXTegxY5NiTl0GUzRJOXTjUyNSBAQH83CEtB344=
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
Subject: [PATCH 6.18 756/869] mm/mremap: correctly uncharge accountable VMAs in error path
Date: Sat,  7 Nov 2026 08:57:18 -0500
Message-ID: <20261107134918.356215057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 593e6f94eba3d..8ed7c50e499b8 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1239,6 +1239,20 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 		pmc_revert.need_rmap_locks = true;
 		move_page_tables(&pmc_revert);
 
+		/*
+		 * When copy_vma_and_data() returns, the new VMA will be
+		 * unmapped rather than the old one.
+		 *
+		 * When an accountable move is being performed, this unmapping
+		 * will not uncharge any expansion, so do that now.
+		 *
+		 * A move is accountable if the VMA is accountable and
+		 * MREMAP_DONTUNMAP is not specified, so only do so if the
+		 * latter is true.
+		 */
+		if (!(vrm->flags & MREMAP_DONTUNMAP))
+			vrm_uncharge(vrm);
+
 		vrm->vma = new_vma;
 		vrm->old_len = vrm->new_len;
 		vrm->addr = vrm->new_addr;
-- 
2.53.0




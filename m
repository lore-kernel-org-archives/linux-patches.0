Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038627;
	b=fQDkyGFANSlWwTlF8/tD/kq0NMYhTa7sAaf1M2JkUUyOIPf6S+ovakqPkauZS9ZK8aPw
	 iTt+Vgcb+4Na+6Si6/RrPjuoI6OTkV+roo4YsVVAT2hon20HjXS1owhBA0KYlu6RYv4tc
	 5WYbAepi7+TgoyPq/lVRwoVR3vLQENqj/wVj9Av7mqUJJjMpOD9UOlgFWFk7CuURYyNRV
	 NejibPFgq+ShFyTAd/S1NbubfeoCUTBzzsVCg67i10SxjZVKmjkLnxEPA4JZIojf9W8G9
	 +q3Q41IcFVGeb23B9/FwMkDd1/0lLBP1u11wH/nTTjcuMf8CAUrcf9Qk4KwJHB5tFFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8+R04m3OPToaSRiMyRm1EJcH93THDud+kL70RF3nBjs=;
	b=T3m1fRvDWiBnQA+OOuxsef+MiOw9w+eo5iJLkwRxj4bX1qZtUmsF50nLl4DZI7p9GvmC
	 nA6gwXsDHk55Tl0s0TrYmSxTXXCgBC0SOMdCVoXW0bNbY6Q/6jWpaAkTFyEC0APnYErEi
	 r2B4aviQCBv+NpxzsrSqyAZHZL2DOXvwKm3SnRzdpdX+MIX+BdK0gw/S9cupdtUWV1fRO
	 QKjmxY0M596s904VElVFc+kmrQOVnKShanbPpT8vd/bZZ02kEO4weF5uqExqzzOXA9ExY
	 D7KHeutbplN2V95W2noRGgoms6zWEVRM4zywGNosdeAX23iPSIzOpLFQzQSUAV61sMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJAiBGoI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D746606A31C;
	Wed, 18 Nov 2026 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJAiBGoI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CA41F000C4;
	Wed, 18 Nov 2026 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038627;
	bh=8+R04m3OPToaSRiMyRm1EJcH93THDud+kL70RF3nBjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJAiBGoIVrZCOZGS3BAVJCbkzIYjfiqkO1A6GKA1pXN5U/QR1wHdooGxp3kQNq+mu
	 7AjIAWs2zjLwNHcm9su09b2wpJvNxO8cCy6aI2IZqCdp84/ernNRgTWAQKe5TCkx0K
	 8UK/mVc96jBk+VQSHJe3GtBASP9wt6GyVQV/kiEc=
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
Subject: [PATCH 6.6 1810/3318] mm/mremap: correctly uncharge accountable VMAs in error path
Date: Wed, 18 Nov 2026 15:40:32 +0100
Message-ID: <20261118150416.152332415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced vrm_uncharge() with a VM_ACCOUNT-guarded vm_unacct_memory(to_account >> PAGE_SHIFT) call in move_vma(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0739a31b54eed..26d3cb46f6ec1 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -715,6 +715,19 @@ static unsigned long move_vma(struct vm_area_struct *vma,
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065359;
	b=I3mNaYy62kqGCaYf8WDFNNZrYOFpyhL8dXSg+J6Bu+1YpfsjxQ9SsIDn7Y9EFBP/WM5i
	 2XR9bwq1zcUe5mW+T8RcKzd6KHwGUgI2+XoIETnE59tOjbovkeaVBB1TWVhZs54lPGxFi
	 vOpv6CUIL/cxW7BvLp3mA3102/qiWhNfZ9rcsQqUVWL6EXSdqlVlIDaiXqJT94Ffx4N7J
	 TiPgFMC0gaKyZDcGopQ0tdrFNEl6eWrz9JY7h1A7wrgfUz6+2yUn6AdII0LYt37PL4kLo
	 OFOJNoyly3Nb1bCQ4IkreErOShn49NZQIH2LY0qVBem3M9AGAPU/IeKq5YOznGK+6SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQGJ/IIIPCm9+dqikFXGvgQeqHkNx0+k32gprIzgA9Q=;
	b=PwB0mBEcxjNbz7bRty4ssk2E13e1JqIsLAAUl0WvH7xG/xubxlwyNx3RSEZX6hA7FQ8V
	 zzWCkbzT95LPkHu0RNbpnppqZcz645rHA0XICi2IhrzFIaW7uKFNrggIgbMF8eQc7qRTv
	 RX1xcgV35W1sB09aOi47/K9jfe9FWDHMNICYq5MZHV8bsA3toIeP9B6+EjLTWGl/svn4Z
	 NOF+ztlI2JHCJdqTL4ph6KAhEiCTmXbeI8wEnfRXGFRsMykNruN6P+8bhz/iS+hbDNQAM
	 H5pxF8NGpdqMiwMeMgGflRPhe5KAm1KnIw2GRWVrT6BGOy4vAQW5K5K6sBUsFFvVQXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMoXELPZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E565F606A32C;
	Sat,  7 Nov 2026 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMoXELPZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9572D1F0089F;
	Sat,  7 Nov 2026 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065358;
	bh=JQGJ/IIIPCm9+dqikFXGvgQeqHkNx0+k32gprIzgA9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMoXELPZlZTR+qiGEYCYgB0ohJnpz/OCXgTpvWMcGwTsuo8tte6+rbC56NLxl2tY0
	 agIl20Er5zg41iLnW6UfwFB2XeA4kKnxyhp4ncRp110hQJ6ZwOT3Eo2SNiol098Juh
	 3vBInYa7Nm+R/Pdof6gIdkclYBA+wtJ02EkuupwQ=
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
Subject: [PATCH 7.3 1094/1257] mm/mremap: correctly uncharge accountable VMAs in error path
Date: Sat,  7 Nov 2026 08:56:30 -0500
Message-ID: <20261107135009.479087865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d5f34e87c518a..d404e4b1b6cbd 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1339,6 +1339,20 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
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




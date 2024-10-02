Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BA629CE7;
	Wed,  2 Oct 2024 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877171; cv=none; b=l5YDNSzAFR1upiherzS4SN+7fucGDxsoL77exEGuotx7MBBOPjZQFCAA/BSoTbIpkN5LZusMI7bCnMpubg2m6ckkhDtL3miWUdcSAmCPuAe8X56RgeZar6ksOKqvkNuHNIy4w1ykXtiNCRloFFN4Us2fwOOxUy3kJ+pn0fV5ByM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877171; c=relaxed/simple;
	bh=Tm0p6nI7pcnBgxpf1C5VNBfY6raeiPF5a8mgB7iQhiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnAJ4YfP+HICqrW/ETU4A+H0ABY5OJuSEHhPtAN7oqhc0Y5zDrh8Y1myZ1+pHzPrfZ7s2aQzoIxc9JzJVVYzK3Fr7xpIpIGBKiEaR+oicYkyAyXekkYgkZcZORRpek267sv6/KK0cP6ivIOOlBdtzg+UAKDNnzQH+EjHZW4CMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/KianC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/KianC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AACBC4CEC2;
	Wed,  2 Oct 2024 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877171;
	bh=Tm0p6nI7pcnBgxpf1C5VNBfY6raeiPF5a8mgB7iQhiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/KianC1yTLloeMzZLPAFG7EcspvBuABE2XW6aaKqnZMiY+pggWtLeyDeEJjIKKEQ
	 wKXz1bddISywftSeB1jPJ9GeFw82hXJpsg/NwzIng+3TdgdlJ3Nug1dl28kKFxdpaH
	 sThNcumiqRv+eeo4MjFK0GdSeuelfVCdtJl/3a0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 688/695] mm/huge_memory: ensure huge_zero_folio wont have large_rmappable flag set
Date: Wed,  2 Oct 2024 15:01:26 +0200
Message-ID: <20241002125849.982377233@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

commit 2a1b8648d9be9f37f808a36c0f74adb8c53d06e6 upstream.

Ensure huge_zero_folio won't have large_rmappable flag set.  So it can be
reported as thp,zero correctly through stable_page_flags().

Link: https://lkml.kernel.org/r/20240914015306.3656791-1-linmiaohe@huawei.com
Fixes: 5691753d73a2 ("mm: convert huge_zero_page to huge_zero_folio")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -220,6 +220,8 @@ retry:
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return false;
 	}
+	/* Ensure zero folio won't have large_rmappable flag set. */
+	folio_clear_large_rmappable(zero_folio);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
 		preempt_enable();



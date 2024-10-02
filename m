Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911D1D0B82;
	Wed,  2 Oct 2024 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879072; cv=none; b=Z1ga+IaOK5hBHqf94Albor1/8vrZ2EAOZWp7w6K65/hThub/Qsk0GWAyyn9qP+MNRk3GrtxPavbO/8uKg7nulBdars0XcQP+9zwCEoFOgC2P9OO1virrxAjJ/Myh/qyuLIurmFWtTEbcTyWb6wnSqD7RNXiUKeaVotgzvHse7Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879072; c=relaxed/simple;
	bh=yUIKQ4npLM/R/IIAg6tZ21kbVC9Ij+7SG1YEpkj/N3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoCi5zGm8FFTH4+ZEVAyRwGaG/C7ppPKtllHr/dh3SnaFJ2R3kExvsAGOXo7rHOCFmkY0MIbn5rP5Qi8bbOUzMltiT+Ng2Nf/C6IqZ5r/W+SD6CfGb8Y4xMf79EAkVpwEPwVtKJ38Ii8yWwxctihUqp+V9kUkIeB6Eft5lNX0jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swcZ4z0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swcZ4z0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257DDC4CEC2;
	Wed,  2 Oct 2024 14:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879071;
	bh=yUIKQ4npLM/R/IIAg6tZ21kbVC9Ij+7SG1YEpkj/N3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swcZ4z0WRy8BV2wFLl8DQSdkI1J/4W+TTvBg/CCRjfYGCxxboCmWzCTo+Xt7Vy1jV
	 ehiLncjlzbhsjIrJY/vq4ecVU2Ntzu09lyZWgL8RK8labAqHOPYF1/7BsHDoSwoCiH
	 IV7ssYQjXacvYXQhpuVop12dejEy/WEzBFI2p9n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 628/634] mm/huge_memory: ensure huge_zero_folio wont have large_rmappable flag set
Date: Wed,  2 Oct 2024 15:02:08 +0200
Message-ID: <20241002125835.913209770@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -214,6 +214,8 @@ retry:
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return false;
 	}
+	/* Ensure zero folio won't have large_rmappable flag set. */
+	folio_clear_large_rmappable(zero_folio);
 	preempt_disable();
 	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
 		preempt_enable();



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74B81898ED;
	Tue, 30 Jul 2024 16:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358421; cv=none; b=OS19CFeeERyMDnbb6dN0zAqWqyLR5t/wR01F0p4kVymgZ0RCm7HWxhzwD1XkaZ0D5dK9ysyy67Gm9hKdwmqcN4AkGSZM74BRmZIu+3COp837lqgTJtehOiReeeqNy+BGWv4BCXdhut58uFuKo6nsUl3PnN+HrPfDbT4PGOo0Ndw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358421; c=relaxed/simple;
	bh=mOae/5y2kMwBMVSYcJblxIR+zKVTqbp11L0WfN8N/QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDjk227kupUw+w4E038C49Od3BbP670lUMHrSpKiP1Mdyo4v6WLTM9frrkTUZ6Q40hCwyGRpE2Q+c4KfWU5NGcNjCafMHkTrjaCXHsDLGRTGyG43a27XPOesM6SsoR84/CxX4oUr4mSDPF8RQbA8lc+4UZHXukMuFaVtqxnRO50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3T/4LHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3T/4LHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22366C32782;
	Tue, 30 Jul 2024 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358420;
	bh=mOae/5y2kMwBMVSYcJblxIR+zKVTqbp11L0WfN8N/QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3T/4LHPpqS3JGGAxC7zyYHsCg/IjAJZUrpGBUTmSbonWkTi4z5SruN3iuKewGfJG
	 jp8HCVVYCEdE72RrZHoiYIM93bYV+ZwXAEy+h9z7s9O3ifQ5cktPXRIO4BTl0xBiYA
	 rljQDZkUHkh2rNCN1oOPhnDq4pvRbQ0B0evfp7ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Xu <weixugc@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Alexander Motin <mav@ixsystems.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 360/568] mm/mglru: fix div-by-zero in vmpressure_calc_level()
Date: Tue, 30 Jul 2024 17:47:47 +0200
Message-ID: <20240730151653.933500582@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhao <yuzhao@google.com>

commit 8b671fe1a879923ecfb72dda6caf01460dd885ef upstream.

evict_folios() uses a second pass to reclaim folios that have gone through
page writeback and become clean before it finishes the first pass, since
folio_rotate_reclaimable() cannot handle those folios due to the
isolation.

The second pass tries to avoid potential double counting by deducting
scan_control->nr_scanned.  However, this can result in underflow of
nr_scanned, under a condition where shrink_folio_list() does not increment
nr_scanned, i.e., when folio_trylock() fails.

The underflow can cause the divisor, i.e., scale=scanned+reclaimed in
vmpressure_calc_level(), to become zero, resulting in the following crash:

  [exception RIP: vmpressure_work_fn+101]
  process_one_work at ffffffffa3313f2b

Since scan_control->nr_scanned has no established semantics, the potential
double counting has minimal risks.  Therefore, fix the problem by not
deducting scan_control->nr_scanned in evict_folios().

Link: https://lkml.kernel.org/r/20240711191957.939105-1-yuzhao@google.com
Fixes: 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while isolated")
Reported-by: Wei Xu <weixugc@google.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alexander Motin <mav@ixsystems.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5226,7 +5226,6 @@ retry:
 
 		/* retry folios that may have missed folio_rotate_reclaimable() */
 		list_move(&folio->lru, &clean);
-		sc->nr_scanned -= folio_nr_pages(folio);
 	}
 
 	spin_lock_irq(&lruvec->lru_lock);



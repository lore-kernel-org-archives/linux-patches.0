Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095BB1A76A4;
	Tue, 30 Jul 2024 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359934; cv=none; b=IkbesZo2m+tAUuY2o9z8Dkpn8Lj/Gv00lPg3BndDUWT0hxVLz711M+glPRPU5JMruTHWDWrffui4JezUXIYZiyrnJYnzNfR6qDfbkbzVILOnIt13kVsW9aRzq8/ZwRxW4hutZ+o4dUxvt1mBHjnOx/Vh+zNzw17CdQ+9h9l3nrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359934; c=relaxed/simple;
	bh=zef8wqD/xIo0CC1bybhywXQ1ZM5JSLf6JTexGXUt3As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGw2zBq2rWAKBwMgxIP8Bwni/NY4hn8XcXezb7TNM5/ZG33Dh+UqlW2OWcuo1Qri8xxdSMjRgA48aXKJ4eh1JQ5OYuXyWdygZsQOCToVTqQf+xfoxTawK+QUSxepSwwGkwR0XCCRAOkfKgAh+jmDqORggHwGVOkHQMVivkXRvAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mo53S9sP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mo53S9sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CE9C4AF0A;
	Tue, 30 Jul 2024 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359933;
	bh=zef8wqD/xIo0CC1bybhywXQ1ZM5JSLf6JTexGXUt3As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mo53S9sPTm0xgziJVAnPvlwHQsf5xGKeEbi3/TZHmC9/OLzuBPvuLT5GuAqKpE/x7
	 ME/F1SZRNO8BGR32YF40MhRnuA0gihyhTHJNfHZirvvrU4Lt8DZYqEuFCv9RczUXg/
	 yRIPvjTr0YV+vShL63VF0nD2gEw1cVwolZ+2EMmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Xu <weixugc@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Alexander Motin <mav@ixsystems.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 538/809] mm/mglru: fix div-by-zero in vmpressure_calc_level()
Date: Tue, 30 Jul 2024 17:46:54 +0200
Message-ID: <20240730151745.994893621@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
@@ -4582,7 +4582,6 @@ retry:
 
 		/* retry folios that may have missed folio_rotate_reclaimable() */
 		list_move(&folio->lru, &clean);
-		sc->nr_scanned -= folio_nr_pages(folio);
 	}
 
 	spin_lock_irq(&lruvec->lru_lock);



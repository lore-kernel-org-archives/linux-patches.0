Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B0B8BE8;
	Tue, 30 Jul 2024 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357239; cv=none; b=DEaFQ2it3HP/5rB+K4OfFVyd/Jtp0HejUTvYkYkksuhkHcMLsWO2CNRXMIlohiaFkBS8AqFaz1Ezn/VdAnUL+qLFlDp/P2W9XcuGMXnrpBqoZ3TvE/z571JD+07NM0InfbaS00LOLMBrP3sAyZ/+dIss4bt6+bh5BtoMo2UYd7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357239; c=relaxed/simple;
	bh=9jvsUP/qLpuA4Ul36TOMI5HfOaT4z/odrRPdwCNKz2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7I2RX7o2tW0dHRyM1syacFKl57nTcafAkAQCUqLwP6dVR8p2Ah81iGllduhB4hQS6aamgved8kP/zqqhFV8zu9lCJccMocczUIkoKjB9WeJ0ZARR9wR6F5tGmgqUYjvLX0sXErN/MVOMFDjWGNr1sNCeRTgGNh8ylW1I3lcLMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5hEB90E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5hEB90E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AC0C32782;
	Tue, 30 Jul 2024 16:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357239;
	bh=9jvsUP/qLpuA4Ul36TOMI5HfOaT4z/odrRPdwCNKz2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5hEB90Eu57GgAu3hDc82wY/VQ25zv6UOvwxUHNDXu5KVSkYSHEGXtEVYFuw8dFQw
	 NHhegh/hsi+KmiHzfcYZ0mDN4pPHoOVcDsksPciY2aJO4ogJd3dtZC+1o0kpzhlanA
	 sEbZR3P2l42NMepNkdiYs2KZ/9WTwqSr1zBi7YMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Xu <weixugc@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Alexander Motin <mav@ixsystems.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 272/440] mm/mglru: fix div-by-zero in vmpressure_calc_level()
Date: Tue, 30 Jul 2024 17:48:25 +0200
Message-ID: <20240730151626.458853987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5065,7 +5065,6 @@ retry:
 
 		/* retry folios that may have missed folio_rotate_reclaimable() */
 		list_move(&folio->lru, &clean);
-		sc->nr_scanned -= folio_nr_pages(folio);
 	}
 
 	spin_lock_irq(&lruvec->lru_lock);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DAC381D6;
	Fri, 24 Nov 2023 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTWEJrbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74B6C433C7;
	Fri, 24 Nov 2023 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849683;
	bh=UKvrc9vr/g/5BBQukXl9uTsncor+kai8cIrvP/UOF48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTWEJrbkCLEpVpbY/2E4U+PMFt92hO1LYwNVmqRdjJizVrOJmw5t+v3+Kjbb3p1TX
	 YJLk31zag16hR6G8YPcuJiHg+Lkz/QmEg84dALia3CU8ZhPpL/5sp9PxFsOp+NFMi3
	 eq/80ahcFKUJIkpjcyb/Sih/xni2oha04VU2liDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jakub Acs <acsjakub@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 279/530] mm/damon/lru_sort: avoid divide-by-zero in hot threshold calculation
Date: Fri, 24 Nov 2023 17:47:25 +0000
Message-ID: <20231124172036.540446494@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 44063f125af4bb4efd1d500d8091fa33a98af325 upstream.

When calculating the hotness threshold for lru_prio scheme of
DAMON_LRU_SORT, the module divides some values by the maximum nr_accesses.
However, due to the type of the related variables, simple division-based
calculation of the divisor can return zero.  As a result, divide-by-zero
is possible.  Fix it by using damon_max_nr_accesses(), which handles the
case.

Link: https://lkml.kernel.org/r/20231019194924.100347-5-sj@kernel.org
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Jakub Acs <acsjakub@amazon.de>
Cc: <stable@vger.kernel.org>	[6.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -193,9 +193,7 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
-	/* aggr_interval / sample_interval is the maximum nr_accesses */
-	hot_thres = damon_lru_sort_mon_attrs.aggr_interval /
-		damon_lru_sort_mon_attrs.sample_interval *
+	hot_thres = damon_max_nr_accesses(&damon_lru_sort_mon_attrs) *
 		hot_thres_access_freq / 1000;
 	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!scheme)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7B0330B37;
	Fri, 17 Oct 2025 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715736; cv=none; b=N4QUPdfk+k3hGO6mbk0sTeIcThY/q/Z92KbNIVFTkHrOWwv7LVfA3/t2XKOEnqtqidJV/fkc5A/lI9dMuI9vCYZV8dkAEKQbEDf9Aiy5Hb/BlSFdQ6XTbjX8ccU36rT//aHLbqHuIqp2KLXfPD5a9qRKsF64kiMIwC3PmEBQzoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715736; c=relaxed/simple;
	bh=g6q7BDclN8puxqITbZJNplTtJHvn6xR/7qxwLzk+D1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSap71uu1nczyPtxvOeC2ZjUQvtc5B2hgzSBQhpIb4mTwIkhHVQL2JAEhA//C4OP1NuE6qVMwUZVWoeYJ6SqEtzvjgjrAFEreOZ/vjUNRGfMyxz7rpTZbUX/vttnEJnslkCzil58V7M55+lWNpQa2b5PuU+UsZ3WPtBpJkIH9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsWEQtez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsWEQtez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70077C4CEE7;
	Fri, 17 Oct 2025 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715735;
	bh=g6q7BDclN8puxqITbZJNplTtJHvn6xR/7qxwLzk+D1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsWEQtezOBe49Ae73+fObxziUawbzbgXcH5tAJkk7ABcL+cUb+VX1dxM0qrIcAvza
	 vQOkRxLEjiWyH2a2iiW+MSV/elj3LjdKINRgEmRVWr3vYJ64UlHHNT0fhR/xtO2yGO
	 MQ5rpMb3lG9OwhCH4Bdbz/RJuoV4Ujhh5UDIZhnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 320/371] mm/damon/lru_sort: use param_ctx for damon_attrs staging
Date: Fri, 17 Oct 2025 16:54:55 +0200
Message-ID: <20251017145213.654417813@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit e18190b7e97e9db6546390e6e0ceddae606892b2 upstream.

damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is, however, directly
updating the monitoring attributes of the running context.  And the
attributes are over-written by later damon_commit_ctx() call.  This means
that the monitoring attributes parameters are not really working.  Fix the
wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250916031549.115326-1-sj@kernel.org
Fixes: a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: <stable@vger.kernel.org>	[6.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -203,7 +203,7 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
 



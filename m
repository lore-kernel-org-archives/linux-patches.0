Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5794C2F12BE;
	Fri, 17 Oct 2025 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714719; cv=none; b=WUdibzED5yUCBlCU9rhvJABedOm3e1c0fKxkJuEmC2UjYlq5YbPPyh2aQZuJLNvDtpK25a8Uc3nFvniT7smZ0h2eUcFFpEgCMTwCtfhaXB1aKzW+r8Lwdl/RA+kfYZLIPcms9S2C6c56e/yPEvvpUWBJ8tV3ASnnx6+b3hvqio4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714719; c=relaxed/simple;
	bh=Kd4UchAh7zzUweYRIahhSq1p9KvCCFGntotJhhEDYxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjcwzKgj2+LqcgUNIRqqjn2lKIXdiQWmySqdkxoLrflQlUbAVvs7E7SKLTOscvuohqwL60kKHXA5cmcmnAH9dHFg68RmPrfe7h+tIXJ7GdYAoQVZ+t4VBWwGmtpP4dkcpLOlWmcDgvMCp10MREbppBWCYpIEV1qcRcvAwdxOZoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuhMYe56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuhMYe56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9312C4CEE7;
	Fri, 17 Oct 2025 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714719;
	bh=Kd4UchAh7zzUweYRIahhSq1p9KvCCFGntotJhhEDYxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuhMYe56jnvplBJdRWL+VKFhuS8v4y/2X74T+CF/w59+OLEqQK6kYWyvt6FYy4LSD
	 tP+w15Shet95yQ0u87E5Mw8hY8ZX/VW4TISPAs0VZDlEHr0OKJDB3cTyCEyNlDoVWd
	 vPO+s+oMFqeTzAkQQGI2TxfXTUWypQryioxSJDdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 209/277] mm/damon/lru_sort: use param_ctx for damon_attrs staging
Date: Fri, 17 Oct 2025 16:53:36 +0200
Message-ID: <20251017145154.758654422@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 



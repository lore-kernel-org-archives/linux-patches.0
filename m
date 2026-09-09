Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9AC57D20D;
	Wed,  9 Sep 2026 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963349; cv=none; b=YSetkTsB7l3JkOETv+X7GuOis373MQH/mQpEUsQ7vdnl9wZEr9bQbGRu8hSBLkQzlDaJYVs9+McmBk91Bw3UBtEGwBfuK+QLzuyR3NY9/N8uDOIVnLGq5BC10FMpXaFh5NFrlDC6y6HV6TaK4LZqLTjoHkbrBDGq6zoT0btwl74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963349; c=relaxed/simple;
	bh=YSNCWl/x2WGo//M+1cn0Xh9mRlF/8veDBnnkn6/9MRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aztyPteJBzbfcQNQ0O12QG7Asw1S+6m8iA+jlCKBnux8XSeWnWOX3/xMxh74zdQUEu6sdmCf/ssa0a3uwQutjpjpXwd1tb80T4cXAW2sO0YPBvXvlGfKTv5IY/KeHaVbNiKXz1zoRwG5cApZN2CNM2GUkerOBgVnELaAEMpZVJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ6XpRSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ6XpRSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B641F00A3A;
	Wed,  9 Sep 2026 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963348;
	bh=z237ihOQ5kD1HEuE38CSHsZ/mi+P30+4bGnboPEPiW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQ6XpRSUoH6cZRB/AG3LzIF2IlDH0kh5mhGYxVeuiy4F/KCYM+iGgmBqOwNd7ukXd
	 v+IGLwkq9VRkBaXjHWHEOHglDGRiHAyfrf3tqGJ+LiP2IZjc7ChVunGzCdsvVNdi07
	 P+fzzuVFrEGqDhZzGtf6vSReM4/SnFJOzZevJX9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 049/583] samples/damon/mtier: handle damon_stop() failure
Date: Wed,  9 Sep 2026 15:35:34 +0200
Message-ID: <20260909134239.663388698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 9dc5b6d66fd51b103eff21ed0df3e292f489ebc0 upstream.

damon_sample_mtier_stop() assumes its damon_stop() call will always
successfully stops the two DAMON contexts.  Hence it deallocates the two
DAMON contexts after the damon_stop() call.  However, if a given context
is already stopped, damon_stop() fails and returns an error while letting
the DAMON contexts that have not yet stopped keep running.  This kind of
unexpected early DAMON context stops could happen due to memory allocation
failures in kdamond_fn().  Because damon_sample_mtier_stop() just
deallocates all DAMON contexts with damon_target and damon_region objects
that are linked to the contexts, the execution of the unstopped DAMON
context (kdamond) ends up using the memory that freed (use-after-free).
Fix the issue by separating the damon_stop() to be invoked per context.

Note that DAMON_SYSFS also allows multiple DAMON contexts execution.  But,
it calls damon_stop() for each context one by one.  Hence this issue is
only in mtier.

For the long term, it would be better to refactor damon_stop() to always
ensure stopping all contexts regardless of the failures in the middle.
Make this fix in the current way, though, to keep it simple and easy to
backport.  I will do the refactoring later.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-5-sj@kernel.org
Link: https://lore.kernel.org/20260609014219.3013-1-sj@kernel.org [1]
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/mtier.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -202,7 +202,8 @@ static int damon_sample_mtier_start(void
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 2);
+	damon_stop(ctxs, 1);
+	damon_stop(&ctxs[1], 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }



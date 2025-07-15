Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015472E49B3;
	Tue, 15 Jul 2025 13:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586947; cv=none; b=kkI2HC0zwlPQJmDqG9mOtDiDETZyD3c0PuJkTJDv/h10Ur/2H9nXSkNTfsYwIRaj1sG6PtJT/KxYXv6R4YipwjK3UMpPW3nraH/ETJx7B0TNlfHrKTL764nFn+HAyYSKOPKcoDOFqAl+RvSdDRLDhsInqgEAXyR4hqoB18cXB78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586947; c=relaxed/simple;
	bh=bQ5FNtSqEMmG1pUzMjhGg2NDhSHq/KBHaoNTjAeY428=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNBQZViJsP9G9f63aKSU+L5OSckWW0Yd1aCKE2UtQmLWSQQdNcszFCX5WWmrs4P0GefGpPo7YaxEplEk5tdbnhr5m3WYLkm90hOrY8SEzoDKXsXJxiaxHwfyChPJPNv44imFSmJ4A4dPZakOJvVZUDcYy7qgxFh1jbtydjq38Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ws/oo1bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ws/oo1bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC76C4CEE3;
	Tue, 15 Jul 2025 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586946;
	bh=bQ5FNtSqEMmG1pUzMjhGg2NDhSHq/KBHaoNTjAeY428=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ws/oo1bqm8XbKXjPDumN1iPz4r98hBvgo1h6qKKrohKq2cmTe1TQc6D82WBQq9tKy
	 WA83F1HvqAAfwF32BubXksfXG53yf1EkwFyGb/hNmyDEjR7v6AffdIOSppxpSyOcGF
	 /+ojt10Nw0ZdbIApxRm2Yj0iKLYG+QUXujXDi/8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 108/192] mm/damon/core: handle damon_call_control as normal under kdmond deactivation
Date: Tue, 15 Jul 2025 15:13:23 +0200
Message-ID: <20250715130819.224610705@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit bb1b5929b4279b136816f95ce1e8f1fa689bf4a1 upstream.

DAMON sysfs interface internally uses damon_call() to update DAMON
parameters as users requested, online.  However, DAMON core cancels any
damon_call() requests when it is deactivated by DAMOS watermarks.

As a result, users cannot change DAMON parameters online while DAMON is
deactivated.  Note that users can turn DAMON off and on with different
watermarks to work around.  Since deactivated DAMON is nearly same to
stopped DAMON, the work around should have no big problem.  Anyway, a bug
is a bug.

There is no real good reason to cancel the damon_call() request under
DAMOS deactivation.  Fix it by simply handling the request as normal,
rather than cancelling under the situation.

Link: https://lkml.kernel.org/r/20250629204914.54114-1-sj@kernel.org
Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2306,9 +2306,8 @@ static void kdamond_usleep(unsigned long
  *
  * If there is a &struct damon_call_control request that registered via
  * &damon_call() on @ctx, do or cancel the invocation of the function depending
- * on @cancel.  @cancel is set when the kdamond is deactivated by DAMOS
- * watermarks, or the kdamond is already out of the main loop and therefore
- * will be terminated.
+ * on @cancel.  @cancel is set when the kdamond is already out of the main loop
+ * and therefore will be terminated.
  */
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
@@ -2356,7 +2355,7 @@ static int kdamond_wait_activation(struc
 		if (ctx->callback.after_wmarks_check &&
 				ctx->callback.after_wmarks_check(ctx))
 			break;
-		kdamond_call(ctx, true);
+		kdamond_call(ctx, false);
 		damos_walk_cancel(ctx);
 	}
 	return -EBUSY;



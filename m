Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BF5577E4F;
	Wed,  9 Sep 2026 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963355; cv=none; b=k113eDtaRH8tYQ+EB+zp79sYRL+/t6jEDLK1/YrPCPion3uIY2U3XSm3ohZLOCxCHU8d1jbG7Z6V1QMqCUPL1Ct9cP5IVTtUG5mPkCKRWXODEmw/XZZliU1y8+hYw2QidQ3+3UsOJIsrUgrDIuUUG0zGlDrwFqV4LMo3Zej6/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963355; c=relaxed/simple;
	bh=5iJiNk9Z5/R/SBCHGbH0jdRpweqODVK5eWU7rgfereU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtWnuPQp47Cjk2BUTBl5SCEVqfLSzP3AA5eJyQdmG6q9Eg9KftdWQM2v3FmUG8bE5xTxWkdZAA3ZMOc0GsCFpPPsvDp6CDBq1+y+a7XNLGDFBimk3T4quzPI/cMPhAk7O3OBJs1oEG1u9lj6rTxNEkB/OGQOZC/r9q61AmJBENM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWrKwHkP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWrKwHkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819241F00A3A;
	Wed,  9 Sep 2026 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963354;
	bh=jgWD3RiFSPv4D4W15im2fD+gZ/jUGMar+ykffkUqPt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWrKwHkPZVycQTEPiEJuzsAQV48aGJ0uHyKh4vE06LBwdFII/l/Cg5dafSlzPhuZH
	 bnWRpkwdod2xr6oxV+Fh/QvEmcy5Y0jj6rzOCyjXMnsMuXSKRMyOkAAmHmt1HRf3AQ
	 E0jlWNNA7yADloNXXsQs1rgkUKa4wETDCnePRq9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 051/583] samples/damon/prcl: stop and free damon ctx when damon_call() fails
Date: Wed,  9 Sep 2026 15:35:36 +0200
Message-ID: <20260909134239.730502123@linuxfoundation.org>
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

commit a73fa45d3f0f42c446ae55c5799e3d5ef044cd5d upstream.

damon_sample_prcl_start() calls damon_call() right after damon_start() is
succeeded.  The kdamond that has started by the damon_start() could be
terminated by itself before or in the middle of the damon_call()
execution.  There could be multiple reasons for such a stop including
monitoring target process termination and kdamond_fn() internal memory
allocation failures.  In the case, damon_call() will fail and return an
error without cleaning up the DAMON context object.  The
damon_sample_prcl_start() caller assumes it would clean up the object,
though.  When the user requests to start DAMON again,
damon_sample_prcl_start() is called again, allocates a new DAMON context
object and overwrites the pointer for the previous object.  As a result,
the previous context object is leaked.

Safely stop the kdamond and deallocate the context object when the failure
is returned.  Note that the kdamond should be stopped first, because
damon_call() failure means not complete termination of the kdamond but
only the fact that the termination process has started.

The user impact shouldn't be that significant because the race is not easy
to happen, and only up to one DAMON context object can be leaked per race.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-7-sj@kernel.org
Link: https://lore.kernel.org/20260610035214.4850-1-sj@kernel.org [1]
Fixes: a6c33f1054e3 ("samples/damon/prcl: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/prcl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 0db259894691..edeae145c4a8 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -112,7 +112,12 @@ static int damon_sample_prcl_start(void)
 	}
 
 	repeat_call_control.data = ctx;
-	return damon_call(ctx, &repeat_call_control);
+	err = damon_call(ctx, &repeat_call_control);
+	if (err) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	return err;
 }
 
 static void damon_sample_prcl_stop(void)
-- 
2.55.0




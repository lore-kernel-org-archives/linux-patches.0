Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE97553FD2B;
	Wed,  9 Sep 2026 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961879; cv=none; b=a5iReR8rISIx3MRj5O9LOnaACoPKKdGpKzD2zVWRreReOLCHgQSzjt2DzA3ENPl14stuCoQ1F21UVHt+rGLslqr2J4uCKEWn8N3de2FbhY7u5s1EWjsrLkLSq6JefwuRGw6FSXwuqIkrKeh90zXHuXfsdKXS88fOldhEz8/4Zw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961879; c=relaxed/simple;
	bh=edL5qQDkRcLWrtM9YKtEuuntL/ejuna+Nh59LhOHVEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miMI3woqH3OZ7rtHSX69eVLREdpmBgMKdAT7ppHsmvy8+q0+2gGyBMEokHNbB3h2eYe2kBN9oOpO2+C58djT1oxQHonuk2dMObo6kqWukRmzsG95sdqfGWjmHCcCnwRmHD3NCAjM5OUttFvbLYXGWJfCzsAs7R8OvYSkSd+Sm3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXfn96oD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXfn96oD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59311F00A3A;
	Wed,  9 Sep 2026 13:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961877;
	bh=1h3sP+OqcOjY2EmN+C1DsXbeiPCNoLuROS452FJP4+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXfn96oDvCeccWMT9qfezw4zLxPAx8beK+L1t3Lcpitatzn9/gYH1BJC3kj8R69nb
	 79MXdJJIt6P2BLv+bRThYONi/m9PcS7EV8WzNhUiUxs/eKAmyFM9LP6cE21mWyVIl1
	 3t3Wvrku/xkFjshYjTcT5NHiJk6bv1Q1O0azz+i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 080/556] samples/damon/prcl: stop and free damon ctx when damon_call() fails
Date: Wed,  9 Sep 2026 15:36:00 +0200
Message-ID: <20260909134233.316861341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 samples/damon/prcl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E2E2BE7BA;
	Wed,  9 Sep 2026 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961945; cv=none; b=D0oDY0pulZMaxFONtfwhYUK6oLCELtGzrfZB6k3CZ/cwIyeClmLwqBjAalwb2xrtmmNEJo0tF5hvQqK3ZkSglzA9iUhtXa6q7xgp/QmIvrM9UEBDDd3S6xBDcQ4CdkPlzUcvDY0AbRXMwLi+ppQOwAIOb+Lw3a3I9+xHB6aWniM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961945; c=relaxed/simple;
	bh=S0fv/txc0sgUFYyocYlueBGuCKLGUtK8PRmGd66PsqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3eyEOVSqjmOg9WEmYIbor38k57qM9+sbae6fKpZRMFOn/DHLlSe+vCaP5OMbziu9qyjgD5zONHU6MzvgAK6NPAzkhzM/0/ZXdtDUD3B4YiTzQc5uo9M8SAuls8milVKihXWCTfReSNh1hBCT9YmdKuQjz4XUDceAso8T0wge3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMKUpPUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMKUpPUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CD21F00A3A;
	Wed,  9 Sep 2026 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961943;
	bh=+GTIfO9bN36RldsqsrBdVrMTOLJ15gS3o/zL/bCwE94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMKUpPUU0l0hwmZGxpTVmiLkE8PUjYTR0ACn7brs/ISL/uq+2lA0BTzAzt34QL78r
	 ByomIekVHFFIvxTUMBQyo+vZpZWP+LOmQhfCWFV8tIQKr8BY8dyNKL4XDr7bwJ9jwr
	 eTWWChK/YJSVbu1juVRAJ9mbRd/Prmxbw+ovKraU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 082/556] samples/damon/wsse: stop and free damon ctx when damon_call() fails
Date: Wed,  9 Sep 2026 15:36:02 +0200
Message-ID: <20260909134233.393287961@linuxfoundation.org>
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

commit a2c6fa6c23ad87c61e1379b05dc05cf5fed4bf8d upstream.

damon_sample_wsse_start() calls damon_call() right after damon_start() is
succeeded.  The kdamond that has started by the damon_start() could be
terminated by itself before or in the middle of the damon_call()
execution.  There could be multiple reasons for such a stop including
monitoring target process termination and kdamond_fn() internal memory
allocation failures.  In the case, damon_call() will fail and return an
error without cleaning up the DAMON context object.  The
damon_sample_wsse_start() caller assumes it would clean up the object,
though.  When the user requests to start DAMON again,
damon_sample_wsse_start() is called again, allocates a new DAMON context
object and overwrites the pointer for the previous object.  As a result,
the previous context object is leaked.

Safely stop the kdamond and deallocate the context object when the failure
is returned.  Note that the kdamond should be stopped first, because
damon_call() failure means not complete termination of the kdamond but
only the fact that the termination process has started.

The user impact shouldn't be that significant because the race is not easy
to happen, and only up to one DAMON context object can be leaked per race.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-6-sj@kernel.org
Link: https://lore.kernel.org/20260610034828.4632-1-sj@kernel.org [1]
Fixes: cc9c1b8c205b ("samples/damon/wsse: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/wsse.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -92,7 +92,12 @@ static int damon_sample_wsse_start(void)
 		return err;
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
 
 static void damon_sample_wsse_stop(void)



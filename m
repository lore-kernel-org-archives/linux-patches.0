Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EE42D63F8;
	Mon, 13 Apr 2026 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096323; cv=none; b=k+5+CHSQbQ7hZAPj36kS6FdSoG7GB2Q+9+8kcMvbN0sJZ5vtm8Y719IsbXYKGmNFpi/mhq8qqwXpWtjdmufqUuLRDS1YK2JJD8AEvulJLgqCR3fCOjYZZQNvodBtQZ9Yq2bAh906f84XOHvdmk7fL2e8agV5P5MDBkEVU050xfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096323; c=relaxed/simple;
	bh=rYrOJwHjR3/rFmpeCyVTSVwO+L4PTyxcx1D97NzDiRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fp3+2/2ai9AaSAwnHhtnLW6aJYbmDTZrBb2AvzZpyJuQgEMjyS5Qri6+g7+lv/wZJLn7WQ9+Xo/l4oB4tXGM6Uu9CqAfhWPN8Ov6Pn9VoKfKeiow0jG3wfV+2MmZ+xlfAXukRPjVnvNWeei8N+stMEXlbQgf14f+qpBCiHbWyjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnKAOIXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnKAOIXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E267C2BCB4;
	Mon, 13 Apr 2026 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096323;
	bh=rYrOJwHjR3/rFmpeCyVTSVwO+L4PTyxcx1D97NzDiRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnKAOIXSI2Zyprng0QeyabdLrM1aZfh4bng/9RbVs6igvvimzXbGgSvnClzso1Eri
	 LWZso0n5bU/jLlPuqlTZqDMei9+EV8/6fcIe3TtBnS9A399uam7WwICzSuEZ2PM2G3
	 XFb26XTdJ+X3T2SHsS9mL9KrCjZZ7EAk9S9wtD90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 53/86] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Mon, 13 Apr 2026 18:00:00 +0200
Message-ID: <20260413155733.545126499@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 4c04c6b47c361612b1d70cec8f7a60b1482d1400 upstream.

damon_stat_start() always allocates the module's damon_ctx object
(damon_stat_context).  Meanwhile, if damon_call() in the function fails,
the damon_ctx object is not deallocated.  Hence, if the damon_call() is
failed, and the user writes Y to “enabled” again, the previously
allocated damon_ctx object is leaked.

This cannot simply be fixed by deallocating the damon_ctx object when
damon_call() fails.  That's because damon_call() failure doesn't guarantee
the kdamond main function, which accesses the damon_ctx object, is
completely finished.  In other words, if damon_stat_start() deallocates
the damon_ctx object after damon_call() failure, the not-yet-terminated
kdamond could access the freed memory (use-after-free).

Fix the leak while avoiding the use-after-free by keeping returning
damon_stat_start() without deallocating the damon_ctx object after
damon_call() failure, but deallocating it when the function is invoked
again and the kdamond is completely terminated.  If the kdamond is not yet
terminated, simply return -EAGAIN, as the kdamond will soon be terminated.

The issue was discovered [1] by sashiko.

Link: https://lkml.kernel.org/r/20260402134418.74121-1-sj@kernel.org
Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org [1]
Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/stat.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -253,6 +253,12 @@ static int damon_stat_start(void)
 {
 	int err;
 
+	if (damon_stat_context) {
+		if (damon_is_running(damon_stat_context))
+			return -EAGAIN;
+		damon_destroy_ctx(damon_stat_context);
+	}
+
 	damon_stat_context = damon_stat_build_ctx();
 	if (!damon_stat_context)
 		return -ENOMEM;
@@ -269,6 +275,7 @@ static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
 	damon_destroy_ctx(damon_stat_context);
+	damon_stat_context = NULL;
 }
 
 static int damon_stat_enabled_store(



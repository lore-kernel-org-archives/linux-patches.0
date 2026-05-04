Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD44A3CEB89;
	Mon,  4 May 2026 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903333; cv=none; b=FDrqahOjYM6BOShR7bRPACu+LpQyt1UGBnLt7MUbb6gfsSQlZ8YIuglK3ZNqK9kb0HbS/cOkr633CHH4JsaWx0m2dMnWl2Sjw6N7mt3ikJsQ94mE1+sKvzbuInugJ7ya4p3dFYh5rZdqyDz4qcl4bax1sPaoHR6pcWBeul0Fg8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903333; c=relaxed/simple;
	bh=1fSH49WxJlmNdno7sSg4lXbkfxbIbNEm1WD63DA79IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqzuEjOTMqm2shyZjlDOxN6znjCuiaBIBTQU3VjjUXx2bWwl5LOTBtbx2zxtUvtqdwOKhAj8FbTZ+Aqqxi1FvTy6XQy/h8N/jv19AR8WpXlRm5pt3teIReLerqPekZwkstgZCNow3bvxj3Ci0bLie7TE+/twv5npJHW7tiB8VEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUfaoLSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUfaoLSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52964C2BCB8;
	Mon,  4 May 2026 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903333;
	bh=1fSH49WxJlmNdno7sSg4lXbkfxbIbNEm1WD63DA79IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUfaoLStjezyWoHTUrug2olM8KIDPxaFbp6Bbm2xHkMS/O0Zyqlmu+36CQEyxBJog
	 K1Qt1hY1Hx8qOHf5h6PCYWdAeghbXo9DyBN2ohhP9lAMKb/T/36LT8iS9IiPBp2/rL
	 2TsZ8++KO9rSsOKxRdeq2i7r6KpzDVsJpM+Cz2Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 193/307] mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
Date: Mon,  4 May 2026 15:51:18 +0200
Message-ID: <20260504135150.142077003@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Liu <liuyun01@kylinos.cn>

commit e04ed278d25bf15769800bf6e35c6737f137186f upstream.

Destroy the DAMON context and reset the global pointer when damon_start()
fails.  Otherwise, the context allocated by damon_stat_build_ctx() is
leaked, and the stale damon_stat_context pointer will be overwritten on
the next enable attempt, making the old allocation permanently
unreachable.

Link: https://lore.kernel.org/20260331101553.88422-1-liu.yun@linux.dev
Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/stat.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -255,8 +255,11 @@ static int damon_stat_start(void)
 	if (!damon_stat_context)
 		return -ENOMEM;
 	err = damon_start(&damon_stat_context, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
 		return err;
+	}
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;



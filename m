Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0225F1C68F;
	Mon,  4 May 2026 14:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904134; cv=none; b=kBq1OMYN8biZ0bMg61gU8gEGX6aUahFfxb/eo0VWfvn6tICeF3gC9Y1FpkDSmolEC9n/k18JTeFmG+mUuhIfyma2OW/bzMVoqhOmzIHumzbcBrDVzXtmcReRdvSMyzsWhFsUTL2wYFGnJXqJJdI/KYx6kym6OjxOlclW3J6SVXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904134; c=relaxed/simple;
	bh=QjaODudKDB5mX+q+eHnf3ktulcT+sZ/U0yzMxt6UCSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKrsLljeFaT4OQnMriKv0DCUNnglCKuuPriBBYJQ2ccM6BWzajgmZUu5YhAAkS/9WBbCioc87tQlaW5kd8vnw+i7JAMkm1YU+0/YTb3Vk9FgDPovY7ws400Kt0yS9iGT9G+jeaGJ/0PoZc8Q4Dlp6JiejQu55YONJUcDIHR8EHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3jVcToI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3jVcToI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D133C2BCB8;
	Mon,  4 May 2026 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904133;
	bh=QjaODudKDB5mX+q+eHnf3ktulcT+sZ/U0yzMxt6UCSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3jVcToI/s6fi34w4va3PFv9poUI/HTzdeWtSgbCiGtbQUSR4qUB3SQ51X7m3S9lE
	 pyASjg29C1ZqriLXwmhBzjblfQJA0P6vcxgg/L0gcVYtng/6l8kluwEXeU56gxbQlH
	 P6kILZuDwrZYv7i6dGwz8qNFWWy7IWEwS5wPw0ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 163/275] mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
Date: Mon,  4 May 2026 15:51:43 +0200
Message-ID: <20260504135149.103692514@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -247,8 +247,11 @@ static int damon_stat_start(void)
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EF53909A5;
	Sat, 12 Sep 2026 19:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242991; cv=none; b=h+Y1G6gTYPPu0jUibS18YUUBJoYtUWDMqlh5PJOkeH4Mi+5cQITXLKZvxhDn69TbD74GhVrAVzevC7RGxol66myl4qyRxZQFi+xivohVCS6r9WZ6txRK+MxZvXaoO7tCMBmnuxXVJCsOVCaDyE9OToM+iFkwOh3dy9qBsXb1DsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242991; c=relaxed/simple;
	bh=YIB73XVhzHhc/uNSLIT1AEEqN+RPIPrX3fmx3QgG0QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLZNUlBgNs+CVJqtC4fxRSIHMuqgppBuqXkbWmjaI+HT0cDOh5tGPy3s8UwMlPnLrxKp3vWCw8+YUYo40OwsyGTHLzMGpUka2nGpeAvAeDhbbeV9OGYl44nbFD9U/l91DyT2591/dt9MxoPpr7J43ABBqisV56TSx3W/95z6a1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwGzFrp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwGzFrp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DEB1F000FF;
	Sat, 12 Sep 2026 19:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242990;
	bh=l2ZCQamzW7VqYf0l0+mrTnJXr7l/t/mJlMyMlEPZaq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwGzFrp2fIz426mlsVdOHFxpZPGhudJq7mvxZf2+XQxffXTVqik2CVhPwFtojXop7
	 fsBVgq+aZh5L3RupK1bkvdN39f75fH0NYwZ4AtnK04iiPus/dN6Q8fUEcmetobGTGg
	 lb2xu59F706duo/Jj7KmdHvLemmw9hTZyKILrotE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 596/798] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Sat, 12 Sep 2026 09:03:44 +0200
Message-ID: <20260912065530.784392345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 482fc257de95ab181688e9d1dfcc6b6a58857b1e ]

kyber_timer_fn() sums the per-cpu latency histograms with
for_each_online_cpu().  A CPU that goes offline mid-interval leaves its
bucket un-flushed; the samples are lost from the current decision and
re-appear (stale) when the CPU is onlined again.

Fixes: 6e25cb01ea20 ("kyber: implement improved heuristics")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260720093726.28965-5-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/kyber-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 7f9ef773bf444..db6e6f146ac1e 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -281,7 +281,7 @@ static void kyber_timer_fn(struct timer_list *t)
 	bool bad = false;
 
 	/* Sum all of the per-cpu latency histograms. */
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct kyber_cpu_latency *cpu_latency;
 
 		cpu_latency = per_cpu_ptr(kqd->cpu_latency, cpu);
-- 
2.53.0




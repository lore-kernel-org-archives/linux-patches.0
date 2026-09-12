Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DDC1FBEA6;
	Sat, 12 Sep 2026 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230731; cv=none; b=P4cZOh1pUdzE8rvPn2l/4pHoNp1smaIggLNbVUMtnqWDe7j/gH/kt7/NWC8gOaD9z9ZzABO2dz/KrzF+gNfDiO32S8LaNywjvA15ByVpA2u7UTE41cIWIVv1lquyFV+E1Lyd0e5ZXm59EaCcRX1pJPGsWYtk2nkm/aiir+Kh6Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230731; c=relaxed/simple;
	bh=eMrEhJn5LuW6zhJz9Pp9wGW7jWnmiObOJKhk8ixAikc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K43D/SEMBjt7ZX5nO5Cj0CKz1I1A0EbK5JFec5WBVOuhsmnS39lqvctWTd50EskoNcysNCogFALwYWk1bFV9sQb+kscULeOvtPRnWWw3pBnT0ybFrWKQBKJXaRpOB1BbS9N486r9A+9iDaQmShg6aCybqG5lWdprB8FrByUIWKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vsyAqzLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsyAqzLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6FA1F000FF;
	Sat, 12 Sep 2026 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230729;
	bh=a+WC+OwWalVGuhwq0kYh9UPn6vocigL/ac3bWtdHK1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsyAqzLSvr8ypjCUYd8rJo67xyz82pFzXUI3Vl2KGRPOgeXDyBdCKLdxmpQ17YDyD
	 cFqNjN5al+PPvBQ0Snx1wQpatZT9931jlOe5f4jhmbdriAUQbphvYF4mlF+Ks2oD2Z
	 0kdVGY3zXVGnNKHNlrTAxExf/aFvfuoDNZwFKrr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0854/1191] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Sat, 12 Sep 2026 08:59:42 +0200
Message-ID: <20260912065607.434790786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b05357bced990..dc7d9a6079ec7 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -284,7 +284,7 @@ static void kyber_timer_fn(struct timer_list *t)
 	bool bad = false;
 
 	/* Sum all of the per-cpu latency histograms. */
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct kyber_cpu_latency *cpu_latency;
 
 		cpu_latency = per_cpu_ptr(kqd->cpu_latency, cpu);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0F9369D72;
	Sat, 12 Sep 2026 12:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217141; cv=none; b=NDCLbHbD6dLg20NvmXcchc5AJOdj3UiRB1zg5I0PZgQ9AIHcn61s2zfQh9Al5pAzCU+ineflJZxgoMwkZUtEBYOECphuxFn9v7JS8Kd0qgpKFATpebcRroH5nM4+yx7c8ubmCU/sfFBKWYMeQhHvEFOerVMi1Vd6jmKwW49Qs00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217141; c=relaxed/simple;
	bh=/9KREX0Tu6ItK+tjMN6mQrpcEftssg93bu2B/rYvr1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+QRVOWwsA7xmaIk5RO8gBzyubWa6tRenXo2/a+Gp0p5TgccSvNein/qWkqOIn80ah2QVp/UpVGk/5ApxiVtAbTulVr5lINbg8JLPSAyYsJhlbRa+oYk9YJbUJPui/QISqsKJLLrMRb+vJ8QvE2ISN0H6i3iqNsq0WjY1Puw2TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAAWW0YV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAAWW0YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCC81F000FF;
	Sat, 12 Sep 2026 12:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217140;
	bh=7Tklnr6aRn8xuI/F1+HdWKJwRQt3qCDt0nQqVXYswwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAAWW0YVXmllb0ea4WxKUWcNUkaZoT3YkRB4KfOudktaKh2+isUXOqPcrBlr+1hgL
	 vG2oLaTgWrVrnPfkN3EyfBgY19tP5udbbrIXIqjRzlO5h5To2gD6yNfDhbawF+1KPW
	 iX19ED4O9chMcs3Dn4BbxNsaBFtsDmnLyaEuO6Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0878/1376] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Sat, 12 Sep 2026 08:55:04 +0200
Message-ID: <20260912065627.130752111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ccfefa6a36696..869e83054c48f 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -279,7 +279,7 @@ static void kyber_timer_fn(struct timer_list *t)
 	bool bad = false;
 
 	/* Sum all of the per-cpu latency histograms. */
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct kyber_cpu_latency *cpu_latency;
 
 		cpu_latency = per_cpu_ptr(kqd->cpu_latency, cpu);
-- 
2.53.0




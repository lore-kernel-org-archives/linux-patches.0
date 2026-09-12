Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B240B1F1534;
	Sat, 12 Sep 2026 08:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201625; cv=none; b=AcXxGm96BdXg1zMYJ+HZkvhE2stcbsn4jqlk26Km+OzbA1c4RS/4dGZgXYa9hutGTDFsInYmYnacaq/udoF71/i8b/TDVpe8+Vi3bCnwZ18+FMEkwn26o1csEydoR/7UaWgHkW3EFOcQFqvPiWb81QbuzxwLt622UbcEFSm6GmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201625; c=relaxed/simple;
	bh=L3CcSYhnxqvDGi83T8d6T7hsQUfT9UyyHeMgTs20A10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgS9oFx+5cfgdQch/YMgIlz8QW4EEbKk9SMFrHDBzIpEsZAzbCEozR8Ur1GGs7miY7/+vZo58SNpwncd6/O9aXvILhCwbX2gW4NI7r6GJ7Ai/fZ/DoxAZvuQ5L9fykvD8WUZg3nuHEBYx3aMP8qM8TDwSxWljg1MIGLcsGqRixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2YBoWy8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2YBoWy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83221F000FF;
	Sat, 12 Sep 2026 08:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201624;
	bh=tWacIYpsSE0LLxG3LLu8Y8QH/5YeLEXasuh7StpTnoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2YBoWy8/fo8avSwasNe3GkBlpFvroK19X7gNxxWmb405l5CSSfl0edeZS62EIIUT
	 XK32DRB7qOnQuMuJjw5TkE1ynFLuykEH4s711T9AX55311bSoP6rphnP0JXCNmO3VF
	 ZhJ+qzuT6YVvZpLwjylwJdApMa1Wz0wZsjafLEN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1033/1815] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Sat, 12 Sep 2026 08:46:23 +0200
Message-ID: <20260912065713.270320579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 971818bcdc9db..2ee552ab81351 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -275,7 +275,7 @@ static void kyber_timer_fn(struct timer_list *t)
 	bool bad = false;
 
 	/* Sum all of the per-cpu latency histograms. */
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct kyber_cpu_latency *cpu_latency;
 
 		cpu_latency = per_cpu_ptr(kqd->cpu_latency, cpu);
-- 
2.53.0




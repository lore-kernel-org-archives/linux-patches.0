Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA29634AB14;
	Sat, 12 Sep 2026 10:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209654; cv=none; b=To74qFCG0NK+zyESPV/6E1t9tgsMwyzJz1/7eKBWe5DqseH2DGNtnZL6ep/yF6a7eKXp49qXwsv1Y6a0IdzHvV/AjfPWTLPW59YaGZuZSS2YvAavZ+MCLfzP2P8tumHnhg8TXQfRjavmH8YXJkQYY+xM5Tde2pjuiaRIi6cu1CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209654; c=relaxed/simple;
	bh=JbO8Zt2T5zvgbLHwX+/epv8kiyEkEk7lNiDzWDPVOTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXuJZU1Z/HqaDbMMzDiGKQwJdbH60bgo5wQyJglIgSiuxKfPfxFFNlBw9jIjQG9Q4Txxo/DY0ee6L1M1UGoiVC+NHMdKlsWHZssafwkFTuzGySB0qlkB0Ll/36mzysN1RJub6/KSWXXh4ySmJqz29oqdMU5xNV1PYRC/39M6zbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Y29TM6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Y29TM6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD58E1F000FF;
	Sat, 12 Sep 2026 10:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209653;
	bh=z5z8PoNaqdQLrjBrB93mHkUxUXv9cd9Wc1KljnTZl+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Y29TM6pFMCLG9BRlQDUcKNzNVFh62efq0pzcG/HMF2amlQwptrKMRRO5yS4vDDus
	 DCBw7F83QcggrE1LEBs+1Kl3mRbuDe0GXZ9oaHHOqpC1vynR3vXBF7esa2+T0MGiMC
	 3MmTmiBhug35slwtbMW6XXZ/EXoEg2oIKf9s8jUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0864/1518] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Sat, 12 Sep 2026 08:50:33 +0200
Message-ID: <20260912065642.995454120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index e3eaeea62e24d..927df06e6b940 100644
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




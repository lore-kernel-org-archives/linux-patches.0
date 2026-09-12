Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A85047D959;
	Sat, 12 Sep 2026 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239550; cv=none; b=T62JTLZDHM2lLMYn+Tt1QtWb6aqyjarr5kZIROBblmkCFNm9huHaSLRNm9FVj0oc+evbnxAjM6OsN/X+Br5LI9lSHE04BdhvgrrD2C3zC2uTR9gdG1FAR8Jzrrl2s0BJ9Uo0iVCCrx/ZyqNA317KL8GabYcWxn3VnERFA6VmO2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239550; c=relaxed/simple;
	bh=nKx8NYLKZ6f8fKLrwh5wtRJ+vdgjwXiOKDLMaAVWCmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMlrDw4w+pv2jw7mP2IETEQOiGyXjBobgw0J2BRXn8WzL2P2oWs1J+yMcu4OTUK1I6TBrb9toKoqN28ANxyxHYgZ45BcyYIttt8fAFG62hk0f3KQ3nnC2Deq/rEZzSnri3HTY8cwABy2IuQK8mrm5QW482U9Wk/l+rKklgh3Wlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQstoyPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQstoyPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25F91F000FF;
	Sat, 12 Sep 2026 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239549;
	bh=iqJCUJwlXzEUAQ6BpU0HDQ279hVN7YZjUw4wPVG9NyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQstoyPEc1z0qKS3ksdMnw0t185XvNlLn9BtM4RJKpByWNPpPSOsCbYrrVu5+G4KS
	 /AOZieiltqA6csTCu8mKbfmx/7wpKj07tZ4Mf+X0p+OpSuKi1423GKVG7aItefd/sw
	 Fu8uTLY+cc6WnI1IsAIxbZNNCvp2JJ05UE0qaGSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 688/935] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Sat, 12 Sep 2026 09:01:58 +0200
Message-ID: <20260912065542.620619355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0ffbabfac2c6..51a2eb366a4ec 100644
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




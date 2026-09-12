Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32EB23BD06;
	Sat, 12 Sep 2026 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224653; cv=none; b=FEYHZcnQyRsaDxyA6os+w97B/E1tqojO+juV6YMRaJn5+MUuCXr2IJCPrGSTCitvo0MbjzVmmWiS5EnxQrjiecJBWdsphQ37wFyXoS8qIkBOZmJc+WsiIq/Vz28qhYoAU9iS/Zyzt9iEQ4yXO6p7UTymWnLCmZqSlPIeOesZwIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224653; c=relaxed/simple;
	bh=f5o02x6MAyTT9sQp2rhlPPjUxSdtk//Aj6c8pl+vUlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGHslPkEDDC9wZpqpVXXiAzUzx/gH7AFiVM2oDIBH1DOdWPE2U7/KF0fFV/YVbxiMIT2AqsB9Ra0cH7cCwGT5YdbjMvNBZo1Ne9uAKjylS7la/1F5c37g2fnXauPrQVqdOFUT+akhY/qUV1aCsMUI2IFUY1VI1nhadLQS1MhXW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Txzi1ZeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Txzi1ZeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FB91F000FF;
	Sat, 12 Sep 2026 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224652;
	bh=kBXk2stgBz4h2XGX/SCSIOQ9KgKdbQaYcao0Y8VyX+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Txzi1ZeALBUT1shwJn9Vxzwp8FMGkqILOPmMa6mevBoh7X49gbWDeRaBDOtC8FChJ
	 rM/DDCP5NrEvzjrwYxm3BHLwozWtcVKi4eOvyvpJ0kDhd/RDohMXI3meWTTLaJWi6E
	 kC3re8Az1zQ3OouCtKUBOn31hB+uZyySrIUuyid4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1036/1424] block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
Date: Sat, 12 Sep 2026 08:57:48 +0200
Message-ID: <20260912065630.512079996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4155594aefc65..ec6ff862dc9f1 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -282,7 +282,7 @@ static void kyber_timer_fn(struct timer_list *t)
 	bool bad = false;
 
 	/* Sum all of the per-cpu latency histograms. */
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct kyber_cpu_latency *cpu_latency;
 
 		cpu_latency = per_cpu_ptr(kqd->cpu_latency, cpu);
-- 
2.53.0




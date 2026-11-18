Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048325;
	b=5KWgQF08N8buIOVy0QEL5/ZJmpJmm3XxNar4stjfEjOJ2ChPChIyP4RWPIwWIk282Knq
	 hTAJ2sIECrXVrszWeKu9KWzB9vZaB7gudjnrbahUh4y3l3rfPw52Bzyo7+QceWi0hBghH
	 VsgGPDlbPjxRBAfBPZUaW0e1TQS7jmXPFLgMdhYQYjUcntCr6AfNRn9QAYzjYe5N+iumv
	 RxovwrefDdus8fSaYUZDtlylJ+vPenEqnZ9JTg/bF+V6CyyvUjkS7pwgn8gcwQSQh4K0Z
	 gRVoJQEgKKqeeo2wI4cShgRk4vNy8oHGhmBVhkQxpbx32WBoFV2ag58xF3tlt+5Aadg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rm6HEdxm5HG1kIh2u/0l2C4C7KZx3n++2r9bFqsMfQM=;
	b=T31B6wHaIpJprVN6980ddQN/Hi0zaCtbIlY9CEtfdBJyn1VVEjo6JBlY4kItYfGXZ+Jc
	 yOkQ5+mUmefkGiSaKRgrV6ZnFu3yjNw/yMw2QT+2jBha5EVyjOf2uC3+OtkLotsp8RvmM
	 4wSDpBT6yeMaY8PWpS6AyE7cE2MzUHvLn39Yg7aF0mC5NfP8Bu9T8BgppiduQtBgydWvF
	 NQB0nh9NCkfmF1EtYmaWoCzgdLqIX4P83EU5tSh8XwhQ1kUF9IAKPWfRt2Z+rhXxZE/Mn
	 pnEWojebLThLa/wa3hawafZAsbXcKQsOlkIzmf6BH/Dx6BjiJC9T+2yjfFk8BJw5kpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyyyDtjH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6386D606A339;
	Thu, 19 Nov 2026 00:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyyyDtjH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A471F000CA;
	Thu, 19 Nov 2026 00:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048325;
	bh=Rm6HEdxm5HG1kIh2u/0l2C4C7KZx3n++2r9bFqsMfQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyyyDtjHesAlNbxaBKKotF2hXJhV961pavrk7CYyyuj6FBftgi7m2tIB/gos9hnvm
	 kdiBZGCWx5Fj0KqKMmdQR6dKwuCLQaNHg0tomcYGQcboc/jedfbjXZPq6N4Qi8Pqy9
	 RePR/WWbcHL4FwBxayJ+k++X6aGM/FA7EvcokfX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1955/2857] md/raid10: fix missing wakeup in wait_barrier_nolock
Date: Wed, 18 Nov 2026 15:49:49 +0100
Message-ID: <20261118150311.802788804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit f00eb0ff45793383d5a62db2d2aea63ada0ccdbd ]

Fuzz testing triggered a hung raid10d thread:

INFO: task md0_raid10 blocked for more than 120 seconds.
Call Trace:
 raid10d
 md_thread
 kthread

wait_barrier_nolock() speculatively increments nr_pending. If a
concurrent writer changes resync_lock's sequence, it rolls the count back
with atomic_dec_and_test(). The rollback currently wakes wait_barrier only
when nr_pending reaches zero.

freeze_array() can be waiting for nr_pending == nr_queued + extra while
array_freeze_pending is set. If the rollback changes nr_pending from 2 to
1, the condition becomes true but no wakeup is sent, leaving raid10d
blocked indefinitely.

Also wake wait_barrier when array_freeze_pending is set, matching
allow_barrier().

Fixes: b9b083f9044a ("md/raid10: convert resync_lock to use seqlock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260817033340.418119-3-wozizhi@huawei.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e5d6ad9f9ab09..ce26ef418adee 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1019,7 +1019,8 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 	if (!read_seqretry(&conf->resync_lock, seq))
 		return true;
 
-	if (atomic_dec_and_test(&conf->nr_pending))
+	if (atomic_dec_and_test(&conf->nr_pending) ||
+	    READ_ONCE(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 
 	return false;
-- 
2.53.0




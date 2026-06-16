Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B485533688F;
	Tue, 16 Jun 2026 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626689; cv=none; b=YKLEvgunMno8iREzl0j8rx/HpZAVW8QBBGfeLwXOKaVhMZFtS62JhztT+OPjVqBhIiCYSpFKgLOvda2oC34Xs2qCluO9TYLaRIXcvyPt0znYomKJQUXO1JCXvMBt4zmB5RIZw+dgit7+eMScLILaiDCcPPq27jYGdEVluUBxfEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626689; c=relaxed/simple;
	bh=NvUyY7yBwYBSn+oFTGrB8b7ZNkG5QdMQMYFKd54SDRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FH+5YeEx4GEfDeruCKjdcQ+ExJoxEYKmcgbnVER1nzl5WRoZWdiVWCw9ENTtZ6vNO9gSOYJfeJl0bFfQ/LJM/RDIjGaE9emApbvjyTYaML9+9rEHUeCqD46i8IidfhvtN+yyICEbxkoQ/oHwCl3mXfqF1kPkIm5kxy+Mh+xYP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLvkLXmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLvkLXmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F741F000E9;
	Tue, 16 Jun 2026 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626688;
	bh=9vj9b//IoypIF4jh7uWe0xdspfIOI36uI4lqulgOjb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLvkLXmc3cFh42n6yelXALXVIFMoD7TxXrl8VKxrd0q7TPTWU62yCSzlwBwF8aruU
	 xLvZUnpAyZFmR0Gw9INAFlHZ1XcAIgEUeUd1Wn1XBl3D1w5YSWUZ5aAP7tWomOb5HG
	 0S7rWmxF70OfUixVWPrHIw2v/CoS0KRPYz4EqwN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Zeitz <florian.zeitz@schettke.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/261] ptp: vclock: Switch from RCU to SRCU
Date: Tue, 16 Jun 2026 20:28:08 +0530
Message-ID: <20260616145047.483074723@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 672bd0519e27c357c43b7f8c0d653fce3817d06e ]

The usage of PTP vClocks leads immediately to the following issues with
ptp4l with LOCKDEP and DEBUG_ATOMIC_SLEEP enabled: "BUG: sleeping function
called from invalid context".

ptp_convert_timestamp() acquires a mutex_t within a RCU read section.  This
is illegal, because acquiring a mutex_t can result in voluntary scheduling
request which is not allowed within a RCU read section.

Replace the RCU usage with SRCU where sleeping is allowed.

Reported-by: Florian Zeitz <florian.zeitz@schettke.com>
Closes: https://lore.kernel.org/all/00a8cce8-410e-4038-98af-49be6d93d7bd@schettke.com/
Fixes: 67d93ffc0f3c ("ptp: vclock: use mutex to fix "sleep on atomic" bug")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260529-vclock_rcu-v2-1-02a5531fab92@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_vclock.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 8ed4b85989242f..5e2730c73bc286 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -19,6 +19,8 @@ static DEFINE_SPINLOCK(vclock_hash_lock);
 
 static DEFINE_READ_MOSTLY_HASHTABLE(vclock_hash, 8);
 
+DEFINE_STATIC_SRCU(vclock_srcu);
+
 static void ptp_vclock_hash_add(struct ptp_vclock *vclock)
 {
 	spin_lock(&vclock_hash_lock);
@@ -37,7 +39,7 @@ static void ptp_vclock_hash_del(struct ptp_vclock *vclock)
 
 	spin_unlock(&vclock_hash_lock);
 
-	synchronize_rcu();
+	synchronize_srcu(&vclock_srcu);
 }
 
 static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
@@ -276,14 +278,16 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 {
 	unsigned int hash = vclock_index % HASH_SIZE(vclock_hash);
 	struct ptp_vclock *vclock;
-	u64 ns;
 	u64 vclock_ns = 0;
+	int srcu_idx;
+	u64 ns;
 
 	ns = ktime_to_ns(*hwtstamp);
 
-	rcu_read_lock();
+	srcu_idx = srcu_read_lock(&vclock_srcu);
 
-	hlist_for_each_entry_rcu(vclock, &vclock_hash[hash], vclock_hash_node) {
+	hlist_for_each_entry_srcu(vclock, &vclock_hash[hash], vclock_hash_node,
+				  srcu_read_lock_held(&vclock_srcu)) {
 		if (vclock->clock->index != vclock_index)
 			continue;
 
@@ -294,7 +298,7 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 		break;
 	}
 
-	rcu_read_unlock();
+	srcu_read_unlock(&vclock_srcu, srcu_idx);
 
 	return ns_to_ktime(vclock_ns);
 }
-- 
2.53.0




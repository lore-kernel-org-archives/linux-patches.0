Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D923375C5;
	Tue, 16 Jun 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622947; cv=none; b=AZ0BOjcN1cm/+yBrPl1lfhKUQTx/FBTwXvzHz6Z4WZ02dWQ4SCHYb6Zf/9bEUiwfb3C+0AA2dcP/0I7WGhXcXdRRrj2Yc7G9dTnmgspM4GN09MD3qMKJPQsfXYfbs0zXoePzGoxz/aofL69KPytRwukEwQVbOv4oHhDc3aB4IHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622947; c=relaxed/simple;
	bh=4u+q+iHyIVK72y81Lace1ADNwxJZvlfLlAEbiSvbSGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAA9Z49Mdt6oObzrfxk+9DGx0g358/1oEAJRacgAyzl3UQnCzJ36TwH0UVI9zEqDuxjZhAvAo8AaujCvmp053egR32krKsHnJXDQnb9iWivDRmt77HlEQXPwYtfYny2VywdrCBAlT9O+FvHp+J4MwmYWYGBM1QRUkX58Q0pP2IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YktXFv6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YktXFv6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC011F000E9;
	Tue, 16 Jun 2026 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622946;
	bh=iXTdhdE9CC1Flnwtuoybue6Aoj0f8L43/dkRtNWowpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YktXFv6XRDZdAFJrdgKOf/fcdw6WUdA+SPRQjZC7NGEN+jCtWTV8v7om9/JJF1MlR
	 /cefStmMtShXuecchKlG2nbcXgGs/w4wSJmyFJrpvuEgPcu0Mm7sVNuJtedh7A/O55
	 qT4NTbv6lLdx+9M37rBqlxQb7OyEvSiGyVBCG1vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Zeitz <florian.zeitz@schettke.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 059/378] ptp: vclock: Switch from RCU to SRCU
Date: Tue, 16 Jun 2026 20:24:50 +0530
Message-ID: <20260616145113.088990346@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 915a4f6defc945..84cb527f59ccc6 100644
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




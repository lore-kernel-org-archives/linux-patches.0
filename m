Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04097364024;
	Tue, 16 Jun 2026 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624959; cv=none; b=mALkBPDcMYKMkL9Jk3bpTO8+XZS6TqYtvzNkgdjxcL0BegzYOpIc2XHO0ELTIaqmD8XDLh9HJzrmSBLXSbwM6gEmNDYKkid1zX06d43GCa/X2BUA635jq3qdm5ZJcFzBBgIQj4uVcBds80ZjvmQ8R0zWKwaeZlZRM/0+6qRBYd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624959; c=relaxed/simple;
	bh=ttKy+xCBStkIWPr5F238oXonuklsXYFD4ComUS8DTkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFVBrFiS1sF3ZedIGU2iXkBNdOZYhkUFOxD52/nEdFzaE8F89GdDhG60U3vWS/9pA6rFU6ff/BrfUUKvfMC4ByKOs3Pnaqj9eXHRx+NUgJv3M0su2lUe2YEM+MlmSkfeZY+X5oBzmx/JrRnDoe7jPOGm4n9C2DyRnRc4LCBXvQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUDdn8WC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUDdn8WC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601CA1F000E9;
	Tue, 16 Jun 2026 15:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624956;
	bh=O2HoLgLBcW284sP9d8Tinbx8UDCVo2MjpMgw8TfXTB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUDdn8WCjcmC0DeOp7eo/Kn5Okt7M9WqP/UwSja6EAbOTYGCNJkQew0VSXTQTSj5x
	 Kxc2OzxzRjrERpz6BIM8hu6sRaeg62GVOQr5tGBu6B5PFoJKnVq5cO3Q6woDeOTyBQ
	 IFl4C5rRPm7/1zvEW7pwDWGBgX03AjGKUr0NAieI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Zeitz <florian.zeitz@schettke.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/325] ptp: vclock: Switch from RCU to SRCU
Date: Tue, 16 Jun 2026 20:27:33 +0530
Message-ID: <20260616145100.533501242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index 64c95045651787..295a64bdd846f2 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57008282E1;
	Tue, 12 Aug 2025 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022315; cv=none; b=T727RjSzVgZLUi09APbYsDOdMMwiHMc+5osrxNQX3Z6u7hge2QRJnds56s5BKYNId3iB6a3LNv209GKBmXBnFvdMYrJAorUEKwq2UKXX/dGyq9X6cAaOWNH3c268MHfBQhk1VYl0MaPNbw/atHf1l2XkgrQNv8+NVnG24YZqCck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022315; c=relaxed/simple;
	bh=9wims1xd4F51PdGXEkzeuOChxQHp0eqnWdR6Bj/Jwmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqQ0OeLd4jEu+dglPJTdzB4vyV6XKCYQAuNdSSNWujNtnWpteja7ZIx6tjuH8s4wyrW3ojPxZlMeXiKoS7vWciF3TBTNAr6ThGvNn0L/Pj4AbCH3jGZJD/fcXOTTMl8Iz6nmjwUZg+e3WcTujEAh7Qoccs003ruZPK46fQww6jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Scd3tuon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Scd3tuon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4398C4CEF0;
	Tue, 12 Aug 2025 18:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022315;
	bh=9wims1xd4F51PdGXEkzeuOChxQHp0eqnWdR6Bj/Jwmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Scd3tuon7Uf9Mv+bRVPinDHoq18pSH0frmVYxCVrOg4jo+oukZg6UGugWQUnjeUid
	 J18bNELU4FPYtobnvukm3NPcvknZcqs5Q4ULCxQKSLL64FEUT1NxaWEpTMcbXdwLhv
	 ECbI3dwlqQHO1fZ2OBR1cfppPUItqkKnCJYSP0s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/369] wifi: mac80211: Do not schedule stopped TXQs
Date: Tue, 12 Aug 2025 19:26:57 +0200
Message-ID: <20250812173019.279695711@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexander Wetzel <Alexander@wetzel-home.de>

[ Upstream commit 11e3e22fa533f5d7cf04e32343b05a27eda3c7a5 ]

Ignore TXQs with the flag IEEE80211_TXQ_STOP when scheduling a queue.

The flag is only set after all fragments have been dequeued and won't
allow dequeueing other frames as long as the flag is set.

For drivers using ieee80211_txq_schedule_start() this prevents an
loop trying to push the queued frames while IEEE80211_TXQ_STOP is set:

After setting IEEE80211_TXQ_STOP the driver will call
ieee80211_return_txq(). Which calls __ieee80211_schedule_txq(), detects
that there sill are frames in the queue and immediately restarts the
stopped TXQ. Which can't dequeue any frame and thus starts over the loop.

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Link: https://patch.msgid.link/20250717162547.94582-2-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 00c309e7768e..0386810be520 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4106,7 +4106,9 @@ void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&local->active_txq_lock[txq->ac]);
 
-	has_queue = force || txq_has_queue(txq);
+	has_queue = force ||
+		    (!test_bit(IEEE80211_TXQ_STOP, &txqi->flags) &&
+		     txq_has_queue(txq));
 	if (list_empty(&txqi->schedule_order) &&
 	    (has_queue || ieee80211_txq_keep_active(txqi))) {
 		/* If airtime accounting is active, always enqueue STAs at the
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F1C86331;
	Tue, 12 Aug 2025 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020590; cv=none; b=GACqEYqs76wCl3dH5JB0ajacqoWb55WVrTZavsEH1WQWfkgh8qjUGoetiIZ6cLwCzwNSCuN6+KPpfnSdZLmBSW/vF+JIfo2rCn7NqaEbYILU7pDMpWty4gmbt1cBTYym17ezk3vor2F5nDmD0Ppctapuc98qn6uwCicyWNn0ySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020590; c=relaxed/simple;
	bh=mozfj/P4NyzyGn5Ln4T9sMCAxfAyYS7cap94vpmV5tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+LxO4BThalL+2LtyVYpijHrMdw+OxnRgSksm3EBeDhUlgFtWN9ha/P1WG1XUz73oUw7Ui9vNf7p7GpmdB+s74tq2iXeYUko9EEBQfyAhFmempAH56fAtVqXB990A4d/QyXmzKlJ/LN/ltVS5OrlTrtM/tC+Jgt4FBPGGI55EZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHZv6WEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHZv6WEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7942AC4CEF0;
	Tue, 12 Aug 2025 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020590;
	bh=mozfj/P4NyzyGn5Ln4T9sMCAxfAyYS7cap94vpmV5tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHZv6WEfVk8JIV/3nX7xlV/w3QmWLiaPN2Ttr0hSFgR5EtNBY5NM0Xoqb5twOa/P1
	 g+gs4l2Q9loQE0is8cGBRJRApHYpLsmdStGWRCX/fuBsR9yEZf3GthCxFiRNEHrQX+
	 Qyr+lcLi62KVkXYxA8BtU2X0vBjvajQ2bg/2jFbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/253] wifi: mac80211: Do not schedule stopped TXQs
Date: Tue, 12 Aug 2025 19:28:31 +0200
Message-ID: <20250812172953.935700556@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 62b2817df2ba..a04c7f9b2b0e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4024,7 +4024,9 @@ void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
 
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




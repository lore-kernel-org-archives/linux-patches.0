Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE62FD1AD;
	Tue, 12 Aug 2025 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023983; cv=none; b=Zq7sqOUhzaRSp2gwnN7i46LE+0Vjgi7VtrgsQoPvdcE11loFfFZPf9RHyMS9C69jE3uxPED5I/AVmPckBGnRgTjNoD0lJEzugwwTJZIh0X5IhIRvHgNhRTYPGTVPzChCjhGXF9h8xHGRO0o0W05TFIGjRQcTY/tyBDHDYGBJR6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023983; c=relaxed/simple;
	bh=rB45pbiPqx12ToZplfUAnh/K1Ul1HZU9ijbt6/JqUzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7aOvHjGFDaSZbt0gLyE/NrtEVNbjkkWlrKnvEHXrt1ti2x7US7nPDH3G8TbPPMcISafZqo+09eOGqmKevWIDUunT2lWL+oNPrTPrEc8zaNf/LzclvaS8OssAtC5p7+05F1HeE9rYgCeg0kctEegQ8tzXvTgvLW2CgqNZviNwh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKjAz9EA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKjAz9EA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A28FC4CEF0;
	Tue, 12 Aug 2025 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023981;
	bh=rB45pbiPqx12ToZplfUAnh/K1Ul1HZU9ijbt6/JqUzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKjAz9EA4Gvj61ITF8LNWpECZG9iMfyyz+/w7gc0h94H2l9T6/kzChprgXqUfGKTu
	 3d01QRCOZIr621a4cJDL+OoS1Wp2SmXAB4krqkNzkV2oR5iPWvhuK/3YxYIPmnJe07
	 nrfwJgtyt/oQ8XsgQy3tcIFOiArRySU5zfsQ2kOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 237/627] wifi: mac80211: Do not schedule stopped TXQs
Date: Tue, 12 Aug 2025 19:28:52 +0200
Message-ID: <20250812173428.318247954@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d58b80813bdd..4a9b258300fe 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4098,7 +4098,9 @@ void __ieee80211_schedule_txq(struct ieee80211_hw *hw,
 
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD5F2F83CB;
	Tue, 12 Aug 2025 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021261; cv=none; b=WDKmfrq7+VrjWjKruMv+yb4MavJu68Rc8+EwKbzubPd8pXkyCJoQBnrXgcOpSWSOWtm50mSG2cJ+Vr9Ufyta+IAYuFxjo3fFdOx8GFDnmq/UxZa4mWyQnV4LzvzJy3fQGwUEp7+mn/1IGDTX4lLjvOMVHmVesjIbo2B4RpdRqhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021261; c=relaxed/simple;
	bh=aecPb3V7i963nZQmJ3S0YFVhiccndXmJLfHpbfr7168=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUMINNbDgbk3PWJIEOklwa/wBcVIl4jaxZC/1N2zJB1MFac5HCgTaa+p9PfTOhsTim7d3pEE4VvcNfTvdPV+amTHhHWSvGxjTeHkJHh4YIEFBZNLFuZu6YO3+vZKwJk2bHZANMiBVK+CbUmfseJbtWSOWvPIl/DNOWHlk3/6cR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8zn2oSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8zn2oSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F2DC4CEF0;
	Tue, 12 Aug 2025 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021261;
	bh=aecPb3V7i963nZQmJ3S0YFVhiccndXmJLfHpbfr7168=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8zn2oSRfvF1gFSCba/u9hJYKhnx7ySDIa7y8fgRl50i9zheqlRo1UZwEJ6o0QoLh
	 FvuWXlt9n3uzNVTzcIS8BFNLpL7Vm5zy1sn3I5VwUfCCW99DTIwzu3P7LMtz+NbOiF
	 It6vwBvxWZ8gHnZ/d+dfqA4l9aesflK9Z2odZKpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/262] wifi: mac80211: Dont call fq_flow_idx() for management frames
Date: Tue, 12 Aug 2025 19:27:53 +0200
Message-ID: <20250812172956.663546894@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wetzel <Alexander@wetzel-home.de>

[ Upstream commit cb3bb3d88dfcd177a1050c0a009a3ee147b2e5b9 ]

skb_get_hash() can only be used when the skb is linked to a netdev
device.

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Fixes: 73bc9e0af594 ("mac80211: don't apply flow control on management frames")
Link: https://patch.msgid.link/20250717162547.94582-3-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bdf7c7ca5654..f54792c4b910 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1451,7 +1451,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 {
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
-	u32 flow_idx = fq_flow_idx(fq, skb);
+	u32 flow_idx;
 
 	ieee80211_set_skb_enqueue_time(skb);
 
@@ -1467,6 +1467,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 		__skb_queue_tail(&txqi->frags, skb);
 	} else {
+		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
 	}
-- 
2.39.5




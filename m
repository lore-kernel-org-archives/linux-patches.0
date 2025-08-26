Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F34086A;
	Tue, 26 Aug 2025 13:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215765; cv=none; b=sM24nbFlOG2ILlTFZbPmTbUMtCHts7wsnFQyV2zy0wEJaAUBJVqHbfVzQO/kgRPFc+KEDnGXUfowKSxwOeGFLQOqfFWJwsItDiEPjv6oNZPtUkdiFMqMn10HvIgoxhI0gx9Nivbc/Qe6JuGGwVHwWSS3A1FswXoVOEoQWoFW380=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215765; c=relaxed/simple;
	bh=l0ZzD72cVz0F/qoNgSsVxKUhtECL9U78bSflcosEuLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGHpoYaXTrLHfRwpcDiX+vgf9H2Wfs1MCCReYOpmk9wAJBGpoXyZyjkTtBwF31dUplL62zT2uYTTF4uv50zRUjhXP6Nk+nSSVxH9iHtPdxOkwvUAvCO9itdrARORcsnRI2e8rNGC5j10U6dvRmfFvxj25ChxBfR0yBR1sBotQcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GM9fN3db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GM9fN3db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135DBC113CF;
	Tue, 26 Aug 2025 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215765;
	bh=l0ZzD72cVz0F/qoNgSsVxKUhtECL9U78bSflcosEuLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GM9fN3db3dfO7ZoM1DFakYYTueYgJzQEjqXsw7KZG2M1MuGBT1W7ww8//MbYNEgQS
	 hOc1ptkFuha3ETePOueLZeNtrGDhpO5tueM3PdphB5b/+6wVrdXj+A/BfcOtnA7vzV
	 xadc1yKNANkNaxWoI4r5HTcBhDyT69A7RXVHHjpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/644] wifi: mac80211: Dont call fq_flow_idx() for management frames
Date: Tue, 26 Aug 2025 13:04:07 +0200
Message-ID: <20250826110950.345048565@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c4e6fbe4343e..4f2183f23117 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1417,7 +1417,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 {
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
-	u32 flow_idx = fq_flow_idx(fq, skb);
+	u32 flow_idx;
 
 	ieee80211_set_skb_enqueue_time(skb);
 
@@ -1433,6 +1433,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 		__skb_queue_tail(&txqi->frags, skb);
 	} else {
+		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
 	}
-- 
2.39.5




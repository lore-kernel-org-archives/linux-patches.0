Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1BC2FDC33;
	Tue, 12 Aug 2025 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024122; cv=none; b=UbRVeEE+6ZT08G4s+qvQD96HZhRPbwB1KfnmOilxPpjLh3sysHN47F765osii5vij/wCRAMQX1ESpkZnb/6ULh6n3mnADSdjIxCat0MHV4yEYuTsCVeQiwGFoXav8GvulRtyY/b9N6cNdDm1IfgdRo0zJnjFl4LY91Mdq1gz1q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024122; c=relaxed/simple;
	bh=Yj/Zg5h6xqQZFYghPPk/W0UzUyWx72sOrmlZsgANgXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM7/gfVeee5WM6h1KYDxZEDo0YT2YyKCT7jSV9lWxnbU00/5p4aVr2JSJZmaIs4cUUWYVPu9VCIbqIrmyIAM+PUGfKfSOHe7JL5ThhvCn3biGDWWJNAHSspW7ipq/ZMYHr0J6ch7S4AohhR3nVaP0aaSp1L6lvZlOKMpcW5vFpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmNZWyDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmNZWyDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBC0C4CEF6;
	Tue, 12 Aug 2025 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024122;
	bh=Yj/Zg5h6xqQZFYghPPk/W0UzUyWx72sOrmlZsgANgXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmNZWyDt+S02IK/RxIU1szDQZ8KRKE7/i87sBcnSZ6lXtN/ZU+mBWWd2oXxa+03mj
	 dZvCi/MSMsLiBQmS9+Pe2Nle8fQwvBqD87Q3ENwkGbYSvBiDsmSAkP3shekL96ojn2
	 2EhRKbotTjZTzcaHabrBjOH3yqMiAuEmnXY68flc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 238/627] wifi: mac80211: Dont call fq_flow_idx() for management frames
Date: Tue, 12 Aug 2025 19:28:53 +0200
Message-ID: <20250812173428.356339935@linuxfoundation.org>
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
index 4a9b258300fe..04f4d574401f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1428,7 +1428,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 {
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
-	u32 flow_idx = fq_flow_idx(fq, skb);
+	u32 flow_idx;
 
 	ieee80211_set_skb_enqueue_time(skb);
 
@@ -1444,6 +1444,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 		__skb_queue_tail(&txqi->frags, skb);
 	} else {
+		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
 	}
-- 
2.39.5




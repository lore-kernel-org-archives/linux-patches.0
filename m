Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B9A2FD1CE;
	Tue, 12 Aug 2025 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020593; cv=none; b=KQs19ub4oPP7xvmUgJ89Rad6tSbhrj6rw4Drlc/zuJLZ+R55heTK1AkcFRQTvLUkpaxOnBr42Ze5nJ3/oq2XoJ2tVHG8iHGz8djxu5bj8umXQN2c/LoJXylPdN4I8RsYeRaJBOsPEfG3oNP7vebX12nFjgVNQrjHLk7w0V7Bqik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020593; c=relaxed/simple;
	bh=Vh5tG46W531W0Iz+dnGmQm2Fb3pLWMPtUndnPH+62Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoVfpsyhKzDyxj7gsdxoRh+aSmh2oMzwFotVWXuhRkRuDY8SZNAWhwvAhAxFc4YLuIt9wup5aK0ETWW0KrPgwzpgGtsNhRkqkrOn+pt+sahQNtHZmRNE/26v3J8rut5lZkCMM9W3UDUywF0Vl7SolkVawqYsNTYQIMjzDC/JQHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnlxLNQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnlxLNQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DDBC4CEF1;
	Tue, 12 Aug 2025 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020593;
	bh=Vh5tG46W531W0Iz+dnGmQm2Fb3pLWMPtUndnPH+62Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnlxLNQbq0/HhGul7xc7OqgFDezWHdjQvky6bW1DYdCtrG5iErwJPCFydLd/kLS6G
	 vyh4IJiCxwOUnHmytpf9PgGWjI7Z1SN/4uQx9oGiHgotkzf61L7p2LivQsAnwNx27I
	 nNo8P6Z99XsYRBR0vYF1y/x69QkPJr3WmZOKd6BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/253] wifi: mac80211: Dont call fq_flow_idx() for management frames
Date: Tue, 12 Aug 2025 19:28:32 +0200
Message-ID: <20250812172953.976519179@linuxfoundation.org>
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
index a04c7f9b2b0e..fe47674b83b6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1467,7 +1467,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 {
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
-	u32 flow_idx = fq_flow_idx(fq, skb);
+	u32 flow_idx;
 
 	ieee80211_set_skb_enqueue_time(skb);
 
@@ -1483,6 +1483,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			IEEE80211_TX_INTCFL_NEED_TXPROCESSING;
 		__skb_queue_tail(&txqi->frags, skb);
 	} else {
+		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
 	}
-- 
2.39.5




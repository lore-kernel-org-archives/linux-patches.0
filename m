Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE75113FD94;
	Thu, 11 Apr 2024 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830950; cv=none; b=oEtdYFgN4+V+SDMqpt2knLSXyX3zRnRaNCv3oGBrb9jwT77vDGaKrWm68UD30VLk952ERJtBgVAgWfORx9Jq+f2or3gUuXAg7rMgvUf2beNyeYyqr92eyPIQWLhXtJh4/y+iN1QvWo8UHjoSe6EYBh4jWC+MauZi9m5Y3EkHmbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830950; c=relaxed/simple;
	bh=6fGe/fLzT/3X4GzW24af7BMNoEemEt7gGL9+rkLJg7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIw98IwtXsUy1Nfxl24ACsOxY7+zMfRITIA27WgvFk3Pt4FZMIQ7Yrzpy98C+zSPi9lbwFxBRwMtkUJQVO4tsUWj6o1IiL1xTeJJA4b3+Nf5lE7qGsPXb4X7UGMYjrgSazgvsvHYsVgBCfG9SGZCv37h15OwnYgt0wKmcET+ALM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGOI/o9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGOI/o9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A422C433C7;
	Thu, 11 Apr 2024 10:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830950;
	bh=6fGe/fLzT/3X4GzW24af7BMNoEemEt7gGL9+rkLJg7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGOI/o9kH5ZCjrVYnqYFl8oHmeUVnKFwbrG0qNwsiylNM5gYLbcAFLNA6CKPR3Z5O
	 NzrL78SIMbBPLipiKIuS0AOp7+7q1tWD92k49k9rKJrkwgaAAIe0q7LdRNpYWsIOIj
	 VpRB+V7SBNaejXu4QYhsWQtvwBJNAKg4fmn3bVqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/215] batman-adv: Return directly after a failed batadv_dat_select_candidates() in batadv_dat_forward_data()
Date: Thu, 11 Apr 2024 11:56:22 +0200
Message-ID: <20240411095430.071783919@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit ffc15626c861f811f9778914be004fcf43810a91 ]

The kfree() function was called in one case by
the batadv_dat_forward_data() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

* Thus return directly after a batadv_dat_select_candidates() call failed
  at the beginning.

* Delete the label “out” which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index dda62dcd59c8a..c5b7e9994a018 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -682,7 +682,7 @@ static bool batadv_dat_forward_data(struct batadv_priv *bat_priv,
 
 	cand = batadv_dat_select_candidates(bat_priv, ip, vid);
 	if (!cand)
-		goto out;
+		return ret;
 
 	batadv_dbg(BATADV_DBG_DAT, bat_priv, "DHT_SEND for %pI4\n", &ip);
 
@@ -726,7 +726,6 @@ static bool batadv_dat_forward_data(struct batadv_priv *bat_priv,
 		batadv_orig_node_put(cand[i].orig_node);
 	}
 
-out:
 	kfree(cand);
 	return ret;
 }
-- 
2.43.0




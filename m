Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C80359FB0;
	Fri,  9 Jan 2026 11:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959743; cv=none; b=sPQIzUZDfOJ/RjQcQ5/tYyM1e7/pma3cqBd32sgWCypdV/nPiS9M/wtZpxfeswu+BmKYYERObbeU8Q6Qxt4Q+1sPoZysvYKTPNSN0zpcUwrszAKyvtCzG+8njOAnpzHCzLbZDhWgdwz5Vlwx8SVarqrWsDWYsagxPIrZrCcoBWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959743; c=relaxed/simple;
	bh=2SAmvGCB4fMPuaK8wZ4so5LAP5wDzbDsyo8D5NuedZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuxzf0UawpUe6cJTdfgJ15rrU3fwrSRxy5sepO/p/1iR/YNZH9ZhieX5X4npqbhCZaH7V+g3V9hhx2sTvImxPb4ffaeNJdBWTmKOHy/DJaOBv5W++piG+JdawfemOzJRX6eHoKN7mxjADnCK+FGT6v4xZrelL9PzJ1hFUu3+dw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nPFt0lY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nPFt0lY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47A5C4CEF1;
	Fri,  9 Jan 2026 11:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959743;
	bh=2SAmvGCB4fMPuaK8wZ4so5LAP5wDzbDsyo8D5NuedZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nPFt0lYP4rWB8eN78DPb2hpooV4KVrfb+d084vEk94xmxW1xhpUNUs6D7QgrEIrt
	 l+/o510Vf+aNaMjUiFO27ETsZ51DVv28hTUUbGrHyxE3/uHpQnsQzwB3SjatTbQwgc
	 PnbvXWH5S36NO08XkMfO0nmaJacpsTXohtFKJE4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/737] wifi: cw1200: Fix potential memory leak in cw1200_bh_rx_helper()
Date: Fri,  9 Jan 2026 12:34:41 +0100
Message-ID: <20260109112139.341163768@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 5e88e864118c20e63a1571d0ff0a152e5d684959 ]

In one of the error paths, the memory allocated for skb_rx is not freed.
Fix that by freeing it before returning.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251110175316.106591-1-nihaal@cse.iitm.ac.in
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/bh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/st/cw1200/bh.c
index 3b4ded2ac801c..37232ee220375 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -317,10 +317,12 @@ static int cw1200_bh_rx_helper(struct cw1200_common *priv,
 
 	if (wsm_id & 0x0400) {
 		int rc = wsm_release_tx_buffer(priv, 1);
-		if (WARN_ON(rc < 0))
+		if (WARN_ON(rc < 0)) {
+			dev_kfree_skb(skb_rx);
 			return rc;
-		else if (rc > 0)
+		} else if (rc > 0) {
 			*tx = 1;
+		}
 	}
 
 	/* cw1200_wsm_rx takes care on SKB livetime */
-- 
2.51.0




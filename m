Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7C31DF981;
	Tue,  3 Dec 2024 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240841; cv=none; b=V0l7GkL2i04sF5cX/U9fp0ww0dWf5LAojuMpjK8BOvyAb00S+uShJoHCqKQbKUe38ZAv7oCvKgmrGgXpI9epNKPofAbtmShxTxseLcQvwBeyFk+/1RvE7aP8ub699ORUw3UPzue0/Lg8siRVYarXQobYZm//abz5+keP+gZZAhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240841; c=relaxed/simple;
	bh=xl+Gg2xJoe5gpvE0yMLtV2Gy3UUpSCezwgbA24qeKLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4/7qNcVSJETm0r8CQLxbtZZ2PXxtHz8yMogF3nHu/is1FXG8eKCgZMAEYhCv/BnQMudYNBd17IS4kt+jzXPKEVSSGY7h4YLBHqzW48pAy4rYbRB7yeTbf2BGCRqEfuXtkVrnRdtBqPgCIvqjGr6Y3qlvbvR187F4xYpXRU+U3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/Q12Bgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/Q12Bgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993AFC4CECF;
	Tue,  3 Dec 2024 15:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240841;
	bh=xl+Gg2xJoe5gpvE0yMLtV2Gy3UUpSCezwgbA24qeKLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/Q12Bgf9TLPD2EIlqmYBZT+KSTJfGeyHeQgVh/20G++1xQ1ZrbxJ1ya1QHSwZWAW
	 geKfrLtTDM5uYYsXt+Y3oQsivE3uIAju3nfFbxDI5vz7Koa/WXK+GZ34n4SgAQ9IDG
	 n1yqzFu2W87PguT0GrZI8dueszU9DMvIDkRV4ZNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 251/826] wifi: mwifiex: add missing locking for cfg80211 calls
Date: Tue,  3 Dec 2024 15:39:38 +0100
Message-ID: <20241203144753.558250028@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 0d7c2194f17c764df0354af13551cc6f92ef5a44 ]

cfg80211_rx_assoc_resp() and cfg80211_rx_mlme_mgmt() need to be called
with the wiphy locked, so lock it before calling these functions.

Fixes: 36995892c271 ("wifi: mwifiex: add host mlme for client mode")
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240918-mwifiex-cleanup-1-v2-1-2d0597187d3c@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 2 ++
 drivers/net/wireless/marvell/mwifiex/util.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 1cff001bdc514..b30ed321c6251 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -938,8 +938,10 @@ void mwifiex_process_assoc_resp(struct mwifiex_adapter *adapter)
 		assoc_resp.links[0].bss = priv->req_bss;
 		assoc_resp.buf = priv->assoc_rsp_buf;
 		assoc_resp.len = priv->assoc_rsp_size;
+		wiphy_lock(priv->wdev.wiphy);
 		cfg80211_rx_assoc_resp(priv->netdev,
 				       &assoc_resp);
+		wiphy_unlock(priv->wdev.wiphy);
 		priv->assoc_rsp_size = 0;
 	}
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 42c04bf858da3..1f1f6280a0f25 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -494,7 +494,9 @@ mwifiex_process_mgmt_packet(struct mwifiex_private *priv,
 			}
 		}
 
+		wiphy_lock(priv->wdev.wiphy);
 		cfg80211_rx_mlme_mgmt(priv->netdev, skb->data, pkt_len);
+		wiphy_unlock(priv->wdev.wiphy);
 	}
 
 	if (priv->adapter->host_mlme_enabled &&
-- 
2.43.0




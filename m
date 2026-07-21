Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4120B47010D;
	Tue, 21 Jul 2026 20:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664244; cv=none; b=TuUVUi8sYK/9RTLThcSN4E2H0WKXgvpBVrXZnzFrbfrxAAXQecVaIsQMTvC0K2kj3CZTHKnA1DmGbflZmqBTWfEZyaGXQ1Ovu/zuTkF/65t5NjlEgRNrxk/b/5IGAvaNis7jKY7WSuu5bIpFGEaKLjCe9VVvaG4A/SOPVPEt6rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664244; c=relaxed/simple;
	bh=gWYVIppROggCZ9GSJ38Xcf88E7514qSqH79vwGVEtt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohYipgNPOuhhwu6zoj1QrUcY7Rc5F2/x3zaLALi+d2yiyCdt/wYdlTTQCgzkEvMNEyJvw4v9kmKUqQgIRegM6aQiq92J+E2Ru6ty9GRJGdFBhsHZeb3XEZmBqeT4skajwI3WOCjRYyfifbMIGArUD5uobV7CfMNwKXenzR8mPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ab8zW94J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ab8zW94J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47E81F000E9;
	Tue, 21 Jul 2026 20:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664239;
	bh=IJVXTBk8bzD6+Koocg5nTAxVfBNpHxCKM+4pJmeqgJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ab8zW94JanXC1pgUKwFDwbvqzILgfe6Zmrd6N5UyUOBPgKBgL+ACC4hcE0GcnkWdw
	 ZJRAnUq3iTvBK/aL5u9gu6buBzuYJUlHLtZ/lzba5zWk+7hLT9KIi8DVtN4Zx+wf1L
	 jGpDoTeYZcOo+MHAP4BT1wUxudxPPoGIXDt53sa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Beims <rafael.beims@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 1108/1276] wifi: mwifiex: fix roaming to different channel in host_mlme mode
Date: Tue, 21 Jul 2026 17:25:51 +0200
Message-ID: <20260721152510.785622378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Beims <rafael.beims@toradex.com>

commit a707e4127c0f893c7a7703500ab56297a5bd2d51 upstream.

When host MLME is enabled, mwifiex_cfg80211_authenticate() transmits the
authentication frame on a remain-on-channel (ROC) reservation so that the
frame is sent on the target BSS's channel. The ROC is only configured
when priv->auth_flag is zero.

priv->auth_flag is set to HOST_MLME_AUTH_PENDING when the auth frame is
queued and advances to HOST_MLME_AUTH_DONE once authentication
completes. It is only cleared back to zero on a disconnect, deauth or
timeout path; nothing clears it when an association succeeds. It therefore
stays at HOST_MLME_AUTH_DONE for the whole connected session.

When the station later roams to a BSS on a different channel, the next
authentication finds auth_flag != 0, skips the ROC setup, and the auth
frame is transmitted on the currently-associated channel instead of the
target's channel. Authentication times out on the new AP and the device
stays connected to the original AP.

Gate the ROC setup on HOST_MLME_AUTH_PENDING instead of on auth_flag
being completely clear. This re-arms the remain-on-channel for every new
authentication attempt, while still suppressing a redundant ROC during
the multi-frame SAE exchange, where auth_flag stays PENDING between the
commit and confirm frames.

This change was tested in 3 different devices:
Verdin AM62 (IW412 SD-UART) - (16.92.21.p142)
Verdin iMX8MM (W8997 SD-SD) - (16.68.1.p197)
Verdin iMX8MP (W8997 SD-UART) - (16.92.21.p137)

There following loop tests were performed:
1) force roaming between two AP's, one 5GHz and one 2.4GHz, same
SSID. Use wpa_cli to trigger the roaming behavior, sleep 2s
between iterations.
2) force a disconnection to AP 1 and a connection to AP 2, test
scan. Use wpa_cli to trigger the connection changes, sleep 2s
between iterations.

Each test ran in each device for at least 3 hours.

Fixes: 36995892c271 ("wifi: mwifiex: add host mlme for client mode")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Rafael Beims <rafael.beims@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260610150021.1018611-1-rafael@beims.me
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4333,7 +4333,7 @@ mwifiex_cfg80211_authenticate(struct wip
 		return -EOPNOTSUPP;
 	}
 
-	if (!priv->auth_flag) {
+	if (!(priv->auth_flag & HOST_MLME_AUTH_PENDING)) {
 		ret = mwifiex_remain_on_chan_cfg(priv, HostCmd_ACT_GEN_SET,
 						 req->bss->channel,
 						 AUTH_TX_DEFAULT_WAIT_TIME);



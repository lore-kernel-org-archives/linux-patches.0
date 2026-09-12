Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38541C5799;
	Sat, 12 Sep 2026 18:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239438; cv=none; b=FtgGxejQDeuiDRjKyJbk9JOWgNW8h9Rb1w4mobv6V0LvKT2f21nU9IVi6GFNPbXJeF9JSmHwvPfwpXGiEcQG5Wbg2oInMCTwE16IavgA37fHAtut2zEOiZretHSOuff3PZVJeC9UJFWxXcnAKYSywJ6j2YkLy/B0h+Q8j0v/E18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239438; c=relaxed/simple;
	bh=a1dU8NGvakKpjPhWFtAmDxoqr5xpfK1Xp0ePhD/m4hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcsHv7b7IaamjA/p55f++O9KfTWKQ/RfrbOr9NN35HmAfLVxfD91xLlbhBypMiosUO6GmVlagkMf3oNzQ7LARekBDRZcAD6VRbLmv56atO4LRmohiioQ+ej0nkAaaObxJcHB7I3nF1A1jDKqILcNZrplBcnBNkVhfnaeS4IfxaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj2sIS7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj2sIS7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8AB1F000FF;
	Sat, 12 Sep 2026 18:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239436;
	bh=fOLB3Td++N20ctiqvnNpkqNPxyCheSsXjFWl+PO8zl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rj2sIS7QjX6iO/nYCw93dGmLX0i60FViKQmNwI+as5aeHjnIidhkE1xHZ3GRHt9Hh
	 OE/YNyVxI+nCXQ3W8AKzTneAiRmGok8Z119gVgIcKL1ZnsnXjbORTio8iY+oONZkK8
	 wmWPmRUuO61Uzw5jG/c/RU7qqslI369d7aATwFvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 663/935] wifi: mac80211: send TWT teardown to peer after setup TX failure
Date: Sat, 12 Sep 2026 09:01:33 +0200
Message-ID: <20260912065542.046739543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit a28fcce6ee74be8a4526e6cfa16dc7786d62a784 ]

When an AP's TWT Setup response is not acknowledged,
ieee80211_s1g_tx_twt_setup_fail() asks the driver to tear down the local
agreement and sends a TWT teardown action as the peer notification. It
uses the response SA as the destination, but
ieee80211_s1g_send_twt_setup() built that response with SA set to the
AP's address. The teardown is therefore queued with DA, SA and BSSID all
set to the AP address and never reaches the station.

The in-tree driver callbacks update local hardware state and emit no
action frame. The station receives no notification that mac80211 asked
the driver to remove the agreement and can keep following the TWT
schedule, leaving the peers' power-save state desynchronized.

Address the teardown to the response DA, the station to which the failed
response was sent. This also matches the station lookup the transmit
status path already performs on the same frame.

Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260729173607.13340-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/s1g.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index e41fd43f6a6ec..a5258ea4c956a 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -146,7 +146,7 @@ ieee80211_s1g_tx_twt_setup_fail(struct ieee80211_sub_if_data *sdata,
 
 	drv_twt_teardown_request(sdata->local, sdata, &sta->sta, flowid);
 
-	ieee80211_s1g_send_twt_teardown(sdata, mgmt->sa, sdata->vif.addr,
+	ieee80211_s1g_send_twt_teardown(sdata, mgmt->da, sdata->vif.addr,
 					flowid);
 }
 
-- 
2.53.0




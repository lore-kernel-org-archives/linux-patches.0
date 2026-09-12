Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47EA23BD06;
	Sat, 12 Sep 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224707; cv=none; b=R4Dc+lewnoCoRafEC7Nx6e2ualqHC9UI23vZxfeb1OHRD74H18Usfc775FMdd5SIqCKs1H+0r48cXsVI83Dag5eEMeptmsz0NgrDKEkIN7Fu9qxJA061/7yF3sul0uAHiIAN2qqEEwcjy9wjvwAoX4gsfsG+OSwMWDuzmlKYy3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224707; c=relaxed/simple;
	bh=ol7uaowQjjoXOk/QojHl7tb+PQ7iB3ptW5Z70IRWneI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGmLfcWqPYMhIeu5A05cvvWaLXhywZiGJBrQ0eX4wMKau1xIO2ivfGrERuG/wvFEAVi0slUPBEpL7oEx+I3MX0lhcAqfGdZ4oemM0dF7K+TgxtC6igwg8SNUckfZ5pyl19BMaw2T0c1jQyh4/OIY+fS5oCmlD0OU5WiCs3khhZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7C6ODKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7C6ODKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401E21F000FF;
	Sat, 12 Sep 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224706;
	bh=RkUsDiDMfw3k8cUP1qQNYUEc2hJR1QaLZUgGBs5Gz64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7C6ODKAgO28Ifr5oe+X0y+COk306WTQMPsfLrtPZf3AVV4pURYE6YttF4iPnJ9av
	 na4IPaSZmpRtpdPcBGPEnP/0ADcsqOZgzy7WkxrhYM0zJ65eGhv1BTOXYmMWo0JGrB
	 sw4nauQJPpEz2ZuAxjquHgDQE/ZbJ0mw4k9HR+jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1005/1424] wifi: mac80211: send TWT teardown to peer after setup TX failure
Date: Sat, 12 Sep 2026 08:57:17 +0200
Message-ID: <20260912065629.818439197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 9914390ff31ff..337d8d4ea5f57 100644
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




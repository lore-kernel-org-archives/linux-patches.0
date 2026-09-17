Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5342F4B44C4;
	Thu, 17 Sep 2026 16:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661100; cv=none; b=rRyhaIzN7o+LbBncrncwNBHz67Hh99OvweMcc0chkLZGpb4zSIChvfZVY7vkXeo/JMUYTuTBIlikK6U/ES8x+qJIzAtDz+qwPyKeJNLEj8MrcNQwTviqnUEzvmwI4rdTzhCFfK2sZrGgWAxaWgUQgYC/iE4LA2WGa24teI9sx9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661100; c=relaxed/simple;
	bh=vmh3nO0eqSqW/ujXfsRp2luGJYJvwQrVvsQj57I4lXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kj3hrbz0C+6dlJZX4zEvmvgNKnsFt/34mw0Ogykd2EQ7Jn/ZuSMPVNFlRyV1Mntj+e+GVS298Rt+KQYYqpLL0jWr1LOfgRniOKwea6ywTb9XxpxNF8TJUxDwSOJKrAG054Y9DYDpqtXRJuHzo1jC1R88qBVHC7aG+6tiw1wxOq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMd/xruc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMd/xruc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672F91F00893;
	Thu, 17 Sep 2026 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661099;
	bh=R5ywd3LLH9oqQN6AUggk8sp6HiMUpflLMsuvsvVBqPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMd/xrucirkbn38DtG9Yg/3jRYD1AsABpwVC7qWs8QhKnSMzyRUY4wnPyj71PokLk
	 XI5Puk8IAubEkGhs44KFzw1wKjcFV4A1pvhAJPt22XO1jVh8Bz5PajEt9COHeG8Tzj
	 mYb4V89vNxhl+WBw+R9gT2XWJZL/Jf4Z3TuFsHIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0031/1250] wifi: mac80211: always allow transmitting null-data on TXQs
Date: Thu, 17 Sep 2026 15:57:06 +0100
Message-ID: <20260917151552.775341037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 51129a2ca0482b006d0e12a0aa025ff1e1cad2cb ]

Jouni reported that certain sequences of tests caused some
WDS tests to fail after applying the upcoming hwsim changes
for NAN. I bisected that down to converting hwsim to TXQs,
and after a long debug session found that the 4-addr NDP was
getting dropped, because it goes out via a (management) TXQ
and is a data frame.

It's unclear to me now why this only happens in some test
sequences (e.g. "sigma_dut_sae_h2e_ap_loop ap_wds_sta" and
"sigma_dut_eap_ttls_all_akm_suites ap_wds_sta_open"), maybe
that affects timing and the frame is otherwise delayed in
some way.

Correct the check to only drop frames that actually carry
data, not NDPs.

Reported-by: Jouni Malinen <j@w1.fi>
Link: https://patch.msgid.link/20260417141601.851ddf4adb59.I3d668c0e1bdca9cd98f2fc46f84a066e68cc7a62@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 89eb340e982b2..e7df1a0c85911 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3895,7 +3895,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		 * injected frames or EAPOL frames from the local station.
 		 */
 		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-			     ieee80211_is_data(hdr->frame_control) &&
+			     ieee80211_is_data_present(hdr->frame_control) &&
 			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F5C28312F;
	Mon,  9 Feb 2026 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648877; cv=none; b=YaRR6sLDc17/8XonKJJhWDXQp4Kw8rOY3KdeDAYyMzFpjOITtd0lqvbbdyLWt43qF7fevB72mxpBTZ9l1P1A/fN/STBxp4unLmd5nQZaB89b5FGaJ42pVCzPScJfkOfI4DDx8dMZ8wCVDO2g0UkEYLCBPxfmkBCpt4kARHvPZFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648877; c=relaxed/simple;
	bh=KMfzxeXmoOJiaFFl/0BQ8evQWorhxDuceZqe4Vw7KNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgCpqB/ULtbZ8obwapIKfxGHZkQ6s4kaNbLn8o5XDKpsISdA3IU8LyZmZY3p8PxYBIK0buW5p9makLRpVjzRPP50Gg2dywT+GtZcL963cjsPuLepXUA6eBGT/N2XYRFfNGeNvngE5gkZcCK2Ib4Na329sffoM1sjy1nLListsJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yf/yA9Uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yf/yA9Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D387C116C6;
	Mon,  9 Feb 2026 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648876;
	bh=KMfzxeXmoOJiaFFl/0BQ8evQWorhxDuceZqe4Vw7KNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf/yA9UcARNBLofXkqQvGKlJrd+OEUtUK7k33ATjmjSw82Ypbhmq7w7gcRVeJwE6e
	 GnEKkqub12UmhT9zjWs/gMojA/8TmyqMie49tENXQ0tatJHKUSyY/RlAxSPt551pEL
	 kDQTWS17DYyD9YYhMZoNB6UfKVEL/4jZeQm1+3fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/75] wifi: mac80211: ocb: skip rx_no_sta when interface is not joined
Date: Mon,  9 Feb 2026 15:24:21 +0100
Message-ID: <20260209142302.716570300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit ff4071c60018a668249dc6a2df7d16330543540e ]

ieee80211_ocb_rx_no_sta() assumes a valid channel context, which is only
present after JOIN_OCB.

RX may run before JOIN_OCB is executed, in which case the OCB interface
is not operational. Skip RX peer handling when the interface is not
joined to avoid warnings in the RX path.

Reported-by: syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b364457b2d1d4e4a3054
Tested-by: syzbot+b364457b2d1d4e4a3054@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Link: https://patch.msgid.link/20251216035932.18332-1-moonhee.lee.ca@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ocb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index 9713e53f11b1b..6688b1dd8aaa4 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -47,6 +47,9 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int band;
 
+	if (!ifocb->joined)
+		return;
+
 	/* XXX: Consider removing the least recently used entry and
 	 *      allow new one to be added.
 	 */
-- 
2.51.0




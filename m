Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFE63BB42
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWM19qhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA8BC433C8;
	Wed, 15 Nov 2023 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076103;
	bh=eTyddWJsuxCnRL6gP7BV5Z7g3SC9UQRMZ0Wu8TytufY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWM19qhus4OtCuRaMDViA0Bymim4+/iPSXNMmGDWIbcmcM4GvTcREQzVMGarFgM0E
	 qHrWXLAVb/4evg4CsfQvycVGHMGFRSVZQtdrMkDkqFLdnrEWmrFs0C6bkcqeVsU/rf
	 rGAzkDtqpWI2XI73F6Jn4ZayVcP5inFRVZJxFPcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 078/550] wifi: mac80211: fix check for unusable RX result
Date: Wed, 15 Nov 2023 14:11:02 -0500
Message-ID: <20231115191606.115215152@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 583058542f46e3e2b0c536316fbd641f62d91dc6 ]

If we just check "result & RX_DROP_UNUSABLE", this really only works
by accident, because SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE got to
have the value 1, and SKB_DROP_REASON_SUBSYS_MAC80211_MONITOR is 2.

Fix this to really check the entire subsys mask for the value, so it
doesn't matter what the subsystem value is.

Fixes: 7f4e09700bdc ("wifi: mac80211: report all unusable beacon frames")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/drop.h | 3 +++
 net/mac80211/rx.c   | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/drop.h b/net/mac80211/drop.h
index 49dc809cab290..1570fac8411f4 100644
--- a/net/mac80211/drop.h
+++ b/net/mac80211/drop.h
@@ -53,4 +53,7 @@ enum mac80211_drop_reason {
 #undef DEF
 };
 
+#define RX_RES_IS_UNUSABLE(result)	\
+	(((__force u32)(result) & SKB_DROP_REASON_SUBSYS_MASK) == ___RX_DROP_UNUSABLE)
+
 #endif /* MAC80211_DROP_H */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8f6b6f56b65b4..26ca2f5dc52b2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2112,7 +2112,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	/* either the frame has been decrypted or will be dropped */
 	status->flag |= RX_FLAG_DECRYPTED;
 
-	if (unlikely(ieee80211_is_beacon(fc) && (result & RX_DROP_UNUSABLE) &&
+	if (unlikely(ieee80211_is_beacon(fc) && RX_RES_IS_UNUSABLE(result) &&
 		     rx->sdata->dev))
 		cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
 					     skb->data, skb->len);
-- 
2.42.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A742E7386;
	Wed, 30 Sep 2026 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794726; cv=none; b=hZt4QjLdDf4nMJ/tprYxEczu0SOyZbgZ50OR2i4uqgLjGlknSNoIGETZTgKA+rQ+X00s1USMYganZbjDJ0bUoQyNBVOoK2ia9iTqA1d06ezxhKP4SldsiIeCmu2OL1qwuKKnbQQ6wAWVFpMF0kXlEISlbp3ceIFDBgy1C+4b1tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794726; c=relaxed/simple;
	bh=r+ErAlmRBu2WJGGPi6Bq2GIb6s91vjbQdpOCeeFDvPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVkx4+u6NJUy+Fl1x2TpsIaphNQtgbhrfZFxPsBma23ZwrmulQ0duIKBoV4JyS7ZzK5tjZfWDk7MlZ/5CE68z3sOe3q314gdBGwFFsC5noAmJtsN6A9lIsPuOGX8uQp1dLsRrXkKoweAY4zD6h3fUyREwDt+MQ3PWhnrZOYXnMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VdTXmLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VdTXmLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73641F000FF;
	Wed, 30 Sep 2026 18:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794725;
	bh=2qAarP6D7QEVlYcJ1tNZTwbnRgkjsTBObFrVA/upuHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VdTXmLwtIz3BMv9rPXIUohAJE2ilb/+M6VR2pORQn6BVS7/KNqZHSZuGfhl62Yp3
	 cczGlPf5Lq1iM3WOocg+Okz5nX0ATwq4w5dvr3GnKWTYQLVSCYj+22IJVoSz4ypO5o
	 sdc9fRQiLIWU5oS/tEipkQoyKfUIkB5T7kJOD6pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0311/1193] wifi: iwlwifi: mvm: fix a possible underflow
Date: Wed, 30 Sep 2026 17:16:35 +0200
Message-ID: <20260930152441.052172310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0cb5260a1027a43f8cdb961e128f2ddd42e46832 ]

We shouldn't trust the firmware about the length of the wowlan packet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.fbd989cc85e2.If68de403bfa4943732c025961154c20b01b09e83@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 51abcd20ffbd6..4fbd83d3e8acf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1519,6 +1519,10 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 		if (WARN_ON_ONCE(truncated < 0))
 			truncated = 0;
 
+		/* this would be a firmware bug */
+		if (WARN_ON_ONCE(pktsize < sizeof(*hdr)))
+			return;
+
 		if (ieee80211_is_data(hdr->frame_control)) {
 			int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 			int ivlen = 0, icvlen = 4; /* also FCS */
@@ -1527,10 +1531,6 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 			if (!pkt)
 				goto report;
 
-			skb_put_data(pkt, pktdata, hdrlen);
-			pktdata += hdrlen;
-			pktsize -= hdrlen;
-
 			if (ieee80211_has_protected(hdr->frame_control)) {
 				/*
 				 * This is unlocked and using gtk_i(c)vlen,
@@ -1556,6 +1556,17 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 				truncated = 0;
 			}
 
+			if (IWL_FW_CHECK(mvm,
+					 pktsize <= hdrlen + ivlen + icvlen,
+					 "pktsize is too small %d\n",
+					 pktsize)) {
+				kfree_skb(pkt);
+				return;
+			}
+
+			skb_put_data(pkt, pktdata, hdrlen);
+			pktdata += hdrlen;
+			pktsize -= hdrlen;
 			pktsize -= ivlen + icvlen;
 			pktdata += ivlen;
 
-- 
2.53.0




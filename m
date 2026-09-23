Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D3D44CAD7;
	Wed, 23 Sep 2026 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175356; cv=none; b=sSjRZ18ZzbdFeOriGW7FgzCNV33iY2gq3emIhwvP4E4jjf7d9DWqgpLi973VJTIP75ZG1BbEGaCFaaFNGejVtM4ocUTX9QhA13nS1Q9WYmwLN0fA8xjcVo3YDvHv0yuCSrPoMcw4lPscPUObbdOCjL2HTp6l4EmCGOTTzj+p2zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175356; c=relaxed/simple;
	bh=ttdkMUqOny+KQbL8f56K8lWuJw7VmlaxJlw9U2YH/bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4cxt1vAbH026ezJUQRjSZhIBaXgsQTrhAdbnLxp20B5JcZYu4p3Dl3nbb4NlNAExyFuvXERECXhksLorW+YphE7CmfJhZRjCPOqOZ+A+ngoB68KMCQcauIW7HIueI+Tz2Pxely2BjbFehNPrusM0wFTklNPYl8pogAtAQyFPp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ib/Jzdwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ib/Jzdwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A31F1F000FF;
	Wed, 23 Sep 2026 14:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175355;
	bh=EOBrGhHchxup4A1lLBvLnDis8M71wilZA6lH75nAF1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ib/Jzdwd1CNKFlM9YHFTVaMI0zuzu4gukPwJEtlDi4PjUcrgQqK2Pp3bzFOhj2NGJ
	 9FUYOq65G2k8umF2hMDmYjak8Ihn55f+5H3AkufxKAzgMGAP22+JK0VY0fWdtDWWRh
	 Trg6bBfbRFfn5bS7cW2KfUTOwaQE2/drKmwXDxBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/398] wifi: libipw: reject TKIP frames without a full MIC
Date: Wed, 23 Sep 2026 16:07:44 +0200
Message-ID: <20260923140653.576887124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 06f42accaf3c6aecab1dcc57f68dde6c06c8b380 ]

libipw_michael_mic_verify() assumes that an skb contains an eight-byte
Michael MIC. A short TKIP frame makes the unsigned payload length wrap,
causing michael_mic() to read past the skb.

Check that the MIC is present before verifying it, and use the existing
MICHAEL_MIC_LEN constant for all MIC lengths in the verifier.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260909061124.3802517-1-4ncienth@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
@@ -474,14 +474,16 @@ static int libipw_michael_mic_verify(str
 					int hdr_len, void *priv)
 {
 	struct libipw_tkip_data *tkey = priv;
-	u8 mic[8];
+	u8 mic[MICHAEL_MIC_LEN];
 
-	if (!tkey->key_set)
+	if (!tkey->key_set || skb->len < hdr_len + MICHAEL_MIC_LEN)
 		return -1;
 
 	michael_mic(&tkey->key[24], (struct ieee80211_hdr *)skb->data,
-		    skb->data + hdr_len, skb->len - 8 - hdr_len, mic);
-	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
+		    skb->data + hdr_len,
+		    skb->len - MICHAEL_MIC_LEN - hdr_len, mic);
+	if (memcmp(mic, skb->data + skb->len - MICHAEL_MIC_LEN,
+		   MICHAEL_MIC_LEN) != 0) {
 		struct ieee80211_hdr *hdr;
 		hdr = (struct ieee80211_hdr *)skb->data;
 		printk(KERN_DEBUG "%s: Michael MIC verification failed for "
@@ -499,7 +501,7 @@ static int libipw_michael_mic_verify(str
 	tkey->rx_iv32 = tkey->rx_iv32_new;
 	tkey->rx_iv16 = tkey->rx_iv16_new;
 
-	skb_trim(skb, skb->len - 8);
+	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	return 0;
 }



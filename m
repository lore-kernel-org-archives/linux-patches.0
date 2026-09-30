Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561645221EA;
	Wed, 30 Sep 2026 17:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790359; cv=none; b=BGb5+L1T1wh4f2zgK62geHZkgEr0qiJkqVHD5JsvyePphz40Fje6eH/GxolKS4oqp2ZPy5PM0qEJnDWQp2GtHzOgcmooB+JM2XGtX8ryiJ+AjZQUCD89AJ2dLjCJu7LdwycJXdGNqup1tKJ+n4IuAo9f5NYqkgrgFqSoJG0RLsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790359; c=relaxed/simple;
	bh=3gYzb/59DtCfy7ZV70b1Oc3IM9ViQK8MmrXtVvPfc44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgwPZaE7Hva2pk1Zni+3uunHuheVEJqDcMV2QQolW6EwBypaPHVd/V7kUNXDVj/tLCcj3OyZ16xtKtmXh03/pd5BvDN+eEyodatvj3n/Db2SVH12CNOPk6nTaohd8eL6QItPRPl28/Zy7q1OTzmotMg+cz4YsjRsX7SV8+Mgp8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qmb/bwGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qmb/bwGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E091F000FF;
	Wed, 30 Sep 2026 17:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790358;
	bh=+qxlTJurCV3cXh5i2wUE46ZYyzDvDDE0T3udbbBOVFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qmb/bwGROZoS+UBnbIMcc3+Ex18bqep6fi3s76SOapBdtREgr6DvJqmqKAnFkVYT3
	 PH1D98jC8uvFTuOPTtD89CG5e1gt2E34fCiS+mq8+Df+9GIALfGnKYJOCvNCOl3yQV
	 yYvZQGwLBx9g9T77UrkjNXSmCMgySyLbnLl5Fir4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 801/877] wifi: libipw: reject TKIP frames without a full MIC
Date: Wed, 30 Sep 2026 17:28:32 +0200
Message-ID: <20260930152432.001805678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
[ adapted libipw changes to the older lib80211 implementation and Michael MIC helper interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/lib80211_crypt_tkip.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -38,6 +38,7 @@ MODULE_DESCRIPTION("lib80211 crypt: TKIP
 MODULE_LICENSE("GPL");
 
 #define TKIP_HDR_LEN 8
+#define MICHAEL_MIC_LEN 8
 
 struct lib80211_tkip_data {
 #define TKIP_KEY_LEN 32
@@ -585,16 +586,18 @@ static int lib80211_michael_mic_verify(s
 					int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	u8 mic[8];
+	u8 mic[MICHAEL_MIC_LEN];
 
-	if (!tkey->key_set)
+	if (!tkey->key_set || skb->len < hdr_len + MICHAEL_MIC_LEN)
 		return -1;
 
 	michael_mic_hdr(skb, tkey->rx_hdr);
 	if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
-			skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
+			skb->data + hdr_len,
+			skb->len - MICHAEL_MIC_LEN - hdr_len, mic))
 		return -1;
-	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
+	if (memcmp(mic, skb->data + skb->len - MICHAEL_MIC_LEN,
+		   MICHAEL_MIC_LEN) != 0) {
 		struct ieee80211_hdr *hdr;
 		hdr = (struct ieee80211_hdr *)skb->data;
 		printk(KERN_DEBUG "%s: Michael MIC verification failed for "
@@ -612,7 +615,7 @@ static int lib80211_michael_mic_verify(s
 	tkey->rx_iv32 = tkey->rx_iv32_new;
 	tkey->rx_iv16 = tkey->rx_iv16_new;
 
-	skb_trim(skb, skb->len - 8);
+	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	return 0;
 }



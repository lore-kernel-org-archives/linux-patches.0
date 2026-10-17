Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C443AAF7D;
	Sat, 17 Oct 2026 16:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255848; cv=none; b=pt1U1vN8oGGlHCaLLX0KuBKAcOg/zdxeOzUD2DXtfWVQiGtmNzuOngtNbyU0lKxmyZ5xyIsXIASyzE2eJLYj4r2naYYB3iAyN1/gs0C3EVSQVGKSCHG7uIRHXeJLQOMm+4KKMBoPM3XIfUy29QdbeM5GUZ+QE0ApAgLy5oVXjig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255848; c=relaxed/simple;
	bh=0r1SCJMO8E8xTooqpTCxiJaBGnkb+fam2gDD8NFpKEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moAmdOnee3ZFtBxdB9Uf0d0ym0jHDUbqd5Kykbv4izT0TjSVWlHiRqRFkB2FXJ8uzgeqtKQtLJ+Qb7H7yT9WFUwIT7HX+6F9V2A4AyaaRwB7eJ5aOXWa/9FFb54+NbZOY/H5NJ97zCaIdQ+MPeBKkNv7Qfj3VbhpQWH1rMhllKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOWfQfPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOWfQfPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD401F000C5;
	Sat, 17 Oct 2026 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255846;
	bh=UyOlJnvKKcOYIObgkOjmWz14IRiWPQJ1Rg1bOtCKQj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOWfQfPTBAUelDjjLHffbxAnsObl/ZHQ5UXATex2FXdjgssP07NvE0M3cK52DcayL
	 J1MbO8vxp6F6nQkf+r3vX8c3zqmEmUk8Ulfx5rjih6i2zIOCsz9i9zKOys/JMQ6pNr
	 YlVmB4comFEiM0XWUJhAIYAcTA7mfk/mGTffyTIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0042/1674] wifi: libipw: reject TKIP frames without a full MIC
Date: Sat, 17 Oct 2026 17:38:34 +0200
Message-ID: <20261017160432.219748047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
---
 net/wireless/lib80211_crypt_tkip.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 1b4d6c87a5c5d..823274728711a 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -38,6 +38,7 @@ MODULE_DESCRIPTION("lib80211 crypt: TKIP");
 MODULE_LICENSE("GPL");
 
 #define TKIP_HDR_LEN 8
+#define MICHAEL_MIC_LEN 8
 
 struct lib80211_tkip_data {
 #define TKIP_KEY_LEN 32
@@ -585,16 +586,18 @@ static int lib80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
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
@@ -612,7 +615,7 @@ static int lib80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 	tkey->rx_iv32 = tkey->rx_iv32_new;
 	tkey->rx_iv16 = tkey->rx_iv16_new;
 
-	skb_trim(skb, skb->len - 8);
+	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	return 0;
 }
-- 
2.53.0




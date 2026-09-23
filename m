Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490E13AA19B;
	Wed, 23 Sep 2026 14:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173917; cv=none; b=kV9lu75MHa62qjpbABe5Id498sYvB5Bx0OipLqSpgsbRFSqlPwMrLwKMEgQdk1ymTUd3RQvh6sIzx7GHuUhmrj5UPYWAZhUf9Lo6AiCQlaCHU/q/B/c6mDRlTBumBUT3PYJrwrg80pxHkJvuz4Bo6ngJQPqsYukxXvLbOPQNih8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173917; c=relaxed/simple;
	bh=FgZoMDHYh4P3Q6oAvUZEWCTHysOWzydy5oq2qiDdcNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjZpBpIMSoS5I/67DjMpOoVv4LLcCUFklQmE7OGc5u/yz+TMrHnKZc88L3P8GG4188JptfFsXPVGJmAkwYTSbhvew4nw5PlhxeKZ7CIc+aGa8A5fYyyHIVxQUA0atQ+tOYdrx6lS0lcPOoPa/C4ARsZ9Y/e7sUD5DJbLz8Z0J1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCVEYWcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCVEYWcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820671F000FF;
	Wed, 23 Sep 2026 14:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173916;
	bh=iAw4ZwLdF/Su+r3juGcQ7SfyExGaqM4NVVg+MLwYAyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCVEYWcLt8x0UyIZibXBimwlwOtO0WP7OR42b4gah9s3vnC6yW4M20av3JVZY9WkZ
	 1zQDTsdZA0PPXLddpYZkUhp11IhKctlsMNe7S1YxHsPU/Aky39+YZUBhPRVw8znk3B
	 +Bc8s6nxzH5M8iQdmISArWLFG7xD7eX2d0V3/hQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 385/438] wifi: libipw: reject TKIP frames without a full MIC
Date: Wed, 23 Sep 2026 16:06:46 +0200
Message-ID: <20260923140654.853057330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 06f42accaf3c6aecab1dcc57f68dde6c06c8b380 upstream.

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



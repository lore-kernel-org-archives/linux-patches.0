Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026326;
	b=knrfDO0RMVGDhjZTkXRdwrL8nbScIUjwq1ZGs0wKPJcahplilpLG5A3fuqiOfPq/avTC
	 0aCo5stD3eAcMdqB10D7AFbFO1BfHkpXmjNaOu+AdZ9TYZMazYZbS9pqHKqo3pr+YR8BY
	 0WHUtn8f3rQfCwue2AfeHauusmTCmkLoinpXolWmOlXaFXzf80yPlXnnpcIvc7PZmUyST
	 2irz9+JF+bqTAyt0aRoC/7fBZTimwMrkLXaY5HXX6j1Ls0tFS4pvY6dNFWc3jDmV2G3v0
	 sMtoTVgsbVCPDPnijREQyjpavQYUV3maWT1AlFJgehhSHIrYCYXJ9hDiFeUfRdz2L7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEkY6+gqvcc/NIcjKEKNvyZO5cchqlDmCMQE7M72jzY=;
	b=ibxyYLEG+mlgpakJ0abtX2imlKdUj5IoXZmzVbpyNPbjj9W32zXPFMema2B6u2QvvSse
	 67p76zmg5anPq0MqssZgeoCVU5dW+jhPmD3TkXo71WcN2ez7kan25wPPVAhVPyOQxCk+u
	 d/hiWqlrOmtisxsV+vBSa5/rFVb21uMfBKXQlXnaGAjUlRWCvcxcYf7EQLPW5MFKMMph0
	 77jSG7ZjDZZ607KU15kXfZ/Y8aiblQ7mRXUWJsj4eGAsIHgjJv/1CnOUrFq4+mK0s/iFo
	 q621vj/j0vKMk2N8yLuvR2ZD1MW6w/ruhTZ+Bn1Gtnax35cI2BH0nNoZQG5YqT4wr6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ihfuUN5/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82442606A325;
	Wed, 18 Nov 2026 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihfuUN5/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8211F000C4;
	Wed, 18 Nov 2026 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026326;
	bh=IEkY6+gqvcc/NIcjKEKNvyZO5cchqlDmCMQE7M72jzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihfuUN5/NZMTMCSo/r+AjabUCz4+360mxn19GuW7ZrWOmQRDsk5L94RptsJsNlEB3
	 AvF0TXceYuhjJaFyhX6hBChfQHSIx/09kHtbPAi2oDfzHGAeioQ7q3EX94kwMTpRwu
	 n9RkmwvFPZKZenTRL40hHnV4BhF5SFAQ+IT96w2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1395/2151] wifi: mac80211: fix encryption tailroom
Date: Wed, 18 Nov 2026 15:52:10 +0100
Message-ID: <20261118150212.815686246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chien Wong <m@xv97.com>

[ Upstream commit c49f54fd2abff08964677db8fdc1674c713ab42c ]

BIP-CMAC-256 and BIP-GMAC append a 26-byte MME but mac80211
currently reserves only 18 bytes of encryption tailroom.

Generating 26-byte MME may happen to work because the actual skb
tailroom can exceed the requested amount. For example, dev_alloc_skb()
rounds the allocation to kmalloc size buckets or alignment boundaries,
and the extra space may cover the 8-byte shortfall.

Reserve enough tailroom for the 26-byte MME.

Fixes: 56c52da2d554 ("mac80111: Add BIP-CMAC-256 cipher")
Signed-off-by: Chien Wong <m@xv97.com>
Link: https://patch.msgid.link/20261012140738.70178-2-m@xv97.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0f35094b3898f..1f049720bfda4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -52,7 +52,7 @@ struct ieee80211_mesh_fast_tx;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.53.0




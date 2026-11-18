Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041330;
	b=fMYxlvu59fKeV8gtdkrP+/biItz2vX+79gWKR79MN/i+VbvT/h5gwPzwdbJ5JhNZgx+U
	 85s94GHmW1WhtVlMu0hLyU0j15Ar3rjqHCwul8DH1VQCi23YcnVVH4lBIhF1h4IeqaxCm
	 N/50PZbxmUExm+pqagK5ZlYN7ndjLg+kQ1tZEJ7CwuN7E/Kj/toVf67hirr1QBoqtcs8q
	 vq7M4W1GmMedg8/CrP3ybi1oqiPvUDtKm5Tk7EjfW4+xoR3QCCZdJZx9uqC+Kx38Lt930
	 NIygKrYfCB/b8HO6xEgwe0q+8FRsSWts3iXotsF4W0bH0+/Sbs+cLdl1Cfi3kXfShFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ncn+n+701XonuQc007ipVI4y/EYyCp8472MRqPJuQEg=;
	b=kOoMO2G3Vc4czFRtB0oNoUXdCr8fnWhpyALtXk0hR4swFE+Y8NXc4uOCoIi/FVA8iopg
	 pu/n83J9+4DHxtPDlBBv8uvUvY8AGpioJyKXghSMgE9aXK94moSF4mbgZ+vUXHRY3FPDH
	 yee/+cQ7zh3BQCZsp8L7L47T0Be0POzEPnuObeH/Tji33iMs0n98ZocAJW2AlSxxZoY0V
	 d1uANOc6y5LWUHm55+J6YUtFdkf3DY7ZW4kpnj+abdw610YTXLt94VCm+6MrYT10aV0l/
	 6Z5JrLjWCU7hBjQUIpdWZRmUkT58n8mQEK0D37D/b0z4llUL7sQCWIhRePQdQaPAr9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDnBYztE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A35606A31C;
	Wed, 18 Nov 2026 22:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDnBYztE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F9D1F000C4;
	Wed, 18 Nov 2026 22:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041330;
	bh=ncn+n+701XonuQc007ipVI4y/EYyCp8472MRqPJuQEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDnBYztEtGFq5AH5OCbtAxFhjNxvdcGhIfi+j5UYqBclxdB+sHHk1MmPFFC2WdbGz
	 6GNSCWCocKPhjo2n2CYodpfRNdsDMWIxNQodL9fMSDGDtHldY7ExQQxOMpSB3fHYfB
	 BkQ0lxvHBs9ois4PigdvlQM8uq4vvQEPs7zF1KhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2776/3318] wifi: mac80211: fix encryption tailroom
Date: Wed, 18 Nov 2026 15:56:38 +0100
Message-ID: <20261118150443.984529918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e2d07b00f5eda..1e9ded4fba724 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -51,7 +51,7 @@ struct ieee80211_mesh_fast_tx;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.53.0




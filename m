Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD9A47141A;
	Tue, 21 Jul 2026 19:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663617; cv=none; b=kVgtYQZEvIiyyezkPTamDo0H3WcF1ZrdIGaaE9hfdVAcRv3Rx4koimBztAM5ZCssv19NfBGCO1i+D2eoz6WyeQbNwcEXnwroCsQdkfvK+nkExESgiwotk07lzjfoCoQygy5kdjQbleOtFAV0dC/Y/kR5a8XYkMiDUhzxRNvLooY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663617; c=relaxed/simple;
	bh=UCzZ1/TSEuis/ncrl5zjtufzvw6fDkYGmlbnDDovr6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3Px7Gf1zPlhyRCH4/Wz4XyJqqkXGkcONaxdBFkvOFj7Y2Cm1uUKtUgf8q2jRsS89aXMkWAMe7SwHPMB77XjtVYoCJwuoo4Og05u91swj73q7KJbcRTwbYAUGrBPsfTb4AxtzTNwgVNSE+LattnAXVefABeQth9Ln3k1jc60rtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYN17s9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYN17s9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647691F00A3D;
	Tue, 21 Jul 2026 19:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663615;
	bh=2W0UQjTe5eo1HR/UAzdaCMfWxrlQObbAySancUtlnJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYN17s9W86AyZEcJ8Tn31LUOpQYZPZdccS2+tSnSSwO4UYreCKo6nF3UfXalpqIy4
	 Ei8CKEkZ8L4PrL2x53xaFK4XPFBPcrJcHOHm2OCeDAriL1JWQdky6nPVUFZU7WK9PF
	 uUWVo3AEPMOgmkLMN0yDE5Jf0+mvhwOQUYd8uKVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0891/1276] batman-adv: frag: fix primary_if leak on failed linearization
Date: Tue, 21 Jul 2026 17:22:14 +0200
Message-ID: <20260721152505.984571073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 353d2c1d5492e53ae34f490a84494124dc3d3531 upstream.

If the skb has a frag_list, it must be linearized before it can be split
using skb_split(). But when this step failed, it must not only free the skb
but also take care of the reference to the already found primary_if.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a063f2fba3fa ("batman-adv: Don't skb_split skbuffs with frag_list")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -545,7 +545,7 @@ int batadv_frag_send_packet(struct sk_bu
 	 */
 	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
 		ret = -ENOMEM;
-		goto free_skb;
+		goto put_primary_if;
 	}
 
 	/* Create one header to be copied to all fragments */



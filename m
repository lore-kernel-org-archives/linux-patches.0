Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046301;
	b=mO/bhhrFFGpBIFTLwcbuHXFwWSneU3c/U2FOB2bzthy3Zp4gf63OAcO/yHZ3z7au60ZA
	 5aRHFowJFk11iu5PES6c9Fx8Dx167eQyA6zzphJl2Ek7CJ409NKrBO7cORot1po/ctRhf
	 CJMYWnzllx2YzcZGRlzPRxQ2ctuKR3iGUvfJQwgnEe05Eohs23NOZwc5cEN5zmepYAERq
	 DfYn9lh0k/ToKM0orhu2BkE68rdtm2UEu7G0oTwiYvEfONNosovs5vw1qHE35HQQtePWv
	 J/kdjhBmTBPC1w1Zt5rT1Zt6S7swwdFNkOKF7N31Z3h3iE2MpElEeLpbj9qLZRZmJcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3mebds7zVqX322RVA0AwMk7GIjqm1mDkXe2iCZBWoQc=;
	b=Mh9W3YNYFmyswPspxotf016wuDgmsKw9kwa78eOIomJy7BPuz85nXx2p8YJxaOCbuuHc
	 D4glY00N3bey/vfE+jucZQ1GxXpHbdluGjVM/QSrRx98jeVpjNM7YRE4nPBwo8xbtEpsp
	 blqH8HS2T36dBfRl7rVKv7K+ICiXy8+5Gpdg0qS/fRL2FAT5HXfjybUYXrWdcQsl3//nf
	 0rxiRH2T3gE2GG3ccS3WFkV8Wo9xyqfaP8ngNvGHnFBFWCqGE/gajKlViBZ/nfPnYGLPU
	 k9d2iDGGapeFdTvzSLR4YOpsiNLXzLNvJxDDz4KOEWeIBDYAxHIJmxOJgVKxQG/7MdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6Qg22UR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CCC606A31C;
	Wed, 18 Nov 2026 23:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6Qg22UR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D061F000C4;
	Wed, 18 Nov 2026 23:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046301;
	bh=3mebds7zVqX322RVA0AwMk7GIjqm1mDkXe2iCZBWoQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6Qg22URYNDKEKhzUeakPYKMZynF1Lsh18P6/IUvRkGRsAQ4qthoDKzXnVD3kB4vx
	 F8TVnlxx7OC38umG9Rc1bjnyL0suh5uWwyTm7L5UeE5tVLiVAwvMxnfFX6w+wEPCkU
	 2wA/emOGfG3c/sR/mg2a1/pZPvAUZcA741Py8PWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1205/2857] batman-adv: fix skb leak when hard_iface is being released
Date: Wed, 18 Nov 2026 15:37:19 +0100
Message-ID: <20261118150244.988471614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 522e4aece2e96cacbb8a6ae1eec0d4c0dd6f4fed ]

batadv_batman_skb_recv() owns the skb it is given. When the hard_iface
refcount already dropped to zero, the function jumped to err_out, which
only returned NET_RX_DROP and skipped the kfree_skb() under err_free.

To avoid a leak, free the skb before returning in this case.

Cc: stable@vger.kernel.org
Fixes: 4fe56e60ac1b ("batman-adv: Check hard_iface refcnt when receiving skb")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 650e9bacbb79d..48065fd09e1a8 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -448,8 +448,10 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	 * shut down otherwise the packet may trigger de-reference errors
 	 * further down in the receive path.
 	 */
-	if (!kref_get_unless_zero(&hard_iface->refcount))
-		goto err_out;
+	if (!kref_get_unless_zero(&hard_iface->refcount)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 
@@ -508,7 +510,6 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 err_put:
 	batadv_hardif_put(hard_iface);
-err_out:
 	return NET_RX_DROP;
 }
 
-- 
2.53.0




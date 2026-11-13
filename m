Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590211;
	b=zE5aW4wQOND8mv7e09XGApKv1zy0ZJO+pwqsxT+eXkv99qSp2oANezg08DBHA8MkYEoc
	 hEKceRwPo+Qp4CRJnsjaN8yYUQy6ow1VDesC5pxqQyx/Lh0su3CAqcTm2kUrlkiRRPj1J
	 t9rR1ZFbtcMTZuWOZBcCaYfRUpzX7pDiIsz5Ugy5LoGH7RH5ulNLjKI8wVh3VPvYq/oPz
	 380u7+sMuTmgzB4ZDD7yrFa2X5BACHJUFcXmmYz4jGrxZzt8GmihSllo+jR00KRhXttif
	 pQRrGBJq3SUeLmFEGzz5ledP/Yf44o2buZsN6Hlhj+RtXaQkOpiLx7DEO1g1BM2VXBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pJ/Rzi1mt4/6bQ/PWrme+rTsbUgeb/AIR8gOLJaxKxE=;
	b=K6NH5WjT0RfutK+kf3t7Xe/8WGfSw19eLs5ZalsV9QFxycEUd8NshdYvPNb9zuAecUkH
	 yulX7Vk1BU/EQ9BYliolbSmIJ87Ii1SgCRIULynjTghl4q7V1Ya+nxd6GBEhlnwRIG1KY
	 VJFD6pUwx80TWAv7yxnzGZViCfTRPxoO56OdkV+IQGupg6EwjudQBKASMo7yItLKlYD7d
	 vOyuqIjwjXlup8I8SUq1avbs5q2KzfZV4Rqy/WEkIJljbyj+UDv/f9dj59CdznVH+Zhvv
	 y1CroztborbpIywllmCKXDzIPGTvOA13AA124vRQQqjw+2y7xTkPgA2zp7qvqGsJs2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eau+LoXA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C9A606A8B8;
	Fri, 13 Nov 2026 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eau+LoXA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05811F000C5;
	Fri, 13 Nov 2026 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590210;
	bh=pJ/Rzi1mt4/6bQ/PWrme+rTsbUgeb/AIR8gOLJaxKxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eau+LoXA73YVCmNg2GGPQG1xWsE7CUF84o6wd50QMwvbfg6pdP6mJw5DVL+dsg3r9
	 AYMrv1yYbTwvY0LgfVmNEjMQIgwufoZpGt0PJGTyHK77uHN+3+iJYMpYRCbhmQd5P2
	 EBIHD9ZL6mmxqmnO0tjCzlPsxiNCnwO7+WX7EpS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 213/686] batman-adv: fix skb leak when hard_iface is being released
Date: Fri, 13 Nov 2026 10:45:46 -0500
Message-ID: <20261113153828.253759140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index f1b41078835b6..870754d1d86f9 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -427,8 +427,10 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
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
 
@@ -487,7 +489,6 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 err_put:
 	batadv_hardif_put(hard_iface);
-err_out:
 	return NET_RX_DROP;
 }
 
-- 
2.53.0




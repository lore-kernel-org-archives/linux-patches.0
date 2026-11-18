Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059000;
	b=hzOaYC+euXS1vSAhlIFB1KlVP3WRwQqKiL8QxGcxqgjt8gUb9oguzRCdqydvobyx0xLW
	 NNWvMFIxCzdtqcjUkjNfm0QHZpzONh2ksobpkG0r01YN0i99PRVG0gpLYq8lpm8QC6DG4
	 ScVTmn7rY5IUJsRmqIXgU+lBqqHVe1h7+/rTr1v46VxcgbBygwWqwW6M5lK+hDd/e41XW
	 Wb+hWiMyeIQATlCkzJg9ujXQcijSL/NsRypERkP6IvEZm0A3Ee9J8UuCjswgjDYevd/L1
	 SFF/gLqqD9PUD1DTpQ707xGOL9RUyNnnaVyfAQuvfp4BBwp8wk7/Fof9H3oFsIke6uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/fF8P3XZwzRKbSkvrIhp2Ju6ksoEEhx5aNLRm5tjU8=;
	b=0k9vbdthcLAHJHTaNCJCHEye6zvm3lL+4lpMUF4uQudvcwyIDQFFD8IhYRxZudOl0VCO
	 P97Qqg0qjdjbRa2IfPO3a8SvbXqsnNlTtravoP2cGDcJBCmM5FIhmMfhspSwpfs8TazL8
	 TrI4W4H3I+ZSBEwxFA4ZMxPK0972ErYAnEFaunLx0G3ygLdYcqG91zXw1FSOjgDqDbr2p
	 hQZwi8ZeFf5n35reAdjcl72OpQiufuMGX9PHe6Yc3stNy20e4H5+5ODDnN6929w+z+ps9
	 IhocB8q5BQlTXn9EtNnXc6rd+DoLICrEsDpy491H6zptQBfEOR4PXDLfeIDthKAvptg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxqCtDPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCC1606A31C;
	Thu, 19 Nov 2026 03:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gxqCtDPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A970C1F000C4;
	Thu, 19 Nov 2026 03:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059000;
	bh=H/fF8P3XZwzRKbSkvrIhp2Ju6ksoEEhx5aNLRm5tjU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxqCtDPmoop3wuoS9F7rMUpARYgowMycHNArtYR8N2Ov4oRyLjle7ImLeHUn3OGuM
	 v511reCsqdf8bqcyyD2zVguc7YB+qvb2zTRYlf571qk9wgUPY1xQjiZqk/KVWMOFyu
	 dUV/0PLQTNJwDZ2kyqAXp/1rNyz8WqXZZJGXZO9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0686/1848] batman-adv: fix skb leak when hard_iface is being released
Date: Wed, 18 Nov 2026 15:45:24 +0100
Message-ID: <20261118145944.674098169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c621f638561ef..860194a06e534 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -502,8 +502,10 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
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
 
@@ -562,7 +564,6 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 err_put:
 	batadv_hardif_put(hard_iface);
-err_out:
 	return NET_RX_DROP;
 }
 
-- 
2.53.0




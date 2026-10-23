Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773867;
	b=CEHg2b1xtHOUhwPAARIV7HEQgqtF+c0QsHndppacJNDr7bYoMUlVU0OqZow09fRf8a5G
	 3rOautzjeodQwmlB85UN+R8XU3zgrP4W/z4PJWk2knx1bwtPM8Fpv6ocz5SrF3O5Oup6A
	 zkR/C8trlz0yZdG/xxTmYa30rbKva2rM9O2CvKoemx8tgG+RKpbFeObGx0U52rj9R7tkT
	 k92sJyimXeiYEwqrmunFMp0t68aDa20SY09PeIfVghsFgQKTT1QVEtAVa4KLN7GrFM8jD
	 7wfkaiXN+jUafuHEvk077hF2gUzpGnANDe3kl48C9xz57DhJZjQnceeRZ93QQUSPhZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=incH+iRJCWA6781oANHKRLiaM44gdGvjbzEj2QhTvz0=;
	b=izqUyIVCH8Ci9LwfDiWlpjzticbHXhD8EsSeWi2vB5JxRH8cV6D4/itF9xMAUrsRcnsr
	 fehKpLwtHfEgJ//Nf4zCam+LR4lT+ZiCnrc/tzq0dxW6u78gl75PIC3jhVoITtJzLEGa5
	 ZFa/wunRCXrbMkOlMNVSSoKMfuDYgDh9EMLiQrsL9trS5ak11C4qiFcf1J1xd4ujdsJhf
	 ZoyhYKPCuq1+qvx1fzT3AzbTp9/ypSzWS342TdLh5Pb1I/6HZ4w0I+1j3G++d4p3NH/+E
	 arpLxbuiZLXNoG1WEQOYhPszY7v8TGnUe5XzskF5r4Wnh2PYuaATEUxptyqjyEIFM5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIt4P+cM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B706B606A323;
	Fri, 23 Oct 2026 16:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIt4P+cM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D645A1F01825;
	Fri, 23 Oct 2026 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773866;
	bh=incH+iRJCWA6781oANHKRLiaM44gdGvjbzEj2QhTvz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIt4P+cM2PBycwYddNgGUAYfhaT85N2j0yqNmpew59MeI7mKn2/idWbRk41mlBBKJ
	 ufvV1xP8Uukuz1ebF38Joy5hUzO5NSXGWMvvwtsCcqgSTW4WHc1627KJgtuU0QACbK
	 2CC0EroOy/yttaOtZm8t1p3BNIWodovoD34ZgWX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/193] netlink: reset skb headers before unicast and multicast filtering
Date: Fri, 23 Oct 2026 18:35:18 +0200
Message-ID: <20261023163715.178764943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 8bf659bd54e1f00e34cf5244b1d289c506fa47c0 ]

Socket filters can use SKF_NET_OFF and SKF_LL_OFF to read relative to
an skb's network and MAC headers. Netlink producers may reserve
headroom without resetting those headers, allowing a receiving socket's
filter to read data before the initialized message.

For example, IWPM HELLO replies are allocated with dev_alloc_skb(),
which reserves NET_SKB_PAD bytes. An unprivileged NETLINK_RDMA user can
attach a classic socket filter and disclose this headroom through the
length of the delivered reply. The resets in netlink_dump() do not help
because IWPM sends a separately allocated skb through netlink_unicast().

Reset both headers before running the receiver's filter in unicast and
broadcast delivery, as is already done for dump skbs. This also covers
other netlink producers that reserve headroom without changing their
allocation or message-building code.

Fixes: b1153f29ee07 ("netlink: make socket filters work on netlink")
Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261006224232.50724-1-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index fd8e9cfe61717..c41fef11e518f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1345,6 +1345,8 @@ int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
 	if (netlink_is_kernel(sk))
 		return netlink_unicast_kernel(sk, skb, ssk);
 
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 	if (sk_filter(sk, skb)) {
 		err = skb->len;
 		kfree_skb(skb);
@@ -1479,6 +1481,8 @@ static void do_one_broadcast(struct sock *sk,
 		goto out;
 	}
 
+	skb_reset_network_header(p->skb2);
+	skb_reset_mac_header(p->skb2);
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
-- 
2.53.0




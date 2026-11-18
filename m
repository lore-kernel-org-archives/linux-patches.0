Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042274;
	b=gyrr1nKZze76RWtgduySxzs0X6JleZUh3u8Ko5fnToXD3QVRZl84YJ4DWd29E1/6j6gG
	 mCNQuXw79QJaWAmI9DeOFY714FrsBv+OAZX4N1NcTA54n9SCzlDhQsyDzoHPBMcYMdvAj
	 RP66zwo/shRZMWesEYeJj0mTx4JWAnA3diDrRDHfRovd8ExeZDsSC4cNEzfXxi1TFvQge
	 dsqeBrUrr7GqTLfk4ITnmj3OUhXoJzwToYo9bj17+Cz80HA2NCo//KD8GN/kyBIrQFXva
	 TPlQeo7gIpNAQdVC/NKgpQ86a/wgPvbOxemrD9oCNogd2qgL3i+NUUXVTZKNfCDrnXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i2gEFKqFs9BjcSB26FHN4G99p4ELDR5ri15e2h9aN10=;
	b=tSAnvpYDEbiih5yyEPxRuIuCuGtn47myCDgYXCIjTlGdIYfpcMN/ZhP9VAeJZsJYmcg7
	 nEc/BYCfmAFC3yYstO+x+VSeQi1po8V5+TC19EBwpRO7FPjKqieoS9jxdFtlxnsHjlTI5
	 lvDPaS4dJK/2xX53ZUF4XCpaWZgG82i0WJQ3PNLzWg9T28C2bEC6STCkiLlonjhcZy/7r
	 F8LrxQvYPXVU0UBEcsyI1vC8v2sRSXFu6SB+yIgQaJy5m8zTVxp9s8CFkiBAeE45ekrHG
	 /NHTF+ENRHwsMN5jjy7CAkR0zUDP1Ynx4nfTopCVIwX1v2qdYhhcjLSbjqvTvSS78KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NuqG2TOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65628606A325;
	Wed, 18 Nov 2026 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NuqG2TOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63161F000C4;
	Wed, 18 Nov 2026 22:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042274;
	bh=i2gEFKqFs9BjcSB26FHN4G99p4ELDR5ri15e2h9aN10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NuqG2TOpX97f0RBloRlerviSn+UpqIs/1KTKf3ETwGpESCdK/zxNC8uWiwlNDaKmB
	 cnc8lbq+vucYXi/ntrANHztyfpOE11V724OI7qXHBjBg/5iTHDcmkeE06gUslwh13u
	 FCWnTdtfyV6qQivS+Ba8cEwp9NJHsGCBqpAE/dC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3110/3318] gtp: hold RCU for the device lookup when adding a PDP context
Date: Wed, 18 Nov 2026 16:02:12 +0100
Message-ID: <20261118150453.271849754@linuxfoundation.org>
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

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit fe3e1a42fb7eb18d8c55d714b50a3d51f8cd6ffe ]

gtp_genl_new_pdp() calls gtp_find_dev(), which looks the device up with
dev_get_by_index_rcu(). Since commit e2d1baca2b33 ("gtp: remove useless
rcu_read_lock()"), this only runs under the rtnl lock, and kernels with
CONFIG_PROVE_RCU_LIST warn:

  WARNING: suspicious RCU usage
  net/core/dev.c:1047 RCU-list traversed in non-reader section!!
  ...
   dev_get_by_index_rcu
   gtp_find_dev
   gtp_genl_new_pdp

Hold the RCU read lock around the lookup only: gtp_pdp_add() allocates
with GFP_KERNEL, and the rtnl lock keeps the device alive afterwards.

Found with the gtp selftest on a debug kernel.

Fixes: e2d1baca2b33 ("gtp: remove useless rcu_read_lock()")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Link: https://patch.msgid.link/20261016093225.1036375-3-anilkaushikwireless@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index bb9f284aac455..6e6942d1e2c70 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1497,7 +1497,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 
+	/* the rtnl lock keeps the device alive once found */
+	rcu_read_lock();
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
+	rcu_read_unlock();
 	if (!gtp) {
 		err = -ENODEV;
 		goto out_unlock;
-- 
2.53.0




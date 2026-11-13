Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585681;
	b=LkPgzdgpVUtkhd6FGPEVKmlJ+WfVLA22j4ESaTlonT30pgWXJZ72ZJTqT1THgN7zm49F
	 S6e76WdLmwNVaHsdTcvFSVzbadQ+8zF1B71UKrhhwU9biX8TwKqGUN0I1on4a+bK0jJxv
	 jc9f9ZbWocHwTTFwNoMIA25ePVHS9OBY41lpNoCwX9S6BF3tfMSay0GSy5ATTMqpoCUF8
	 KGhJRx4sD9TNwnkNFKLmTg17FxtjiGOIWep4wHNlIBnQszMC/6T1aFXpTCNn8QIv6w30p
	 GccpbgwKTQuNxmaemu17aesUvstwIs9IYcgmeO95/oS5wk4fYmOtDEyg8ELhaHcB7wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r8GK3maxeJ2Cca66Mf050FEBp7FUEgXd2b/rBQJs0e4=;
	b=RvgK3L/5gWAuM1SgNhwha+dkOG9IoSdzKIJeeC3Ik06vA+b/or/uXPqRJtL9nq0FullG
	 J2GJ6XksCdMCFndCxNvcRv4TbF8M24aLof4rhRzSwLjt/cbliJhjof36M8/afHFEMWWZl
	 cIuXKK3HydMYKumtB2d6cBj3h5AOYVWaEsPus9DpW7V1PPckGDcMNYq1/a8ab5b1kX5mN
	 O3lRn1RSv39lXRwuYw8no2fmR4joZKLBetzIQmbMSb2P2HQsE2/GcpJWpzTxHy4oJwJ3L
	 9iTOkmHu2Hiywe3Sy6PD3LKSmIrtenELsVy1GLIoWFGWy/RY8vLRPhBVkAfBu0EqntA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYXbJgYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5450606A335;
	Fri, 13 Nov 2026 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYXbJgYr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502221F000C4;
	Fri, 13 Nov 2026 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585681;
	bh=r8GK3maxeJ2Cca66Mf050FEBp7FUEgXd2b/rBQJs0e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYXbJgYrtF/95MrP4wLVGJvFbW+UToI8MfyjvgP7HsHGIezfesLM/gX16CQ4fkqjf
	 6yfwkSmihlY0UgbkSxAOAW4hlK3PA064655p1PoNzTrz/zt65fm0Z0e3E8FfzpqQcs
	 1Lu71es7OAeGQdGkyRjDhJ1W/0sxbi9RXXgFjleE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Cunhao Lu <1579567540@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 293/507] can: dev: can_put_echo_skb(): free skb on invalid echo index
Date: Fri, 13 Nov 2026 10:49:57 -0500
Message-ID: <20261113153805.180900955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cunhao Lu <1579567540@qq.com>

[ Upstream commit b4ebcbbf66ba6c5816dfe229effb4641c46e4b4c ]

can_put_echo_skb() consumes the skb on all paths except when the echo
index is out of bounds. This leaves ownership with the caller on -EINVAL,
unlike the other error paths, and can leak the skb if the caller expects
consistent semantics.

Free the skb before returning -EINVAL so that all return paths consume it.

Fixes: 6411959c10fe ("can: dev: can_put_echo_skb(): don't crash kernel if can_priv::echo_skb is accessed out of bounds")
Cc: stable@vger.kernel.org
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Cunhao Lu <1579567540@qq.com>
Link: https://patch.msgid.link/tencent_683AA16E643DE00211CD2FB62991264DC605@qq.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

---

FAQ:

Q: `can_skb_init_valid()` directly modifies `skb->data` without checking if
   the SKB is cloned or shared. Is this violating SKB shared buffer rules and
   causing data corruption?

A: The finding about can_skb_init_valid() modifying skb->data on a
   potentially shared buffer is not relevant for this (correct) patch.

   The FDF-flag write in can_skb_init_valid() only matters for PF_PACKET
   use: PF_CAN allocators already set CANFD_FDF. The write exists to
   normalize frames for PF_PACKET observers (tcpdump/Wireshark) so they can
   distinguish classic CAN from CAN FD at the netdev level, and to
   compensate for PF_PACKET senders that omit the bit. That normalization
   is functionally required.

   The shared-buffer concern only becomes realistic through a specific
   chain: a PF_PACKET sender injects a CANFD-sized frame, the CAN driver's
   loopback puts an echo skb back into can_rcv(), and cgw (without
   modfuncs) clones it for forwarding to another interface. Only on that
   second can_skb_init_valid() call is the skb cloned. By then the bit was
   already set on the exclusive skb during the initial xmit path, so the
   flags |= CANFD_FDF write is strictly idempotent for any parallel
   consumer of the shared buffer - no memory-safety or
   information-disclosure consequence. It's a formal violation of the skb
   sharing rules without an observable effect, so the current code can stay
   as-is.

Link: https://lore.kernel.org/all/54a3cc01-abcf-4a33-b932-39bb1f68cdd5@hartkopp.net/
[mkl: convert Oliver's mail to FAQ section]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/skb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 46c151eece8f7..9e274147ffe56 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -55,6 +55,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 	if (idx >= priv->echo_skb_max) {
 		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bounds (%u/max %u)\n",
 			   __func__, idx, priv->echo_skb_max);
+		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
 
-- 
2.53.0




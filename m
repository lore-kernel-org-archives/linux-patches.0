Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159B46D2C7;
	Tue, 21 Jul 2026 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654281; cv=none; b=r/ddNQxh6SU3Zjp5DiLlB4fZFDDgX2WQ2cI6NSYBRWoHeG5/wnG8ZVPvIA4ml8Zq8Yr25ELc8ji/0MKRzEG8k0ICPZ4Bp/dsfmlfFtxzV1OJ8mLKKVly+Da73woAnZoKxyGCe2fEp5d7JWq79X5K3X2670aPzoIIW6NvfXQW7tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654281; c=relaxed/simple;
	bh=+DmRsB4LyKvrK3I/PcOJnWbwSGkjHKUYXcQLfzxLSOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpTFFSelHXm+2ViwYdujjYXcwvF2un9pB8zoF//pRboRmrpSQ1YEPNVDaKEW5PGuV2Tp/4odc3JJZZ5NdgYc1tNAZvoqRhRPC+ORHz0qHqKNU+p21dQXMYVSq2teZl9MdNuwge3BWhUEK1rsDm6dHomNfEf/B1Mg9UgJ2dtxvtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yao/MI+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yao/MI+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BC91F000E9;
	Tue, 21 Jul 2026 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654280;
	bh=SL6ENZCyK78zVMdMM0Kc/d4sfk9aA/GxeQCJShpENoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yao/MI+lvMqjULQrX1QaQPTlJJ3PdagfX1sAlRKs2u0On/4KI0sZ8QL08ygdNIn9Q
	 HI12vQiHVdLTt6Utp8MJFP9Vqi3cIhZM57JtcTURopZ/YeetV9HmcJaoVL0+OgIcao
	 r7giIA6NoohyBOvS5LuyOWCPwgvFvPMxyRBckU2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1644/2077] batman-adv: ensure minimal ethernet header on TX
Date: Tue, 21 Jul 2026 17:21:57 +0200
Message-ID: <20260721152631.528556919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 49df66b7993c80b80c7eb9a84ba5b3410c8296a0 upstream.

As documented in commit 8bd67ebb50c0 ("net: bridge: xmit: make sure we have
at least eth header len bytes"), it is possible by for a local user with
eBPF TC hook access to attach a tc filter which truncates the packet and
redirects to an batadv interface. But the code assumes that at least
ETH_HLEN bytes are available and thus might read outside of the available
buffer.

The batadv_interface_tx() must therefore always check itself if enough data
is available for the ethernet header and don't rely on min_header_len.

Cc: stable@vger.kernel.org
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/mesh-interface.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/mesh-interface.c
+++ b/net/batman-adv/mesh-interface.c
@@ -193,6 +193,9 @@ static netdev_tx_t batadv_interface_tx(s
 	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
 		goto dropped;
 
+	if (!pskb_may_pull(skb, ETH_HLEN))
+		goto dropped;
+
 	/* reset control block to avoid left overs from previous users */
 	memset(skb->cb, 0, sizeof(struct batadv_skb_cb));
 



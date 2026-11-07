Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063730;
	b=CJGaI239/mi10ZuTQcZ3NexVel37kM+ejO656fYWvDHw9w9fkCJf5zBi7wZWdHeSMRvE
	 Vt5QxHmZmewNA4yoTgKWLT9NT5UV1j/IvXRm5S5Spg2DVHb+W3EOFdKdwmyOPho+LQvIF
	 g6CYokRXEGBLSC0/KFxdydXIq9OJklDCn+xvZxbz7soCli69/uAySS9AgaFOiPG7TU/7P
	 VfAPck//RhVHcb0GQiWp9ffLtLZD0sKo3Dl3Ap14Fep8laESGUnF0milNNn3PUJB2CQAo
	 MxDSXPsnybDWTJbAhUMFNsfnIXIVa2Ki+nBd218Ib35E8GpX2r2Hdd6FNa2lq1l+wNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YBEzSSuuG9xRZtiZDTThQ/g8DMf+jTKMWMEttBqHw4M=;
	b=nS7FfmO+S8r1TNBQJ0sXCEqBwtqvz/TxyGbr/efrRjZRJnwIvY7TTykQI72t1r8WTS+/
	 7tA1g3YLhvZUrLTVLIaD5KXissc4tK0IKEctyG+5WepHBnglDnTzbRmU+aVd9CyfrDN5m
	 m4otEMPdksg7GaOBlCU/909Zwu1dMhOG2Zwn49AwnYK/YPhWPjHy4Wpu0kjttzhKqYTf7
	 THjSy5IRyvJAbz0zFmYFXHJ9S7wlupX2+RqHLRXgbPuHfChn6THUpWR5MlG5gT7rgMWTv
	 JkzYIIzdAMdVRTatKhkAphCA+WJ/jzF90U+IU1LJG3yM4G0FvAym3wcUlGiQXnDZM/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cfpSz/kI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE16A6083604;
	Sat,  7 Nov 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfpSz/kI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4D91F0089F;
	Sat,  7 Nov 2026 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063729;
	bh=YBEzSSuuG9xRZtiZDTThQ/g8DMf+jTKMWMEttBqHw4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfpSz/kIkEW3QeQjYi5fIh2lTs5bQuzbMj2MTJ7zOZtDXd0tVQb7kPvSNiQMOXymD
	 rMNLQR8NqONItfvT84wjQq3WEF/8Wb4NxXzuuQ9Cf06jQYrCSofH2oRy45WZZDzH0A
	 IBrz0VuGRP/f0ws+WtRDe/xJsnb1Zfz8m9wtDbhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 827/869] ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek
Date: Sat,  7 Nov 2026 08:58:29 -0500
Message-ID: <20261107134920.988388841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 1e860f42f41c6fbf3304f6a52be38245b9394982 ]

ppp_ccp_peek() caches a pointer to skb->data in dp after the first
pskb_may_pull(), then uses dp after a second pskb_may_pull(skb, len + 2)
in the CCP_CONFACK handler. If the second pull triggers
pskb_expand_head() due to a cloned skb or frag linearization,
skb->head is freed and reallocated, leaving dp stale.

The stale dp is subsequently used in CCP_OPT_LENGTH() and passed to
decomp_init()/comp_init() which read from the freed memory.

Re-derive dp from skb->data after the second pskb_may_pull.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 14fa87a8e0834..61c240d846ee2 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -3204,6 +3204,7 @@ ppp_ccp_peek(struct ppp *ppp, struct sk_buff *skb, int inbound)
 		len = CCP_LENGTH(dp);
 		if (!pskb_may_pull(skb, len + 2))
 			return;		/* too short */
+		dp = skb->data + 2;
 		dp += CCP_HDRLEN;
 		len -= CCP_HDRLEN;
 		if (len < CCP_OPT_MINLEN || len < CCP_OPT_LENGTH(dp))
-- 
2.53.0




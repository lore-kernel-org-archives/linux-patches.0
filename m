Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209688;
	b=HW/UP02QptRWiV6lhM93xaizahFXhOEYZSAVO3EsZaqFlvk9xwUSBCsTZphxSYVq/cLY
	 Gj9D4CFwfAS70WKMf1Dwyn/smtHq6AkiDgO8OvJq4Ftl/y6+5GOaRW74rUnm69A3U2ACS
	 3tGwFe4KM+5Hp02ko1Nai5akaGC4aBnu8kDAStuVmB8UNUkJkPK10Yaa+OypMOlXCNnL4
	 w6sa5umYji32IW0ZX/5OduaCMM9lu8XjaIVU3w9u/QsEk6gtqN9MY0Jn+oSvH/saZhh8+
	 hq7ii8xLnnzdZIj5Jt0aB/gMcUHssVvvJ+ZjRFVMyvM9yXLN3guds7klhYBPeoUn4aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Obpdyp9ixqGP4e7UCxvhoM7HRfwG/5QCntuI4nioJNo=;
	b=o4gPuYl/XMl4bG+HZPjakfnEvk3r2ogJx2V/IJqrF1ImFMRbm2Amd/Pav0js1xRkb2xF
	 11ID1IzO88XgbS0gBoZWA7+EBVefihcsEBsGUruEtCnr6Tq/syKsL0Z/k2AweFHx1Yk2z
	 GwXyKlUAa/dvSaQcAOIqio/yROk1xuzYES48n2zq5PTSS1Anvt1BABuXd9YH2nkoBIAye
	 nkAdPwzuqJzG+SyGNwPIh8/3W/qvfurnAgzf/tBT7MxeC/A+Wd/8e2tyB1JXkfC8rJLNY
	 P0h090sAEnluib83Ni8pgqxh8ESSBkKVaiWB0uxjMoeWLlTO90gGt0GXpMbonhlZeNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9QadCWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9883B606A31F;
	Wed, 28 Oct 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9QadCWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A041F01825;
	Wed, 28 Oct 2026 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209688;
	bh=Obpdyp9ixqGP4e7UCxvhoM7HRfwG/5QCntuI4nioJNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9QadCWASIfgxIJE6K2SDybCQuTsMbPCsNT8mOCk0GC07BxoRjnJpYzW4U5XJUSeA
	 1kvq5FqDunBExK8K8aEURQkjJaf5/BAMLE294BDN2kRyP5Way4OsQxlNUA6JJiuBoJ
	 JPuTky3jU8fcR4Mn/YXVdFNWXuL9NuAD/PTzQ3CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/109] netrom: require full NET/ROM headers in nr_route_frame()
Date: Wed, 28 Oct 2026 17:59:51 +0100
Message-ID: <20261028165942.536304742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

nr_route_frame() only checked that an incoming frame was long enough
for the two network layer addresses and the time-to-live byte, and did
so against skb->len without making sure the bytes were in the linear
part of the skb.

A valid NET/ROM network frame always carries the 5-byte transport
header as well, so anything shorter than NR_NETWORK_LEN +
NR_TRANSPORT_LEN (20 bytes) is malformed, whether it is for this node
or in transit. Use pskb_may_pull() for that length, as suggested in
review, so the header fields are also guaranteed to be linear before
they are read here or later in nr_rx_frame().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[F6BVP: taken from the nr_route.c part of Greg's "netrom: do some
basic forms of validation on incoming frames"; the nr_rx_frame() part
is handled separately. Switched from a skb->len test to
pskb_may_pull() following Simon Horman's review.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit dc06212ff6bb781fad2b5082e3ecb7cc93336da0)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 9cc29ae85b06f..7f55030e4b166 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -755,10 +755,11 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	struct sk_buff *nskb, *oskb;
 
 	/*
-	 * Reject malformed packets early. Check that it contains at least 2
-	 * addresses and 1 byte more for Time-To-Live
+	 * Reject malformed packets early. Check that it contains at least
+	 * the network and transport headers (20 bytes), and that they are
+	 * in the linear part of the skb.
 	 */
-	if (skb->len < 2 * sizeof(ax25_address) + 1)
+	if (!pskb_may_pull(skb, NR_NETWORK_LEN + NR_TRANSPORT_LEN))
 		return 0;
 
 	nr_src  = (ax25_address *)(skb->data + 0);
-- 
2.53.0




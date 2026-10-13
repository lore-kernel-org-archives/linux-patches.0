Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFB5199EAD;
	Tue, 13 Oct 2026 12:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896043; cv=none; b=RBS7gmV8HWgImAe8Q7hvgpQYMVQPYQ9/RxQiZPDovQqOFohhedIS4T8FzmQDVn5TTp8O/QNSFgK2pGw7Klcd5Aq1L9sExL2QjGWwurHYhluKwAa7aZDDwQZEAqhUqfSeKFXL3wk3ugrJA3ED3qYTBGQHnKcI3mXgoknAu9cCTm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896043; c=relaxed/simple;
	bh=B9UUNWtQyIRwZoM+aWeS1ZudMLstwvTjK4KnOTp9K8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I73SgrTA6i1jmRnwn1EGXIqMsnqkOTJwd7HEVpncelabTBhIHs7Hj0BeR5+2rjZKyUCFFiltFFhAyFafREoifl1Bd5hJxV5y1hIWK0bt8LVRsNjRjTYXJb/gFl1S0NCEX9z+O37BcHCOKle11vmecNuxZR4mz7hiaqhlHAjetig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lApW6ZI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lApW6ZI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A8B1F000FF;
	Tue, 13 Oct 2026 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896042;
	bh=yAePP47HXlLP01C7Z/aAE+At+bMd4SpEsznGnIaoKqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lApW6ZI6AO2+9o5t6pYqpGY/75Swpe364WPjjn6oJrw5Ak2oMWm82MOUfWmJYuZD7
	 +xLtwbbWYTNaogt2wfw2M87BMcq3whj7AdoCZUf/dCWBVC6tMtOD99zZqP/2d0+uWP
	 WOV8WeHPy/yNXNEPZUerSDxOUpkYLA8c/rBOJCGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/497] pfcp: make sure the SEID is linear before reading it
Date: Tue, 13 Oct 2026 13:40:46 +0200
Message-ID: <20261013112919.247408200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit 23609bce9e1de525d1d0e73fc68c6e7971d0b49e ]

pfcp_encap_recv() only makes sure that the UDP header and the 4 byte
PFCP header are in the linear area. When the S flag is set,
pfcp_session_recv() then reads the 8 byte SEID that follows, which is
not covered by the pskb_may_pull() check.

A short PFCP packet with the S flag set, or one whose session header
lies in a fragment, therefore makes pfcp_session_recv() read beyond the
end of the packet data, and whatever it finds there is stored in the
tunnel metadata that flower later classifies on.

Pull up to the end of the SEID before reading it, and drop packets
that are too short to contain it. Reload the header pointer afterwards
since pskb_may_pull() may reallocate the skb head.

Use offsetofend() rather than sizeof(struct pfcphdr_session): the
structure is not packed, so its size is 16 bytes because of the
alignment of the __be64 member, while the header on the wire is only 12
bytes, and valid session messages would be dropped.

Fixes: 6dd514f48110 ("pfcp: always set pfcp metadata")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Link: https://patch.msgid.link/20260930124818.114224-3-yanhaishuang@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pfcp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/pfcp.c b/drivers/net/pfcp.c
index 01dbdcbcdc64d..91837fc970821 100644
--- a/drivers/net/pfcp.c
+++ b/drivers/net/pfcp.c
@@ -64,6 +64,13 @@ static int pfcp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	unparsed = pfcp_hdr(skb);
+	if (unparsed->flags & PFCP_SEID_FLAG) {
+		if (unlikely(!pskb_may_pull(skb, PFCP_HLEN +
+					    offsetofend(struct pfcphdr_session,
+							seid))))
+			goto drop;
+		unparsed = pfcp_hdr(skb);
+	}
 
 	ip_tunnel_flags_zero(flags);
 	tun_dst = udp_tun_rx_dst(skb, sk->sk_family, flags, 0,
-- 
2.53.0




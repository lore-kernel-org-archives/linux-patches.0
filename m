Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A513D5C06;
	Tue, 13 Oct 2026 12:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894512; cv=none; b=tR9aoiUgMgwl2cy7xUyaInbXJXdYUEgbszQeCdh11n1326I+1J6yefXuhDvoCB2SZAIVngCPzWD083yxbQpoCx+ia3MorQ6llegeJnkmBtjsgYwOII+ogcQIJ2GMCaWM9V+8JzUROM8WqFUPhw5gw7+DlEvsb/RuwQzYR8e3SI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894512; c=relaxed/simple;
	bh=ERmCImSjVOdEKSHk8P7VTRb7GuSpxd6izU7q/6czXnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5GaEzl0wfkcXMauH6mfj1BNpJ02SIIGjFdJc+rFTs3whZlEMJrsfXAH2d0Ln31oc/Wm4WKg9b+q1AbyyaCo0qhhrSZyAJIriHOF+dr3WNt6ya3nY97yILuuzNSq5NeL8v1bJutisXj9iT4IJ/wTluKD64lWetlAH6cCbsRIRXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1iK+ffQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1iK+ffQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2A91F000FF;
	Tue, 13 Oct 2026 12:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894511;
	bh=k+0Is3ORh/5sNLBL4GiQJ2cnapXQT1s1dE3Z9tAAskE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1iK+ffQaQ1h3j8Ab0vPJEM0vWlMajNJ9/Hcfc/mlKc5hfxxQkLYk5mP0PCE2nQJr
	 0yUld76VRue33kP+yiRzIGZCFHAGjho551CLj7ZIQDqJJYhJ4+E+6Uq/FGD34RhbUS
	 jOeToiESqsV2ZUUzpXux9MMZ2A6JH3v8PHU2g//Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 586/621] pfcp: make sure the SEID is linear before reading it
Date: Tue, 13 Oct 2026 13:39:41 +0200
Message-ID: <20261013112934.708179332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c1c8eaea63fc3..e61bf33c4ce6b 100644
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




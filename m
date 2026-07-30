Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F41430567C;
	Thu, 30 Jul 2026 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425747; cv=none; b=T/aBoV+aBG0YqFH/laXhDr7vQnODRXl0Y1Euk9bM9PTAH1/H3xe5zysd6KZpvABDmmiu3aDTA8QmAxWGfru+GEOPVhAvscYYJcIaZmYIM/X6jzDZ1jukpoCrSUuwx21wfJ8qZ5qcdBD3VEwhWqfFwEX7T6amPEl38BHfNWMlprA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425747; c=relaxed/simple;
	bh=84A9bBmuLb+YgEQ8grlfMamia5cLhNYZqEQAh+bNzIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm6eCqoBsrBtVgH4xo/jR3+uh3FiKhHgKrYzXyPZa/g/Z6ddYN0z50Xr2wdJDOf+9qoBpJdh04I/1Kc5DwKn4vrO9Vq+xEX4g5Xdxtipv5d5fId0EN3zWl1o5N9hFFaZTW6EatJ8R4BU3KTXjw9KQMlQiUEgjnSTqLT4Rm6PV/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdPY2KUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdPY2KUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A1C1F000E9;
	Thu, 30 Jul 2026 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425746;
	bh=q1mFy66LGfosIdzJU7T0HEzoCUl7gSah4GD2L0reV2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdPY2KUSpxTmOD+HopnUNu4+aU9/bNV/mqh/yfL6TtxNxDEBtjU+7vpUZEAm9V1KE
	 zyyAoPp6nEjHe1RGRbohyEHIrAmtQrsO2eq+qcGd6oY/xeUl8OYlLX9VaNJxRHedk9
	 IcG0Z4x4kHt0Mg6hnTDoBs2KFBqMVBj3p3U15R3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixing Chen <running910@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/602] gtp: parse extension headers before reading inner protocol
Date: Thu, 30 Jul 2026 16:09:28 +0200
Message-ID: <20260730141439.665951283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Zhixing Chen <running910@gmail.com>

[ Upstream commit 96e37e2f618e931aa97af95e707dcdfb1ec41264 ]

GTPv1-U packets may carry a chain of extension headers before the inner
IP packet. The receive path already parses and skips these extension
headers, but it currently reads the inner protocol before doing so.

As a result, the first extension header byte is interpreted as the inner
IP version. Packets with extension headers are then dropped before PDP
lookup.

Parse the extension header chain before calling gtp_inner_proto(), so the
inner protocol is read from the actual inner IP header.

Fixes: c75fc0b9e5be ("gtp: identify tunnel via GTP device + GTP version + TEID + family")
Signed-off-by: Zhixing Chen <running910@gmail.com>
Link: https://patch.msgid.link/20260708042244.120898-1-running910@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index d7f644dfaa8d9e..dc4770e79990f0 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -821,13 +821,17 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if (!pskb_may_pull(skb, hdrlen))
 		return -1;
 
+	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
+
+	if (gtp1->flags & GTP1_F_EXTHDR &&
+	    gtp_parse_exthdrs(skb, &hdrlen) < 0)
+		return -1;
+
 	if (gtp_inner_proto(skb, hdrlen, &inner_proto) < 0) {
 		netdev_dbg(gtp->dev, "GTP packet does not encapsulate an IP packet\n");
 		return -1;
 	}
 
-	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
-
 	pctx = gtp1_pdp_find(gtp, ntohl(gtp1->tid),
 			     gtp_proto_to_family(inner_proto));
 	if (!pctx) {
@@ -835,10 +839,6 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 		return 1;
 	}
 
-	if (gtp1->flags & GTP1_F_EXTHDR &&
-	    gtp_parse_exthdrs(skb, &hdrlen) < 0)
-		return -1;
-
 	return gtp_rx(pctx, skb, hdrlen, gtp->role, inner_proto);
 }
 
-- 
2.53.0




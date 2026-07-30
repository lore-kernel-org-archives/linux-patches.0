Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B962D31E831;
	Thu, 30 Jul 2026 14:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421835; cv=none; b=a/oRyrdxyyxwP2FOGaxOD8XoSt6WXn6k2WXJyQYI1qrZZPMOOCKrFD9OeSG329pxkulEsuHtWoH7IPUiAIP472oB4IN5oFia37Aq0xPmnMj8lUMQZ+5lQrTWhXDnjPS6u9RDWguJpI8e+UUEzOgJprp40uLTP6zeqpMRkkn5SkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421835; c=relaxed/simple;
	bh=o/niBpsHRmDWfiGwt7RBuxM24h4vfRBufgL5M/A8vnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d83vgpCHCCZTsq8wAg1GOcokI7g+RsUConkNmU+hZi3UGlyrptycV0CwNicZMamHIl8SKVMCwvtSYyv64KjO7gqop1UVs+KFnoN2VqsS4zHh3eV+Xd5PA5M0njbVmZj2vx5oz0mNUAxbBWwlC3nsLNJ1Z0lJ71IANg62BHGeelA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcp74f24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcp74f24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D781F000E9;
	Thu, 30 Jul 2026 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421834;
	bh=CkjSOll5nnN1VVE5tB6mmCNSbbOz2v5Y8Er0ZDeChtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcp74f24lQKk+U3yTFrIEj2ymDOs5/Gc5tGjXWR0gDY1+ZdyF7VlrWjw7Hm+ndWIb
	 m1/RzIpk6Fv2hlw1ImBv8noQ/v+I8l+DP49MyNmYxLmLn/egPlEPlEVIfVoPknucHb
	 p1mGEtvSt8kvh404muzutFxidf4yKx2bd+sXkiDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixing Chen <running910@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 237/744] gtp: parse extension headers before reading inner protocol
Date: Thu, 30 Jul 2026 16:08:30 +0200
Message-ID: <20260730141449.330405428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
index a60ef32b35b825..c0e38878af51b3 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -826,13 +826,17 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
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
@@ -840,10 +844,6 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
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




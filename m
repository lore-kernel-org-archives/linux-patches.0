Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1B9363090;
	Tue, 13 Oct 2026 12:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894903; cv=none; b=QHVV9JiWBrQeTF22kTYlYWyYMhuVtySW4J80dKhUPQOu46vSiOXzMDFEYpEZS8puOB6wh0SkmSvv50t+SQS+XTjKGqOoUkF+1e3d0Oo7owtC/2aAskZ3p1KV97vYJwD/VpLOGzyx2w+TBBwyDUOlwmfQXX1IvOxMFNIaIoBFNIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894903; c=relaxed/simple;
	bh=Fy++DWfNBSccfCpvJktWNmCksprTe1nJyKZgKQ/2yAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djLSP5kaXCUHO7DG3v4gQE8w3u0E4vNm2uTrtpNpSs4GLeaKFT6YGkjHzgOB6rkqJTxHBR+A3g7BaSlNe4Q4AxKM6KNWoSynVgwpGy/8VSLQdUqyQ5LAp+QcHNJ+/zhmP3iQYDZYH0mgMZWkQB5hdIRAt5/nLDnu68oZpwvHh0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSKKB7dE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSKKB7dE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC01F000FF;
	Tue, 13 Oct 2026 12:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894901;
	bh=bgIYArvVAe5lREiLi8pQWH2era82zzFFzpEzdFbRt88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSKKB7dEnIJscHd4nlNBVqfZ3pbjJlhtBYYzAEBZYdqFR4++WmHYgL0RuACfFn49D
	 vytswOM3rLXm4GLRXbuWkOcm0f15Qr6A08Ph1x3SmQIlYK/7EPQC2Pst9oRY+2Nqzh
	 sryAhG2kcDdiiivBfWmlkm3zSY8XRsT4e7U+2yOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/497] ipvs: do not create invisible templates
Date: Tue, 13 Oct 2026 13:34:23 +0200
Message-ID: <20261013112910.169190368@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 616cf5c06934364ab1002b420ebe975850b4b208 ]

The IP_VS_CONN_F_ONE_PACKET flag was implemented for normal
connections. When conn template inherits this flag from
dest->conn_flags it will not be hashed. As result, we will
create new template for every new normal connection.

Fix it to allow one template to be used by many normal
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260916231652.127456-1-pablo%40netfilter.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index d7a7e26e9c697..1dbb61fff18b0 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -591,6 +591,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
+	/* Only visible templates can control multiple connections */
+	if (flags & IP_VS_CONN_F_TEMPLATE)
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
 		/* Synced conns are hashed, so they can not get this flag */
-- 
2.53.0




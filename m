Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E6B3EC69A;
	Wed, 30 Sep 2026 19:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795164; cv=none; b=ImwvTSfFjiIP4FC3uDq5MIZMwcVSkPVOhnf+sZXF1aQ4biifZkTYeoRlJoBN7CpGhMJfWti4tT6y9akrRUP+FDkqjmZqWy1uCsm2jbDKz/4LBXuC9C3CUcTykYXUfKPNsBFqImsOcE/EFoDHAi3Sy5RogabuzU4CY1EaOp7HzD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795164; c=relaxed/simple;
	bh=9G3hvBLzRhyH/vCkyRWci6g5sTJMbf/7wISUGj+gsF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc4YOAIjXiIWwX88wJETq7Q1ukuTdR+BeWWog754XmpXNUe0+RNSoC1KGRLzcDpbo+z9N7pzycp0nw8dRUm2MTjRLDIYOD1VU/L6PbqOccK1O5BREEFlsoWe7CFe6FzkuHsd1uPc3e7JHq8TtCOrw/D04nmiYunexiISscAzzWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n64h6p1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n64h6p1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677991F000FF;
	Wed, 30 Sep 2026 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795162;
	bh=hqUSVosXXWmMMYoPNLZApf3hr+u46F3FluvGor2hiVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n64h6p1ezE5qaKjKZEURQoJP7Sc979ktkg6fgfrFIshKccIHQCfmFHpHrFi6bHig/
	 +k3JFntzj9jTKYWbuYsc+jaRsOy1OXFWMDpJp5a9LDnO0772rndSirVdMpVrHz5FPX
	 hhfBlEyPKG/VLHraPQN3KoqlfRA+aqrbT57tKM2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0463/1193] ipvs: fix reversed sequence option serialization
Date: Wed, 30 Sep 2026 17:19:07 +0200
Message-ID: <20260930152444.459527831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit b04578b74f2d3755548fe9e829e3b2a6c6f966a1 ]

hton_seq() expects the host-order source first and the unaligned
network-order destination second. The version 1 sync sender passes these
arguments in reverse for both sequence blocks. This leaves 24 bytes of the
kmalloc-backed message unwritten. It may disclose stale heap data and
replace the live connection sequence state with values read from the
buffer.

Pass the connection sequence state as the source and the message payload as
the destination for both blocks.

Fixes: 986a07579533 ("IPVS: Backup, Change sending to Version 1 format")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 515346bf915ae..50d98f191b0c9 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -748,9 +748,9 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
 		*(p++) = IPVS_OPT_SEQ_DATA;
 		*(p++) = sizeof(struct ip_vs_sync_conn_options);
-		hton_seq((struct ip_vs_seq *)p, &cp->in_seq);
+		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
-		hton_seq((struct ip_vs_seq *)p, &cp->out_seq);
+		hton_seq(&cp->out_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
 	}
 	/* Handle pe data */
-- 
2.53.0




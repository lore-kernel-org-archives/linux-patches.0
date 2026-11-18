Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031809;
	b=G2rbw0FD4rYEQJrLBHqyC8lNvvaZWopt2dHZ2wIJ1o+6/tbFge1MjesvygXvg1FiPoD5
	 70pbQXRnelFiTB2yPrm1cjCabT+Z8RMfE8qfgkLTvkMgcOd/kZAEF8YsVBeJRRnVsW3s/
	 CFsFMxkWzOhCUQuJK9c4tD20MDwnWmikhiVzcd/2ssf64EbtEQStOMKd2/O58xVUFBfwl
	 I+Na4NrxOh+dJ7raYWqIbtSrdGpy0VtxHznIbn3zqASQKSAteP4yj23i5Yfp1O5NHwvAJ
	 yz2C4HVPk3zEZaPWXHa0eUWSb4kXVeUv7gbnV9/z8JYkEbfMZsI6gfXWzkMWLQ/N18Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WpVvHHAsl/wLHYesX+F5cuncrR3qrV4VXL/BC9x2Xd0=;
	b=PEDlbgV8yUXYIX4M+Ocs4I+8k3laMLDCLCmqou6GY3nvgEwzohvNYxqFb9/3xmOmKeot
	 YLHQlgg08VeaAYzEgRVub26woOo8+IGtr/Ms9Re3QLiZy4wNK+i63UEqqDrBA3EUfVfo9
	 A3eTU4KHRC1rJJtFf3fYbO3nKwrbODbWYR6FkLg27G9Xpvm0S4DeSYdPcFzKoRhr438Io
	 G8hz7TgYiW0NIOMOUXEVjn4fElYd1g5po0O6SrYWe5ZxIbDMDQnojH4GaZha7rHpJtFbL
	 9+GOh4grtLznqUa8bGSpdJIu2qJGYCxwm2SNiwWVzOO6OfR7Ulpoju08G7DjH2kG3qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SX4EdC1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C024606A32F;
	Wed, 18 Nov 2026 19:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SX4EdC1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B3D1F000C4;
	Wed, 18 Nov 2026 19:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031808;
	bh=WpVvHHAsl/wLHYesX+F5cuncrR3qrV4VXL/BC9x2Xd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SX4EdC1azxx+T08MjX2T9rzrGy5c5lmqg4TgnHSR8UWGud3XFEJXijBapcNZi9Nhw
	 Vzs629rR1ItMcrrJYt+gSlIN6NGwn1Umdcetfdgyo021Ggvh/akG92p1VGHPL4HsLc
	 b8e1aoMpc77Dd3yVtfWXZJ6jwtY2JNK7ggvtVPgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1187/1756] ipvs: fix buffer overflow when sending sync messages
Date: Wed, 18 Nov 2026 15:55:14 +0100
Message-ID: <20261118150057.151304738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 3e3fe49e8678c1a3d535ed02f32a9a6e80674263 ]

Sashiko reports for possible heap buffer overflow when
generating sync message for the v0 and v1 message formats.
We should read the cp->flags only once because another
CPU can concurrently set the SEQ_MASK between the two
reads.

Note that IPVS does not set the SEQ_MASK anymore for the
ip_vs_ftp.c helper starting from commit 7f1c40757951
("IPVS: make FTP work with full NAT support") (2.6.36+),
so the problem should not be reproducible.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20260903004149.1037028-1-pablo%40netfilter.org
Link: https://sashiko.dev/#/patchset/20260909111338.44357-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index b835f61886d6d..0036008fee65f 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -544,13 +544,15 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	struct ip_vs_sync_conn_v0 *s;
 	struct ip_vs_sync_buff *buff;
 	struct ipvs_master_sync_state *ms;
-	int id;
+	u32 flags, seq_mask;
 	unsigned int len;
+	int id;
 
 	if (unlikely(cp->af != AF_INET))
 		return;
+	flags = READ_ONCE(cp->flags);
 	/* Do not sync ONE PACKET */
-	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
+	if (flags & IP_VS_CONN_F_ONE_PACKET)
 		return;
 
 	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
@@ -565,8 +567,8 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	id = select_master_thread_id(ipvs, cp);
 	ms = &ipvs->ms[id];
 	buff = ms->sync_buff;
-	len = (cp->flags & IP_VS_CONN_F_SEQ_MASK) ? FULL_CONN_SIZE :
-		SIMPLE_CONN_SIZE;
+	seq_mask = flags & IP_VS_CONN_F_SEQ_MASK;
+	len = seq_mask ? FULL_CONN_SIZE : SIMPLE_CONN_SIZE;
 	if (buff) {
 		m = (struct ip_vs_sync_mesg_v0 *) buff->mesg;
 		/* Send buffer if it is for v1 */
@@ -598,9 +600,9 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	s->caddr = cp->caddr.ip;
 	s->vaddr = cp->vaddr.ip;
 	s->daddr = cp->daddr.ip;
-	s->flags = htons(cp->flags & ~IP_VS_CONN_F_HASHED);
+	s->flags = htons(flags & ~IP_VS_CONN_F_HASHED);
 	s->state = htons(cp->state);
-	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
+	if (seq_mask) {
 		struct ip_vs_sync_conn_options *opt =
 			(struct ip_vs_sync_conn_options *)&s[1];
 		memcpy(opt, &cp->sync_conn_opt, sizeof(*opt));
@@ -636,6 +638,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	int id;
 	__u8 *p;
 	unsigned int len, pe_name_len, pad;
+	u32 flags, seq_mask;
 
 	/* Handle old version of the protocol */
 	if (sysctl_sync_ver(ipvs) == 0) {
@@ -648,6 +651,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 sloop:
 	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
 		goto control;
+	flags = READ_ONCE(cp->flags);
 
 	/* Sanity checks */
 	pe_name_len = 0;
@@ -675,7 +679,8 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 #endif
 		len = sizeof(struct ip_vs_sync_v4);
 
-	if (cp->flags & IP_VS_CONN_F_SEQ_MASK)
+	seq_mask = flags & IP_VS_CONN_F_SEQ_MASK;
+	if (seq_mask)
 		len += sizeof(struct ip_vs_sync_conn_options) + 2;
 
 	if (cp->pe_data_len)
@@ -721,7 +726,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	/* Set message type  & copy members */
 	s->v4.type = (cp->af == AF_INET6 ? STYPE_F_INET6 : 0);
 	s->v4.ver_size = htons(len & SVER_MASK);	/* Version 0 */
-	s->v4.flags = htonl(cp->flags & ~IP_VS_CONN_F_HASHED);
+	s->v4.flags = htonl(flags & ~IP_VS_CONN_F_HASHED);
 	s->v4.state = htons(cp->state);
 	s->v4.protocol = cp->protocol;
 	s->v4.cport = cp->cport;
@@ -745,7 +750,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 		s->v4.vaddr = cp->vaddr.ip;
 		s->v4.daddr = cp->daddr.ip;
 	}
-	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
+	if (seq_mask) {
 		*(p++) = IPVS_OPT_SEQ_DATA;
 		*(p++) = sizeof(struct ip_vs_sync_conn_options);
 		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
-- 
2.53.0




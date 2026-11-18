Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061075;
	b=1y35RSGUdV2vKLV8edg9d1abLuGPxdmFYVwqixSWKS1qs7SgJP1AS649AtjLe4JsAuqd
	 VR1suEGTj4K9FXtBt8R+dnodpsjHzf1k4yt/GVlndVvsSy8d0Md2lbXGmyP4zAS0cc10n
	 89dmCqb/bYM8IqYDhF3bRdH/jUuMq9zvhrc8APzlFMy2UM6vE+moS4JtJvymw2nQuRPv4
	 wvHnJNs4IoBzjut32rm236nFuA4yx+/H9zOQuJ5hrCWVgMy8alN4S1VD3636kOL1GXVr0
	 tJJpy78Hn5k3ANOcprzlgli1Me9yKSxWhRT3AcTmWAy6+CKl437F3bAB0ECMtWVQvOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rXh3aADsfJDAM3DOT9F9OMLyqvvfBRE7IhUXd37fYk8=;
	b=au7a4kJNh410rnEi+z17q9hgumezoSa0FBDtbpZG6rGCqL9GIAdVXtPip+ByhS8Chq99
	 R37FkI9MYK0RCd686tVwDk5PDwqT/qNMKDcX00xS6U+A9d5Lp4Eot+x2LkEIlCnr3Fhsn
	 iZ1ugDniiIO/qb3Y4/zFPuFzzDr14CP5nDPetKE9ya4sAibb/K0cx7GQvhGl9I5DrYB67
	 gY6zaFRv4drUxpDBbCL+876I6cLPVG65pg4Rw9N6E0XlXpiy7lFewo8pzJtH+Zs0CdX2Z
	 3hxNhOi86fi6ZzUElKsZvv4/pXES1uCVDfp19OqAxfeRW7CVNa+DUuiuq6/O3uEetyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13wd95b4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E53B606A320;
	Thu, 19 Nov 2026 04:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13wd95b4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FBD1F000C5;
	Thu, 19 Nov 2026 04:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061075;
	bh=rXh3aADsfJDAM3DOT9F9OMLyqvvfBRE7IhUXd37fYk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13wd95b4sc2cpOd7Wp7sZGJ/3cJHLJd2BeT/CMnbXej/53dNetK5X0tilVXH4hUxN
	 16H6+f9YPOib3660SH5G+Q/dfETodEZb0GXzPS/1bGY0IBQqIwDBHABN0x6dWJb+id
	 jRojZpnvej5R2+5EQ9My5L1uhLyBNuhIqkrkM5HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1372/1848] netfilter: synproxy: fix reset of ct seqadj when reopening a connection
Date: Wed, 18 Nov 2026 15:56:50 +0100
Message-ID: <20261118150016.976460629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit a8708aa9fe1095ca7859cb3f102b6a3fa0fb98bd ]

SYNPROXY is resetting conntrack seqadj when a closed connection is
re-opened, but it was using nf_ct_seqadj_init() which is a no-op for a
zero offset.

This patch introduces nf_ct_seqadj_reset() which sets the offset values
directly to zero and avoid setting IPS_SEQ_ADJUST_BIT flag, it changes
SYNPROXY code to use it when needed.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_seqadj.h |  1 +
 net/netfilter/nf_conntrack_seqadj.c         | 17 +++++++++++++++++
 net/netfilter/nf_synproxy_core.c            |  4 ++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_seqadj.h b/include/net/netfilter/nf_conntrack_seqadj.h
index 0a10b50537aee..df90bec7b7670 100644
--- a/include/net/netfilter/nf_conntrack_seqadj.h
+++ b/include/net/netfilter/nf_conntrack_seqadj.h
@@ -33,6 +33,7 @@ static inline struct nf_conn_seqadj *nfct_seqadj_ext_add(struct nf_conn *ct)
 
 int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		      s32 off);
+void nf_ct_seqadj_reset(struct nf_conn *ct, enum ip_conntrack_info ctinfo);
 int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		     __be32 seq, s32 off);
 void nf_ct_tcp_seqadj_set(struct sk_buff *skb, struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index bcb4adf9879dc..f570060035f71 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -29,6 +29,23 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 }
 EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
 
+void nf_ct_seqadj_reset(struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	struct nf_ct_seqadj *this_way;
+
+	if (unlikely(!seqadj))
+		return;
+
+	spin_lock_bh(&ct->lock);
+	this_way = &seqadj->seq[dir];
+	this_way->offset_before	 = 0;
+	this_way->offset_after	 = 0;
+	spin_unlock_bh(&ct->lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_seqadj_reset);
+
 int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		     __be32 seq, s32 off)
 {
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 4a742dda15da7..db9dcdf07a394 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -709,7 +709,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
@@ -1137,7 +1137,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
-- 
2.53.0




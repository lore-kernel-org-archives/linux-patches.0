Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048775;
	b=erC1Csx8ajc0zKLSiw6SbHWjvpDoxXHS6uzV++ETli/l0t9dshIVTAgMfJBGhkaT1C7k
	 Y7W4T6AtCfcisyUh2yM4OBnfxRBxsO3UyDsJ6dUZ03hyMi4pl/o3G7uDP9XR0AJar/vwR
	 S132WNoyrApKXMOmARKI23WsdTe8xU9Osqu2a/QF/ettNuJfnhv0fSNQAJuO6NF0D18Cb
	 KSbX9oxMS85/bixTHh+wG4t/JuUQDNRrn+xGydPxrJc7+RyE9w0k0ArKkkSosRbe0cyCZ
	 dIhhx4q3v4W0nveH8H0VzZV0qSM+urr0wjfAfPsBUa70+J0UqAmjpSZafVDAjfZx9bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4clMwevR6uPQJWLtHOLlESBbEovbjJDSDbsCax+P1M=;
	b=kiwhojl4SNXwZEePz1Qkkbb3AXq151DtV2nxk4veXMBn6y/MkNZ5tlOL2ZIn/mcpsU+e
	 U/B4udzbb91f4mczK3AQx2WoH9y2diHaYMiXQX6t3sOAvgwcpzwj12R6VgB8esq5ylYYX
	 GFGVVnDbqn+NQV/E7OfKM0CtuyqcjhyHOJ8aGlJNOun++6Hnsez7AZaV8sZ8Cz7DpUio5
	 K2g5ukd4GLTS8WRyvsrhHC4ev1lAAwh13t0/LQAqHQewhvrbhrbjQ4WvJ/Ns9FbwZ3yIV
	 Tj6CoBLipG48MW/OHITAz4N/VNd3wpM1sB1r8IWUiuoRVg2/LiZkS7aNOqKAJDchMFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1gO0tK9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4C2606A320;
	Thu, 19 Nov 2026 00:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1gO0tK9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22421F000C4;
	Thu, 19 Nov 2026 00:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048775;
	bh=P4clMwevR6uPQJWLtHOLlESBbEovbjJDSDbsCax+P1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1gO0tK9qUUg+uKEdLfwre8uQjzK0/QYwpnW2wYi3OgKxMTfalRYxam0st6qbfcC5
	 K28qNfvCUaV9JW3P3/VFUaiy+YuLDwJ99Ff/kg5gEut1DtCK7S49/7mPJ0C1E6y+0z
	 QvBOhOVMG0LEzmFRMtPw3gNT9ihsKe8KwnQUhg40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2078/2857] netfilter: synproxy: fix reset of ct seqadj when reopening a connection
Date: Wed, 18 Nov 2026 15:51:52 +0100
Message-ID: <20261118150316.230546723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 883c414b768ee..0f5bbb14a25aa 100644
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
index b7e99f34dfce8..8dba6a0d5dc21 100644
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
index 35c38c3268a6a..4574bf40540b4 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -685,7 +685,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
@@ -1115,7 +1115,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
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




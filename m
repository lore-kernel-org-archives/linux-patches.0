Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208596;
	b=Wtx6t4OsTt45p5vI6KzMAq2zuwENyw8QbZOntGsS7H37XybSktZt1wqt4uNqglNtenQm
	 6cJj5UWibvj/CFoKnMf2NpIOLwfGBGa+O5JTvZnYIRRe15/wDcPdp7mhB8/KnnyBcI5pd
	 xxQbBcyAUEGbTdVGV/lV6A+SpAXVM2y+WmuN1P5KcZdLiE33A5gv1+qTYcxVIw7RTXwn9
	 D8x5tJrzzojmqaxpuxpAc59aMiOJB8Hogj1p+xcAIXb/un2zpw1CkHvrHTAoCHIW5UjGf
	 DP2eNL7qcatE+9QLZY1G1PI9KhkzndfRQHK5WhVkt53JljiuYos7D7q62gJUgdHFN1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PEDBfflVI0lo4keNEk0uvYZc1wMTZln1OFd7gx/FTgc=;
	b=rekjTcCNscV2q6xYOS61d/343KxcUUbtVvGAPPD4RyLumt/YoZCFTcc+VoUbke6Bmia0
	 GWBElXDl17JLnvLAghw/ub2PCccfHkBcVgPgQZehqklqrqulfm4KbFAhwysL4PdP6GM2u
	 VtbZ4WL2u+r0I33l2G0g7Yozqu57q5S7xdDsKcdA95Ycecsdk6XcbtH+Ght+144kWNZZF
	 RO3L8o7TAd0JpA90iKU82dNAkGIdU3kdFeadrMG3qgq/3okjuxF1RhE5M8/uLGWiSAP3g
	 pcgmE4yI4dLq/bJnmPBdgqNQ5G1dRmrf9ngGLRjUweNgm4YtVJCMmDhrhU0ROlIfcfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bgjyrepj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5DD606A31A;
	Wed, 28 Oct 2026 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bgjyrepj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901451F01825;
	Wed, 28 Oct 2026 17:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208596;
	bh=PEDBfflVI0lo4keNEk0uvYZc1wMTZln1OFd7gx/FTgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgjyrepjmLcvEIyBw4Ouz+RIlLYT++GDThP9HykB8t50sEQAMNgpQ5svi8QwbBKD1
	 8rdWPU930XiX5Fp/ki7QpTVbj5MwJNTMDxt6QxKDhW3JbRa4sttljvYJ+GdW04KcNx
	 xycCtemyXSVLMF7p0uzsIt2TXuU50SuXU11UsNvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/516] ipvs: filter some flags received in the backup server
Date: Wed, 28 Oct 2026 17:55:26 +0100
Message-ID: <20261028170007.628260282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit f96e91748f6304668fe647e686d199d7207d36f1 ]

While the IPVS SYNC protocol is not secure by design
we can still protect the backup server from messages that
can wreak havoc.

This commit addresses problems from received connection flags
or their combinations. We now drop messages as follows:

1. the NO_CPORT+TEMPLATE combination allows lookups for normal
connections to hit template which can break in many ways.
While the master does not sync connections with NO_CPORT flag,
i.e. before they are established, we still accept NO_CPORT
without TEMPLATE.

2. ONE_PACKET: it is not sent by master, so we do not
expect it in backup. Before now it was ignored by
IP_VS_CONN_F_BACKUP_MASK for protocol v1 while protocol
v0 created connections that are not hashed and dropped
immediately. Better to apply the IP_VS_CONN_F_BACKUP_MASK
also to the flags from v0 messages for consistency with v1.

Fixes: 87375ab47cd0 ("[IPVS]: ip_vs_ftp breaks connections using persistence")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index f5c1724320177..57a9f3542f171 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -950,6 +950,21 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 	ip_vs_conn_put(cp);
 }
 
+/* Check for incompatible flags */
+static bool ip_vs_sync_validate_flags(u32 flags)
+{
+	/* We do not expect NO_CPORT, especially to allow lookups
+	 * to hit templates
+	 */
+	if (flags & IP_VS_CONN_F_NO_CPORT) {
+		if (flags & IP_VS_CONN_F_TEMPLATE)
+			return false;
+	}
+	if (flags & IP_VS_CONN_F_ONE_PACKET)
+		return false;
+	return true;
+}
+
 /*
  *  Process received multicast message for Version 0
  */
@@ -973,8 +988,7 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 			return;
 		}
 		s = (struct ip_vs_sync_conn_v0 *) p;
-		flags = ntohs(s->flags) | IP_VS_CONN_F_SYNC;
-		flags &= ~IP_VS_CONN_F_HASHED;
+		flags = ntohs(s->flags);
 		if (flags & IP_VS_CONN_F_SEQ_MASK) {
 			opt = (struct ip_vs_sync_conn_options *)&s[1];
 			p += FULL_CONN_SIZE;
@@ -987,6 +1001,13 @@ static void ip_vs_process_message_v0(struct netns_ipvs *ipvs, const char *buffer
 			p += SIMPLE_CONN_SIZE;
 		}
 
+		if (!ip_vs_sync_validate_flags(flags)) {
+			IP_VS_DBG(2, "BACKUP v0, Invalid flags 0x%X\n", flags);
+			continue;
+		}
+		flags &= IP_VS_CONN_F_BACKUP_MASK;
+		flags |= IP_VS_CONN_F_SYNC;
+
 		state = ntohs(s->state);
 		if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
 			pp = ip_vs_proto_get(s->protocol);
@@ -1142,7 +1163,13 @@ static inline int ip_vs_proc_sync_conn(struct netns_ipvs *ipvs, __u8 *p, __u8 *m
 	}
 
 	/* Get flags and Mask off unsupported */
-	flags  = ntohl(s->v4.flags) & IP_VS_CONN_F_BACKUP_MASK;
+	flags = ntohl(s->v4.flags);
+	if (!ip_vs_sync_validate_flags(flags)) {
+		IP_VS_DBG(3, "BACKUP, Invalid flags 0x%X\n", flags);
+		retc = 25;
+		goto out;
+	}
+	flags &= IP_VS_CONN_F_BACKUP_MASK;
 	flags |= IP_VS_CONN_F_SYNC;
 	state = ntohs(s->v4.state);
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8516255E43;
	Sat, 17 Oct 2026 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259471; cv=none; b=WL+Gz4+cSm4vgg3Qw5/geRJyMULnC3ESv72B/Syy/VClgP+9L/ETbt9ESoLXN98sWKvj0L6bcfbeKE9Z5Rx5zSTWzkYhkt2cwN4LlAIRj1rocAB2V/z0vhYpOGnByzJeZAQNpvJ+NhD6wF8W1ZKbKX6qG+OBeIQAoJuKXcIYL88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259471; c=relaxed/simple;
	bh=Eqr8qqnbCRjkPF877EGY61ERDXMQFfHx4VGqZEPy/Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ/3en5UPoG0epz+Ux/PIqN7PmdNZLhutlqCVzG/cy0BBe3bp5HeRK2j0DJ/Ad5i6xF0jgzoRRPMFuV/DE6IruAE+q0yMGjON8Y5fwemFippHZtS4QGt3pBO1Pa+7k0Qrs9NIHVuc22JJFJHA6lc4RkOMOFKu8KaFX4+dE5OgOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOTRPuGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOTRPuGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB821F000C4;
	Sat, 17 Oct 2026 17:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259470;
	bh=Fm7bjMOZqI7TQwMapar8tNMQzEPMf3ZOS0hLdlWuIew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOTRPuGMD2sRiiFP5oDi4f/mE1T2hrU93SXbw42P00QbPkPKdVszaABBjppGJs3Ha
	 YI9mEPqUUw5N7i/G3QDvv2YAREEgH0EEWuhR1zExPIB+Ga7WSI69+y50TpqtTC8ox0
	 +vbFKcystJSYQaUcbFT/byriQNlCUavj5rY1f0nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1224/1674] netfilter: synproxy: fix unaligned memory access in timestamp adjustment
Date: Sat, 17 Oct 2026 17:58:16 +0200
Message-ID: <20261017160502.559655465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 992c20bc8a4aba220c8b95b467d049289778dad6 ]

Use get_unaligned_be32() and put_unaligned_be32() to safely read and
write the timestamp fields. This prevents performance degradation due to
unaligned memory access or even a crash on strict alignment
architectures.

This follows the implementation of timestamp parsing in the networking
stack at tcp_parse_options() and synproxy_parse_options().

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 52f1f30f95add..35c38c3268a6a 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -190,7 +190,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       const struct nf_conn_synproxy *synproxy)
 {
 	unsigned int optoff, optend;
-	__be32 *ptr, old;
+	u32 new, old;
 
 	if (synproxy->tsoff == 0)
 		return true;
@@ -220,18 +220,17 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 			if (op[0] == TCPOPT_TIMESTAMP &&
 			    op[1] == TCPOLEN_TIMESTAMP) {
 				if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-					ptr = (__be32 *)&op[2];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) -
-						     synproxy->tsoff);
+					old = get_unaligned_be32(&op[2]);
+					new = old - synproxy->tsoff;
+					put_unaligned_be32(new, &op[2]);
 				} else {
-					ptr = (__be32 *)&op[6];
-					old = *ptr;
-					*ptr = htonl(ntohl(*ptr) +
-						     synproxy->tsoff);
+					old = get_unaligned_be32(&op[6]);
+					new = old + synproxy->tsoff;
+					put_unaligned_be32(new, &op[6]);
 				}
 				inet_proto_csum_replace4(&th->check, skb,
-							 old, *ptr, false);
+							 cpu_to_be32(old),
+							 cpu_to_be32(new), false);
 			}
 			optoff += op[1];
 		}
-- 
2.53.0




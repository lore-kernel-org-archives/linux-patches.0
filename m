Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3978937DABD;
	Tue, 21 Jul 2026 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649203; cv=none; b=t4JvVHyDt4B13P84Ve9U71pI/2RnCSAonNBCORO4YUzZ7fL9e5KRyF5YZoDY+19WjgqMak9ABYRG3eM/Bt86sHpt2RX2gVrvPfM/N7BSmf3DcSAihShwrtR8dmcINVJfGfFQAlEeN8ex6QhrT9mYjnNWfQDHuB4CMJ0vts2GW7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649203; c=relaxed/simple;
	bh=0JckWERO9q33k5PP4lZomIX/GxxMXYfS5OqNY0gAwok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDIemLeCd17ou6nzgEbhNOSRElRtXd0k3VAcy4EN44jfFohdRzStiI2CCCJjcA9x1cTWrrubdVOx/+H27rUP7IVeksSN4uZGsP9uVtd6oxhYrFWFX439ksVQmUmOcjdTn0S5x73i/KtkakLII7iDvZPSoaGBR0e+72HcvKTndVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8pkelHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8pkelHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962C71F000E9;
	Tue, 21 Jul 2026 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649202;
	bh=ZNxvhWnbscvxGUR1HyCNo+ro5TMzxDHynD2eTZ/jb8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8pkelHNkyfn1+Kt2nMz0P70aTr7eROHMBuG18ocwRgnOnISEzSBBpagcSK5lzFfg
	 AQnSxLkjzRUJThPxFn9/FVzHQ8XQrSbItwAJutwSxHVii5R2BZzbQnBsGZCrQhhQe1
	 HcCfQWyW6jUfWMZ5YBxfhM24/T25wQzCpYHL1YLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0488/2077] netfilter: synproxy: fix unaligned memory access in timestamp adjustment
Date: Tue, 21 Jul 2026 17:02:41 +0200
Message-ID: <20260721152604.318328962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index a0bcf188810d13..acd360515972f7 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -191,7 +191,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       const struct nf_conn_synproxy *synproxy)
 {
 	unsigned int optoff, optend;
-	__be32 *ptr, old;
+	u32 new, old;
 
 	if (synproxy->tsoff == 0)
 		return true;
@@ -221,18 +221,17 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
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




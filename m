Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53154372B3C;
	Fri,  7 Aug 2026 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114289; cv=none; b=BO4k8B96orjTIlj8BFWaUIqIPRAtPW64WMqvGObesCKxm1HwhhTxUkk0zmtqAmQtPp4I1eN4xTwxZp5f69ZjyMPCgdLfiFAmI/ymgjMbBSLBFIPD5MQEZB0GMZzTTdAAEzjr0MEqD1us2PjVMVBABQTl3dFCfzVqBPsgDU82qv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114289; c=relaxed/simple;
	bh=akBdJLubIiBze81Ljlgla1rD5XBO+YwXfL1PHMOLCiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lx8Z6t6pWIVdgss+UjHKQFP6aYAaFsBm3flp4k+HImVxB5UV+5MZY9boGPKkAFGiGV/s8WRow787hhg6mYLLcpYMXMKD+NeMclkwaUrt70Wk4QQg622vzHvpAZ8UcRSkOGdlqcHVAb7NIFgI8DfAXTszYbSMTDxsOmSxFLXVsaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLcoQals; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLcoQals"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9891F00A3A;
	Fri,  7 Aug 2026 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114286;
	bh=qb0j4UkLTRnUdueXFJVeSs3Ta2MifUM/ECW77jLEPWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLcoQalsrt0KVgL3Mh8Zlg0uqudi0tMjUtzxYkzSIv/cFwXw83p4RzhXMV/s0Rs7v
	 6SROCYmExByfz6OGcOv5yuc/weHQy3jreyXJshWphA0N0zSK4lGAkyxeQzO3WA0xkS
	 fBz4j/uYye1T6idHBVX3FPeMSDU9RZLY4EDW18cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 173/337] ipvs: do not propagate one-packet flag to synced conns
Date: Fri,  7 Aug 2026 16:36:16 +0200
Message-ID: <20260807143422.311317074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Zhiling Zou <roxy520tt@gmail.com>

commit a63d2dbaeb50a85d4c976b15a36e6b0c7113db5b upstream.

Synced connections can be created before their destination exists. When
the destination is later added, ip_vs_bind_dest() copies connection flags
from the destination into cp->flags.

IP_VS_CONN_F_ONE_PACKET connections are not synced. If a synced
connection inherits IP_VS_CONN_F_ONE_PACKET while it is already hashed,
expiry can treat it as a one-packet connection and skip unlinking the
existing conn_tab node, leaving stale hash nodes pointing at a freed
struct ip_vs_conn.

Drop IP_VS_CONN_F_ONE_PACKET from destination flags when binding synced
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_conn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -599,6 +599,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 	flags = cp->flags;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
+		/* Synced conns are hashed, so they can not get this flag */
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
+
 		/* if the connection is not template and is created
 		 * by sync, preserve the activity flag.
 		 */



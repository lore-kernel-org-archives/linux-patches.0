Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE9078B61;
	Tue, 27 Feb 2024 14:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043324; cv=none; b=PvSPFSSMC8ch3/DgBXLZRf5U4mcDtJu2KbnNoH4weGeWjY7TZyBUbBuDuTN1tKACnW5bkVPNGaSVCfUXmMlobrPcn7/w9aPseROW1dgKQta6vj2RbWByMnv6VNHMFygkqnCD6KBKF0SdQs6YPUS1mLcFulM14jwTmw2Bl/FrHcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043324; c=relaxed/simple;
	bh=aToZoZY+yjtsdrLowbVstfcUoGPoSMh3bCy2q6ZGmZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPmLMi4I/jXzaOqICIUxu7/diAt9xODrwj/doZMMOzuwqOImhehUp61Ce7onwuaXQdtxY9SWvAirTZUkD2EKsFSXplT0hf3fP972JGqs8M+kh9FKlLchYuBzqkCJi0rhxyp+aUpXBwolah4wP+LHs6a5SkAo92CnMb2fYsybtvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0H3J5iol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0H3J5iol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70688C433F1;
	Tue, 27 Feb 2024 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043323;
	bh=aToZoZY+yjtsdrLowbVstfcUoGPoSMh3bCy2q6ZGmZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0H3J5ioloGRq2MCXtV80wiao+5VZNVSwC474fXT1flyJPTKTuqtdhtbRbMRUkRhoj
	 Bg8zXs11afp64iNcOVEi4beOUXUv04PoD82ghrSHquP7b/K/5ZfXZAC5kNoq3Ha6gg
	 alziEig68QGaRnY5/MSUNJ+6A924xS6pVeIEQC1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/195] netfilter: conntrack: check SCTP_CID_SHUTDOWN_ACK for vtag setting in sctp_new
Date: Tue, 27 Feb 2024 14:25:00 +0100
Message-ID: <20240227131611.681703724@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 6e348067ee4bc5905e35faa3a8fafa91c9124bc7 ]

The annotation says in sctp_new(): "If it is a shutdown ack OOTB packet, we
expect a return shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8)".
However, it does not check SCTP_CID_SHUTDOWN_ACK before setting vtag[REPLY]
in the conntrack entry(ct).

Because of that, if the ct in Router disappears for some reason in [1]
with the packet sequence like below:

   Client > Server: sctp (1) [INIT] [init tag: 3201533963]
   Server > Client: sctp (1) [INIT ACK] [init tag: 972498433]
   Client > Server: sctp (1) [COOKIE ECHO]
   Server > Client: sctp (1) [COOKIE ACK]
   Client > Server: sctp (1) [DATA] (B)(E) [TSN: 3075057809]
   Server > Client: sctp (1) [SACK] [cum ack 3075057809]
   Server > Client: sctp (1) [HB REQ]
   (the ct in Router disappears somehow)  <-------- [1]
   Client > Server: sctp (1) [HB ACK]
   Client > Server: sctp (1) [DATA] (B)(E) [TSN: 3075057810]
   Client > Server: sctp (1) [DATA] (B)(E) [TSN: 3075057810]
   Client > Server: sctp (1) [HB REQ]
   Client > Server: sctp (1) [DATA] (B)(E) [TSN: 3075057810]
   Client > Server: sctp (1) [HB REQ]
   Client > Server: sctp (1) [ABORT]

when processing HB ACK packet in Router it calls sctp_new() to initialize
the new ct with vtag[REPLY] set to HB_ACK packet's vtag.

Later when sending DATA from Client, all the SACKs from Server will get
dropped in Router, as the SACK packet's vtag does not match vtag[REPLY]
in the ct. The worst thing is the vtag in this ct will never get fixed
by the upcoming packets from Server.

This patch fixes it by checking SCTP_CID_SHUTDOWN_ACK before setting
vtag[REPLY] in the ct in sctp_new() as the annotation says. With this
fix, it will leave vtag[REPLY] in ct to 0 in the case above, and the
next HB REQ/ACK from Server is able to fix the vtag as its value is 0
in nf_conntrack_sctp_packet().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index c94a9971d790c..7ffd698497f2a 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -299,7 +299,7 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			pr_debug("Setting vtag %x for secondary conntrack\n",
 				 sh->vtag);
 			ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
-		} else {
+		} else if (sch->type == SCTP_CID_SHUTDOWN_ACK) {
 		/* If it is a shutdown ack OOTB packet, we expect a return
 		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
 			pr_debug("Setting vtag %x for new conn OOTB\n",
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA87B54BD4;
	Tue, 27 Feb 2024 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041741; cv=none; b=Q6eUF4eiAs/SdvYXt3hXTGNhF3+A6S63ZD7DREgTchEV51Smr9iK5by/LKV/+NCPh5YX/QoWuMocnTMpkbJSJdgcTYX3Ol1b0c/xMq2xvdJdPZG13oD7PyK/sKuKcxlFosT0LtBgT08ZdX0snTl0tp61zaaGbGKtbJ4DDthiXIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041741; c=relaxed/simple;
	bh=Tuujnbyk+BqesRBp/TnPf5BRspcBZEm93DT56W1jGy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbQUuLsFO2VUmyf5VrOzE5g4OLy0w20cffrjDX2GVpK149eaDrU1RRTaChklSb5UAdYwTqxWW3ThUXVvvXoSQ7sQWRSFweGBk9VOFdWAKQENtqxFGojNscA0YBKvo+ZFbMddwwtLHdsgXzaKC6Ip8Je8T2TOOwQg2w7j/e2+kNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/RMOXJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/RMOXJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589F1C433C7;
	Tue, 27 Feb 2024 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041741;
	bh=Tuujnbyk+BqesRBp/TnPf5BRspcBZEm93DT56W1jGy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/RMOXJfISWTmG550xf3ngvFFwXjT53MtdBBhy+Nj47091Xp4IOxzO/+K8Qe6ZI88
	 ms7nUZi4+M26FIo/GrwNsZNYrUccipsGSaPRqmd2v98PqODN1h7tGyoQJtF09waH97
	 E9jNtNrAHveHQaJwKvss5fURa+LWMtkGyE+t9PQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/299] netfilter: conntrack: check SCTP_CID_SHUTDOWN_ACK for vtag setting in sctp_new
Date: Tue, 27 Feb 2024 14:22:43 +0100
Message-ID: <20240227131627.645587335@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c6bd533983c1f..4cc97f971264e 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -283,7 +283,7 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
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




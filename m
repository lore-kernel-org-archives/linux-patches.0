Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E770D2FDC5E;
	Sat, 30 May 2026 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161929; cv=none; b=SFkOTtYUv+XjuUoUxEMjNFchl39jKHtrYcEDrrfDfQdm5aZLUJRqA8PofTSURmEqPCaGAoEDzJwlVzDnf3omFCXszBxaAysYu8lbEGceuwf1lvykGdrnumIB/4FhALdIZ9kDg8fAF3P+26m66Xjz6Cam9HhN+2D74V/GwfsH4Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161929; c=relaxed/simple;
	bh=FV7Cq+3lN+oM684hlhXqVsMnJ0eVMp2JpZC/EJnaIro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebB0PV8plbnoaGV6XVudBLXOEf7Ac5m6eU0jsV53zS8pQN5Xz1oDfyBkEv4F6//oTSxOjq8nFeAiDshmvZGUZcdQxm6pF3eeu2Sv5leE++RyUgT2AQmoPmrHErEmzsBqFJyQf8gOLTnEPQRd6Swkl7+AhziGZRUB5iyhw0r5F3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8q41fs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8q41fs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFB51F00893;
	Sat, 30 May 2026 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161928;
	bh=/vro/cRcNPfo6x9fZN8zwkg8j8CIMpfhRpgCt8kyLyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8q41fs19Jm/8GF675oCRurAruP1VqP0ARgjgNVEFZ132c71DSsyfg/Us3w4oCZg8
	 tlGSrHSNNoKw5cdm//qMYD7kfoyYsstFU2gIbMOdAKcF4N4Fi6olcn2LbAX1owbaEh
	 gI5zXN0uR37T6PItCOjHb7wrtYUfK8bJLFFWyJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 762/969] netfilter: skip recording stale or retransmitted INIT
Date: Sat, 30 May 2026 18:04:46 +0200
Message-ID: <20260530160321.610629478@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 576a5d2bad4814c881a829576b1261b9b8159d2b ]

An INIT whose init_tag matches the peer's vtag does not provide new state
information. It indicates either:

- a stale INIT (after INIT-ACK has already been seen on the same side), or
- a retransmitted INIT (after INIT has already been recorded on the same
  side).

In both cases, the INIT must not update ct->proto.sctp.init[] state, since
it does not advance the handshake tracking and may otherwise corrupt
INIT/INIT-ACK validation logic.

Allow INIT processing only when the conntrack entry is newly created
(SCTP_CONNTRACK_NONE), or when the init_tag differs from the stored peer
vtag.

Note it skips the check for the ct with old_state SCTP_CONNTRACK_NONE in
nf_conntrack_sctp_packet(), as it is just created in sctp_new() where it
set ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Link: https://patch.msgid.link/ee56c3e416452b2a40589a2a85245ac2ad5e9f4b.1777214801.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 90458799324ec..ae89f3c590e8b 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -484,9 +484,13 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			if (!ih)
 				goto out_unlock;
 
-			if (ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir])
-				ct->proto.sctp.init[!dir] = 0;
-			ct->proto.sctp.init[dir] = 1;
+			/* Do not record INIT matching peer vtag (stale or retransmitted INIT). */
+			if (old_state == SCTP_CONNTRACK_NONE ||
+			    ct->proto.sctp.vtag[!dir] != ih->init_tag) {
+				if (ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir])
+					ct->proto.sctp.init[!dir] = 0;
+				ct->proto.sctp.init[dir] = 1;
+			}
 
 			pr_debug("Setting vtag %x for dir %d\n", ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
-- 
2.53.0




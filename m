Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CEB18FDBD;
	Sat, 30 May 2026 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166834; cv=none; b=cPzgVc9/pW6YxRQ7Gd3mcrAra5ybNKG7I3u1NEhpMN/g+mkthckyDWAqZVUJwF2QCM4mKcU6mfoqmX2qz/5OJYD8NWFd9h0lTqzym8qIlzruMROghhanz57dvbnEr1Nqsy0D0NBHOcXlwJgNnOcNqmr13ynlo2ATfAdiyowPRjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166834; c=relaxed/simple;
	bh=XkoMfsVM6dGPwe0Z5oBTJmJ4gni0MYu+9A2mHuwnfkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO5FHmnXVXUR+iSLzGzJPYgO6Q9l6TOJwYeX/yw5PZMC94bWWv1juTJubUGt2gTB3aJ/4Jrs6sjWK9GGQ39rOmljlniZZ0zb7SCTBw68LP8paG5cNhGkYqRjNEabD/Jgnd1s/RKdgdV0kifTxm5vxVdBkaseJeurNKHm5Ekosos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jc6iyoJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jc6iyoJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ECF1F00893;
	Sat, 30 May 2026 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166833;
	bh=2z+60bS3sPQXh+eBSwMfwZOaXCaFp7K2yjelL5CN6ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jc6iyoJvjNo4sdkbm3bfoM87uUSUygQxJNAnnTZ35YODlDYpgzYr7vwMCBQtf6mJ7
	 6QgXkibav2fbJTq2s5A+S1Nga9uHRZkscWs8OCckuMCeJt3KGVAi4WS7HRgRisxSTG
	 qbVJbL8tmikw8ZrbubYbQK5VK8OBZv04jtyFXi0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 486/589] netfilter: skip recording stale or retransmitted INIT
Date: Sat, 30 May 2026 18:06:07 +0200
Message-ID: <20260530160237.414810302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2a1d00e702d1b..4a376c9a6c73c 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4697223DC6;
	Sat, 30 May 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164778; cv=none; b=HaxM6YoqVKf11Hsw+nDHsnhkxADKTcLePWICQBkcjhCT7Mqt6gqZuoSE1WQpO06F5mjmrQyyBZi5+BVZjtl7lMOXCqnvVwh9zo3U3BdLJH352v17WUJGUGjo5q+glBYJKXDqVri7iInr0W2JHrCcU715MCcC8tgzfju0oaOZnH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164778; c=relaxed/simple;
	bh=Qu6FLZfv+I+OOjYg9yMpiKfDYQ4SJAHCpPwBLb4+Loo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAbDjDc4pGNCnm7QEEgYJMNbQrqqriDGsC07eMltMdblAlk2/cJW1phQNT3OMEbU4yULIgvVJ6GLy7xMOFMnRxI1ngLnQv5xJ8YES282E5gXYvWX5CeqyS8cr0HGV4T/tUyKT55XF2lIqqz8aanykklGlRFj8N100moQp9ttMMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caA0FaP+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caA0FaP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6AA1F00898;
	Sat, 30 May 2026 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164777;
	bh=ZyAUfWgdzbGdlgSESkd+fPTyKdTcsdJ24dQnPSlBphE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=caA0FaP+khbbmhNk1LmVs2LuJQs0Ii5d8wZuv/Q9bNTbZ3TVmcjYb5eFF0kB4VtHK
	 mIUSTY+wjCBNXO5LA8VHcyYXAJhBDf/zdzbm6Qf2Tsz1P2HskQK0Pou3MReEUeRErG
	 rdvEnKSaO9TRCwCEgnr8F6fLBv4WOAPvkYZBE/N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 627/776] netfilter: skip recording stale or retransmitted INIT
Date: Sat, 30 May 2026 18:05:41 +0200
Message-ID: <20260530160256.178686636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10C245005;
	Wed, 20 May 2026 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296420; cv=none; b=PSECqeMQrPd+h8hxcmu9vsEyZr3XGSXy1G6nhxEI8uf1YmboOm4UNj8t+0unBDN/n38aj0lXsFM5A2s62WPERlZ6CjRM0+fEDLxmRjDLg71bgFNmZKtNadaos0lciNlJhTKDNY+NrN6JL1vMJuHDKWyUxEPvVXg9NBKSkO/R4Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296420; c=relaxed/simple;
	bh=NEiCBwolEqckGnWaL3vsmSoWo87k8sSunt9X+cm4ojc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUQB6dTaphWCJ6ALqKR6EvPifb0WHzP0uy215mFSbMAh8Y6sGqkkK23FGhTRPJepQVY1ovocEfLfnSEbbvksbyDxHNakgmDvuj1MFgGkK4wXBRhf9JcC/iLXMmTHKkbAF3em64stM4r9aQvGLG75Yi8c7USoDqZwrCGLVq5W9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUTh/iD7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUTh/iD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4F61F000E9;
	Wed, 20 May 2026 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296419;
	bh=YIAYl2aU4bR6k6RrYEGpfsmyFIdelcSM+aUW89MHFMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUTh/iD7CmMgLThdFlaGd0KhN5py/Wy98fbfuStpovEhirIHSIS94FnWOiD3lYkV0
	 SMLqLdHtzFgQaCIflF0dF6/ElKpYOx1z1iEh3rMYCIEKWtI1udKGYAVE9QP6Tbm/DP
	 TLcESqiwKjlCfWjs63RPYaHt91JMHHIxTgLNVoy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0793/1146] tcp: annotate data-races around tp->plb_rehash
Date: Wed, 20 May 2026 18:17:23 +0200
Message-ID: <20260520162206.172239457@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9e89b9d03a2d2e30dcca166d5af52f9a8eceab25 ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() and WRITE_ONCE() annotations to keep KCSAN happy.

Fixes: 29c1c44646ae ("tcp: add u32 counter in tcp_sock and an SNMP counter for PLB")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-15-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c     | 3 ++-
 net/ipv4/tcp_plb.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c27bee7b31146..cee51749df16c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4514,7 +4514,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 		nla_put_u8(stats, TCP_NLA_TTL,
 			   tcp_skb_ttl_or_hop_limit(ack_skb));
 
-	nla_put_u32(stats, TCP_NLA_REHASH, tp->plb_rehash + tp->timeout_rehash);
+	nla_put_u32(stats, TCP_NLA_REHASH,
+		    READ_ONCE(tp->plb_rehash) + READ_ONCE(tp->timeout_rehash));
 	return stats;
 }
 
diff --git a/net/ipv4/tcp_plb.c b/net/ipv4/tcp_plb.c
index 4bcf7eff95e39..b7f9b60d8991f 100644
--- a/net/ipv4/tcp_plb.c
+++ b/net/ipv4/tcp_plb.c
@@ -79,7 +79,7 @@ void tcp_plb_check_rehash(struct sock *sk, struct tcp_plb_state *plb)
 
 	sk_rethink_txhash(sk);
 	plb->consec_cong_rounds = 0;
-	tcp_sk(sk)->plb_rehash++;
+	WRITE_ONCE(tcp_sk(sk)->plb_rehash, tcp_sk(sk)->plb_rehash + 1);
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPPLBREHASH);
 }
 EXPORT_SYMBOL_GPL(tcp_plb_check_rehash);
-- 
2.53.0




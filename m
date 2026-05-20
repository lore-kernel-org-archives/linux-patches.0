Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF153F6619;
	Wed, 20 May 2026 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300286; cv=none; b=KZp/R4hy7n+7Yu0zqWCwCLSTlGpMfGteXLy//3LqINWgLZ+gX9LoXSVsUgb5pf0Dlx8C4jZwKyVgLOuWY1XzpQUncfDi9VaPnoNoYqb8Y2zeqURVCO+mmm2/kABOmhtzxI1Ibo0P34ar/PjuefuicvhfTAuY/jf2tDmNGzkCH6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300286; c=relaxed/simple;
	bh=eBitnv+lGsMXu6wctWwuBO6x556LTdX8TtSzBY9FRog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkB/yfmScnlopg4iHbOwO8Enu0S1N/h45KDiGUuBn1y63RaQ6FDuMsAj9nW0m4rvnhYagS171FXBT80pe/Pj681h6IWn+U8irEzPlADH4jlQkfBO7nNtFtV8fAbUuoz37ep9udzZJ0UkjovQtHNQkt1b82W7h+p+9qUiJ/Fe2eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w61rZfTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w61rZfTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AA41F000E9;
	Wed, 20 May 2026 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300285;
	bh=6N9tPZeG9O1civ7EYYtcgQojAiLekrTBwbHdhbrI3bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w61rZfTyzRNUSUKF+ZBm7S91+LnTdDXwvKFKxf5WdMFpS3Q5JPw0bnvcVq2Q4byDF
	 Mpocn4217Ncm2EyTkaeAjcsMfonlmkigPGFYiK9GRp0r5nj7+ZKz534bMddmdwclHd
	 8vnRTxVbl+cBEdl/uKIiOaC1b8WWQhc/wpBDWDSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/666] tcp: Dont set treq->req_usec_ts in cookie_tcp_reqsk_init().
Date: Wed, 20 May 2026 18:15:26 +0200
Message-ID: <20260520162113.713317385@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit c058bbf05b1197c33df7204842665bd8bc70b3a8 ]

Commit de5626b95e13 ("tcp: Factorise cookie-independent fields
initialisation in cookie_v[46]_check().") miscategorised
tcp_rsk(req)->req_usec_ts init to cookie_tcp_reqsk_init(),
which is used by both BPF/non-BPF SYN cookie reqsk.

Rather, it should have been moved to cookie_tcp_reqsk_alloc() by
commit 8e7bab6b9652 ("tcp: Factorise cookie-dependent fields
initialisation in cookie_v[46]_check()") so that only non-BPF SYN
cookie sets tcp_rsk(req)->req_usec_ts to false.

Let's move the initialisation to cookie_tcp_reqsk_alloc() to
respect bpf_tcp_req_attrs.usec_ts_ok.

Fixes: e472f88891ab ("bpf: tcp: Support arbitrary SYN Cookie.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260410235328.1773449-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/syncookies.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 1948d15f1f281..640fc3b54277d 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -284,7 +284,6 @@ static int cookie_tcp_reqsk_init(struct sock *sk, struct sk_buff *skb,
 	treq->rcv_isn = ntohl(th->seq) - 1;
 	treq->snt_isn = ntohl(th->ack_seq) - 1;
 	treq->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
-	treq->req_usec_ts = false;
 
 #if IS_ENABLED(CONFIG_MPTCP)
 	treq->is_mptcp = sk_is_mptcp(sk);
@@ -347,6 +346,7 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 	ireq->wscale_ok = tcp_opt->wscale_ok;
 	ireq->ecn_ok = !!(tcp_opt->rcv_tsecr & TS_OPT_ECN);
 
+	treq->req_usec_ts = false;
 	treq->ts_off = tsoff;
 
 	return req;
-- 
2.53.0




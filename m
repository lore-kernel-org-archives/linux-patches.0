Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022347;
	b=atGil8SCJ+ngAoW//FfsiEmgSMZZFJo34HJ64TMcbub0jmj394UmlvhyOz6o9v2Glsog
	 NB0Y6LGrKfoElcAXS0567XV+lkbfLH8mzqzCPuQUsSnhrMNkXcKrIiVgy4k5VI+f+Mefx
	 0RpOQJ/7nGkCbtZosvYXH9nH7rD/iQwEMRmFNHwCky7oRrJxQItCrpFYdqR5vuqGy8dXD
	 PrCyETZ4x+70keOlKD3svubTt02IF2Iz03aNriSXmLnfAorkMcMB17N7hHrrCYHWhRl0N
	 M7p847Zibjcx1ry/9Zzna4kxtLSW/4sPAb/Wx+VQtXNfzV+5nsrNWH30gJAmI5hiipQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gyS080LlkvO6h4m4kURoOR7bvuUsf25q7rMGbnd6bK8=;
	b=wGqZTxkY6Cgg+UWDUd8myyG2nd/ZNwwaXS52h5gq1Tz1BDERIoCsmTtUKwVHgyIgR2LP
	 LSa7Uc7fWAKmxnohshy3zjCj6RZTV033A9eDg4kixlMq0lBOC9+C4RBSp2L7QkKqbnm54
	 yZ3X0rwwwQOo4Usk6lKghmMCeWyABRjzo2lL4csGV9gRIvcFF/xjm26o6bZZwabJXeBdo
	 Fsd7OHJ9luV9tp6OvMOlOYvn98A72YK/yIETOduiiMDIn7KGXGTQHSGdHBw6/3ZzJdOzR
	 wafzjSKoca70xhDDk6SbpQ33F9Jrk19EdihnfaIZSwzq26vBEA5ftX5Y1dV/qbYy4CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQsZTQDQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C8D606A325;
	Wed, 18 Nov 2026 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQsZTQDQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4FD1F000C4;
	Wed, 18 Nov 2026 17:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022347;
	bh=gyS080LlkvO6h4m4kURoOR7bvuUsf25q7rMGbnd6bK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQsZTQDQv0L9QRfmDG90tetgsZ54Fu6x4DybnrkY6R9ATzUBIzwj5N6O8/MNFbsU3
	 B+nuSTDsW0ts33KS7gG3fjTT3WQPBJwxWU/+SMQ/zwa3ka729Lfdy/YR3NXd9YK48T
	 /LOzB0L5pB9mv+eA8BVo1lGcxNgd+f+RaAAHPHCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2622/2651] apparmor: fix check SCTP bind, and connect permission checks
Date: Wed, 18 Nov 2026 16:04:22 +0100
Message-ID: <20261118150418.599609558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 7a82f9a06459ff1c37b5e97b204430442cc076e3 ]

SCTP mediation of bind is not being checked correctly because bind
permission needs to be checked in the sctp_bind_connect() hook.

Require for bind permissions when CTP_SET_PEER_PRIMARY_ADDR, and
SCTP_SOCKOPT_BINDX_ADD are asked for.

The peer initialized ASCONF cases (SCTP_PARAM_ADD_IP and
SCTP_PARAM_SET_PRIMARY) are processed in softirq context and are not
mediated atm. SCTP_PRIMATEY_ADDR, and SCTP_SET_PEER_PRIMARY_ADDR only
select among address already in the association.

Fixes: 56974a6fcfef ("apparmor: add base infastructure for socket mediation")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index dba078c73abc6..de6633e238f3f 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1410,6 +1410,11 @@ static int apparmor_sctp_bind_connect(struct sock *sk, int optname,
 				      struct sockaddr *address, int addrlen)
 {
 	switch (optname) {
+	/* Bind checks */
+	case SCTP_SET_PEER_PRIMARY_ADDR:
+	case SCTP_SOCKOPT_BINDX_ADD:
+		return aa_sk_perm(OP_BIND, AA_MAY_BIND, sk);
+	/* Connect checks */
 	case SCTP_SOCKOPT_CONNECTX:
 	case SCTP_SENDMSG_CONNECT:
 		return aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sk);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83BC4D1789;
	Thu, 17 Sep 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667998; cv=none; b=F4ZZLf7TAhVbCWNehyd/eqkrbAULqxOnimG3OCXoyZimtcUwfYPUa6e46j9u0ENCCqPo5AioDctrgB91rvev8H15v1ONMvE1I3FgwJtjoO5xlqZh342//rvnuktgvWZMQCNAUqpjlMh/5qkCXJEEMcCZcwtl6ZPsp0Z4mo+yXnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667998; c=relaxed/simple;
	bh=86QhOBAKJUrck0rac0hPu1R44QjJA0n6yxJFFrkU3jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alSNe7Qf4ID3Ok8hieccTb9dcvW6VmtqOKNsUfSsKCBklRoHDeM+Dmbu8U70eMY7MvvIKV8mk442Etm7DhrGgFG56dBvLZucQPKlkX8QP4iAHjhxh0SLaIO27FXuh6qO41Tsk/pDVyjnJDTyM4Y/rysJ57y+512kM9XjP7OZkp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctxGaM5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctxGaM5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D300B1F000FF;
	Thu, 17 Sep 2026 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667997;
	bh=AyLJuuteo+R2Oi/nim+IgnAckdidbEpaFW8fIBzV0Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctxGaM5d6Vw+9cX3vmsG0Xmj/7P7ibai9KBIO4Pto84J4gwmB33tFVQvdiSvs7/5v
	 maWOFQK84ML3juqsdoFAGgihLtlWujhuIOFpn/VoEe89DBw38AVT8dkz/aOYmBnMSh
	 uO08Zawqa8B5wxL+lKz5MweZ8pk7RsQDiiqTpZxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0278/1102] sctp: Unwind address notifier registration on failure
Date: Thu, 17 Sep 2026 16:03:41 +0100
Message-ID: <20260917151546.589465120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit c8459ee2fef502d6ef6c063751c33d9ac7943eab ]

sctp_v4_add_protocol() and sctp_v6_add_protocol() register their
address notifiers before registering the SCTP protocol handlers. If
protocol registration fails, the functions return without unregistering
the notifiers.

Unregister the notifiers on the protocol registration failure paths.
Also propagate notifier registration failures instead of ignoring them.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608162230.46644-1-dbgh9129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c     | 10 ++++++++--
 net/sctp/protocol.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index b45cc51dfc353..bf54fb1ee6549 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1223,11 +1223,17 @@ void sctp_v6_protosw_exit(void)
 /* Register with inet6 layer. */
 int sctp_v6_add_protocol(void)
 {
+	int ret;
+
 	/* Register notifier for inet6 address additions/deletions. */
-	register_inet6addr_notifier(&sctp_inet6addr_notifier);
+	ret = register_inet6addr_notifier(&sctp_inet6addr_notifier);
+	if (ret)
+		return ret;
 
-	if (inet6_add_protocol(&sctpv6_protocol, IPPROTO_SCTP) < 0)
+	if (inet6_add_protocol(&sctpv6_protocol, IPPROTO_SCTP) < 0) {
+		unregister_inet6addr_notifier(&sctp_inet6addr_notifier);
 		return -EAGAIN;
+	}
 
 	return 0;
 }
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index fd2620bd15bbd..c6d74fa517cd8 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1279,12 +1279,18 @@ static void sctp_v4_protosw_exit(void)
 
 static int sctp_v4_add_protocol(void)
 {
+	int ret;
+
 	/* Register notifier for inet address additions/deletions. */
-	register_inetaddr_notifier(&sctp_inetaddr_notifier);
+	ret = register_inetaddr_notifier(&sctp_inetaddr_notifier);
+	if (ret)
+		return ret;
 
 	/* Register SCTP with inet layer.  */
-	if (inet_add_protocol(&sctp_protocol, IPPROTO_SCTP) < 0)
+	if (inet_add_protocol(&sctp_protocol, IPPROTO_SCTP) < 0) {
+		unregister_inetaddr_notifier(&sctp_inetaddr_notifier);
 		return -EAGAIN;
+	}
 
 	return 0;
 }
-- 
2.53.0




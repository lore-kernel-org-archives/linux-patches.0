Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D95172E2;
	Wed, 30 Sep 2026 16:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784503; cv=none; b=c6FLIYjn1CsTzaHisHagHgWBn3CVcXf6XFrXwReE9e61b1D/iyTegTKNy6Kckr2ou2UlMK7wq+y70gsq1fwpvsNXhIDaNQs2kfNhQ2Qnw2C+rge2hntx3CQWov9loBSDThJ41kMJ/hDR3kWY7sb4dhw9zxso/iPEqXONk5A17Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784503; c=relaxed/simple;
	bh=pDcJG8fWDWBAY8E6Lri4NkwSOgmf/uUyon89OFIZ4mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8pJBi2Jmi8H5JJwn6JM4F7E+plmVT4zX0jJjVEB71WWIf0P0zZySY/1MhrSAcA90/+osOCejoXuGHGcysAgJDX/kvJmzJNAxLh6w+rmECRziD5rbAZus1wyusJVennPMBBYq+BlnkNEpnrRqSEaYFhPzH7lkMWs3+DmvyBSkSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ud6jLN5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud6jLN5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9B91F000FF;
	Wed, 30 Sep 2026 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784496;
	bh=1A9LD/o07NCNd52gEMZLNiSyStASetQLBJgJNHJ1Z48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ud6jLN5t/MHotH1BvdmbM8Kq8z8d/10zoVM9xZS1rvxtiIZ32YNDU3/AIDARcfniB
	 5IYnbLBshaFkyB0bijyj3JSYyqh8Vwg2OJs//FPF1GvthGgR+qLbJVi2hAwUJFUcO6
	 zv1aYgz1S35TVxlXUTtinR1dQoP9Es+Z8ecI/XNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/982] sctp: Unwind address notifier registration on failure
Date: Wed, 30 Sep 2026 17:15:13 +0200
Message-ID: <20260930152420.617606816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index be190f5696d88..3b07b9f5d7525 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1202,11 +1202,17 @@ void sctp_v6_protosw_exit(void)
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
index 9384ff5418d59..c6a5af7560748 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1269,12 +1269,18 @@ static void sctp_v4_protosw_exit(void)
 
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




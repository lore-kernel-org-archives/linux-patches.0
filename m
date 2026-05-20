Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B64236494B;
	Wed, 20 May 2026 16:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294862; cv=none; b=K/V40yZY5VMfDvwFIuSdMF9JjlDDIjzPZ3QhiB0jCy+yai3JnMExOBPAprnqWHvSzOsBzvCagRczjLJE2nOfb9adGxR8pL644zN5SaPZLeHhlUHMrTYCRHEFQ0NV+JhGEwcxl5vkJyE7xP9isRof2bY0wsEZfRVXFjZXcG59xkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294862; c=relaxed/simple;
	bh=UDCyubzo0oWtZ0scgGTe7ahcIuVj+8gZpDYtVvsTxxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leEHH7UFekkTFzUkgi9MZHGTPKLLcnh23ZAm1klq1nIwL8uG9lld1cE8oGuBgoWUoN0DQXfIUF42ykLNdV7iewqeljeMxtLIm4eGwrfQA2VWZ3Z8kEQ0znXFTT6vHIz6P57aAb+lOA1Kzwyx+geHoxyQhE1GByLta+wV3cZ9BjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4dd6GIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4dd6GIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7089B1F000E9;
	Wed, 20 May 2026 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294860;
	bh=wy58DBY515+VWY82BwlIXH1z+oUShrSrPuUYz/ixm48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4dd6GIWH1kkr+GPqyahyFI8M1e6tIvqfbOjr/DUfuROZxJDraKoor+0s8U/GvPiu
	 bcqQojRwKoiCpfBTTRv124vds6EVJx0Xmtk+74VSdgzrv41gPxwVWHJH2oSUpBDPwu
	 pDA13AtpLF8fADxQO55mq8wFcs2yGUIcKQ0YZUew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+da8e060735ae02c8f3d1@syzkaller.appspotmail.com,
	Greg Jumper <greg.jumper@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0199/1146] net/rds: Restrict use of RDS/IB to the initial network namespace
Date: Wed, 20 May 2026 18:07:29 +0200
Message-ID: <20260520162152.776798188@linuxfoundation.org>
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

From: Greg Jumper <greg.jumper@oracle.com>

[ Upstream commit ebf71dd4aff46e8e421d455db3e231ba43d2fa8a ]

Prevent using RDS/IB in network namespaces other than the initial one.
The existing RDS/IB code will not work properly in non-initial network
namespaces.

Fixes: d5a8ac28a7ff ("RDS-TCP: Make RDS-TCP work correctly when it is set up in a netns other than init_net")
Reported-by: syzbot+da8e060735ae02c8f3d1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=da8e060735ae02c8f3d1
Signed-off-by: Greg Jumper <greg.jumper@oracle.com>
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260408080420.540032-3-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c | 10 ++++++++--
 net/rds/ib.c     |  4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index b396c673dfaf6..76f625986a7f2 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -357,7 +357,8 @@ static int rds_cong_monitor(struct rds_sock *rs, sockptr_t optval, int optlen)
 	return ret;
 }
 
-static int rds_set_transport(struct rds_sock *rs, sockptr_t optval, int optlen)
+static int rds_set_transport(struct net *net, struct rds_sock *rs,
+			     sockptr_t optval, int optlen)
 {
 	int t_type;
 
@@ -373,6 +374,10 @@ static int rds_set_transport(struct rds_sock *rs, sockptr_t optval, int optlen)
 	if (t_type < 0 || t_type >= RDS_TRANS_COUNT)
 		return -EINVAL;
 
+	/* RDS/IB is restricted to the initial network namespace */
+	if (t_type != RDS_TRANS_TCP && !net_eq(net, &init_net))
+		return -EPROTOTYPE;
+
 	rs->rs_transport = rds_trans_get(t_type);
 
 	return rs->rs_transport ? 0 : -ENOPROTOOPT;
@@ -433,6 +438,7 @@ static int rds_setsockopt(struct socket *sock, int level, int optname,
 			  sockptr_t optval, unsigned int optlen)
 {
 	struct rds_sock *rs = rds_sk_to_rs(sock->sk);
+	struct net *net = sock_net(sock->sk);
 	int ret;
 
 	if (level != SOL_RDS) {
@@ -461,7 +467,7 @@ static int rds_setsockopt(struct socket *sock, int level, int optname,
 		break;
 	case SO_RDS_TRANSPORT:
 		lock_sock(sock->sk);
-		ret = rds_set_transport(rs, optval, optlen);
+		ret = rds_set_transport(net, rs, optval, optlen);
 		release_sock(sock->sk);
 		break;
 	case SO_TIMESTAMP_OLD:
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 412ff61e74fac..39f87272e071b 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -492,6 +492,10 @@ static int rds_ib_laddr_check(struct net *net, const struct in6_addr *addr,
 {
 	struct rds_ib_device *rds_ibdev = NULL;
 
+	/* RDS/IB is restricted to the initial network namespace */
+	if (!net_eq(net, &init_net))
+		return -EPROTOTYPE;
+
 	if (ipv6_addr_v4mapped(addr)) {
 		rds_ibdev = rds_ib_get_device(addr->s6_addr32[3]);
 		if (rds_ibdev) {
-- 
2.53.0




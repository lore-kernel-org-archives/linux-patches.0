Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57A02E7379;
	Sat, 30 May 2026 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166236; cv=none; b=j3+crX0hYtq/w8J1tuvVVlkBYChIuwU/4xd1oTKJs85T6A4CWQvUpbXJVxLGAC1o86ey9uVOw/SMNd2tiN+TYwwYz4nxCXHzu+6pf5KcXHiN7GmnASeCzfJuYFUZUnOXnRvmOkNmToKsEgd30reLDviqF6n2kmqjWu2rvgqDhCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166236; c=relaxed/simple;
	bh=iOtq3c8NRFmrJQjLTLS2HpSAc1TD6FxkHzRa13cAVZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf06APrtr4iL0G9gjmY17VIoquCkdd/Xl7wTUVO/zq421Yokbp3C+hDx5m+yxT+JJkmrjvtoVHOegIBIh+9HEjWFXJOuyWuk0U2OJTAmr71Yyh+9S6J2lTXh7xoaJT3r1ZEXI0iM6txRcAtIqSI8MlhwJgMk5UWOSR8/W/evksU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zy+s1TQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zy+s1TQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C011F00893;
	Sat, 30 May 2026 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166234;
	bh=X/Igx44K864Ho0jbNZckktwq7mfBvLcZW5SL9YNiv4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zy+s1TQWnruv19ZUOyzoH4X1VZqjmDU0SW/o0Qf7wCMrol4H+thHUC8XYHW4riA3U
	 hqquDuZqy8LWf9Bct4ghRJX45ZbEDVt2qh+Cfk2yGjSoQVoStZNHPiEpbUKMnxatZB
	 QjtuG9t3sjd5cfZbmnBMn7bwiNDIf3OtPgZKUjgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+da8e060735ae02c8f3d1@syzkaller.appspotmail.com,
	Greg Jumper <greg.jumper@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/589] net/rds: Restrict use of RDS/IB to the initial network namespace
Date: Sat, 30 May 2026 18:03:13 +0200
Message-ID: <20260530160233.143045448@linuxfoundation.org>
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
index 0ec0ae1483492..ca1b52372ab29 100644
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
index dbc63493ade70..ec45664f38767 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -494,6 +494,10 @@ static int rds_ib_laddr_check(struct net *net, const struct in6_addr *addr,
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




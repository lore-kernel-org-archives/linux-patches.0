Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69F619AA76;
	Thu,  6 Jun 2024 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683319; cv=none; b=k2tA4NwpD9N5sRxztItw+B81rVjcca2mKEIg5KC4M7PrkjBZ2h97QrTEULJnJNBb0mU9Ad394jJWEhWRiRSnX3+NjHsn+zEDaVA/3MiMAtiMzGxAUXchIH5Boq/tjvfpmdHieq1np8VgNf+0gtloklCbvGVxqH3j4NN5Dp+POGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683319; c=relaxed/simple;
	bh=IxB738m6TL0/IK2hj0ou2GYz5dUCgUnfMpG7uvoBwrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLzTliZ8MTjq/WA0MEUA9TNdStla61V3CERGu+c5HRHS9+GVNC7CV3BSOK9rEf91j542QNAI56bXhqRAATbm+6X3qTRo+EeBSamcRlb3nk9NLTO/nc9n6geNdFfmyv/FlrPR7nskhj2ra/H2S4qvWKzfKRivOhFwdu2x/ODuQnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaWwl6+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaWwl6+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EBDC2BD10;
	Thu,  6 Jun 2024 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683318;
	bh=IxB738m6TL0/IK2hj0ou2GYz5dUCgUnfMpG7uvoBwrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaWwl6+61QJzHc9Z9EysoDpA8bkHRy9KPwTA822ZzsLHSp/ca27+9Kr1NUJSU41j6
	 L/Sq5lp5LaNb6MrTFtBumEflvvSCr1Dj9Rd1b35IHoSc2OnhOBPSeiLon1ux3HtNmn
	 o/E+RHNNmwLQ0n3tBDslT/leqBFxjO9fz507so0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/744] mptcp: SO_KEEPALIVE: fix getsockopt support
Date: Thu,  6 Jun 2024 15:58:51 +0200
Message-ID: <20240606131740.706842106@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit a65198136eaa15b74ee0abf73f12ef83d469a334 ]

SO_KEEPALIVE support has to be set on each subflow: on each TCP socket,
where sk_prot->keepalive is defined. Technically, nothing has to be done
on the MPTCP socket. That's why mptcp_sol_socket_sync_intval() was
called instead of mptcp_sol_socket_intval().

Except that when nothing is done on the MPTCP socket, the
getsockopt(SO_KEEPALIVE), handled in net/core/sock.c:sk_getsockopt(),
will not know if SO_KEEPALIVE has been set on the different subflows or
not.

The fix is simple: simply call mptcp_sol_socket_intval() which will end
up calling net/core/sock.c:sk_setsockopt() where the SOCK_KEEPOPEN flag
will be set, the one used in sk_getsockopt().

So now, getsockopt(SO_KEEPALIVE) on an MPTCP socket will return the same
value as the one previously set with setsockopt(SO_KEEPALIVE).

Fixes: 1b3e7ede1365 ("mptcp: setsockopt: handle SO_KEEPALIVE and SO_PRIORITY")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240514011335.176158-2-martineau@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/sockopt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 116e3008231bd..1afa8245f27c0 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -181,8 +181,6 @@ static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
 
 	switch (optname) {
 	case SO_KEEPALIVE:
-		mptcp_sol_socket_sync_intval(msk, optname, val);
-		return 0;
 	case SO_DEBUG:
 	case SO_MARK:
 	case SO_PRIORITY:
-- 
2.43.0




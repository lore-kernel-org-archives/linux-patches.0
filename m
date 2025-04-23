Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4DE18DB17;
	Wed, 23 Apr 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419947; cv=none; b=MwvDsNUWEjR3Oi+8km/jCYJj8KhiSyVRqWf15Mdr6Y6GwtBUWCuRDxb8BCMjmVvqUa3njfz/qv5e+tssftO2prWpp/4PLqDahpKwvueaMj55KZqoglBVAJeKX2kBaEx4Im21uSwaLWflQQUdqfw5XI8dX6QuZc6wiflEwLbeY/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419947; c=relaxed/simple;
	bh=Ywfj61JihySVYb8FQE0xQufvWbFsNHdfoeiBAd/euog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh1Y8w9ahhBqauEFyancv5K2pBcrQLaJN0ANOCjuEnpVoPJrXgsZZULOgwBAo34gJVAB/NTS50qOd6gIb4W6bMIttzVYSM2XimxwVNYehWb2x48E+gwKpDgu9U1OOnBUXavJR1PQidBwF/Fce0y1V9F0P1QcpaSjtR5+d+smyxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+jQPgIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+jQPgIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F682C4CEE3;
	Wed, 23 Apr 2025 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419947;
	bh=Ywfj61JihySVYb8FQE0xQufvWbFsNHdfoeiBAd/euog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+jQPgIngQlw+t52BuYhOTMgnSEhckF0dqly4YZLjPyuFLoxB+ahyczLNHsoo0Puv
	 YVYOoIcYxBZ++sPJFEmUjmi+jGXOCkTFneDH3/2zbXmO8OdkAzJ5fIKIDWw05g9NBf
	 LrZRpsRMcKBnw2DbO4B2cErSe39hgKeIjpZz4+Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 046/241] net: mctp: Set SOCK_RCU_FREE
Date: Wed, 23 Apr 2025 16:41:50 +0200
Message-ID: <20250423142622.390159395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 52024cd6ec71a6ca934d0cc12452bd8d49850679 ]

Bind lookup runs under RCU, so ensure that a socket doesn't go away in
the middle of a lookup.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20250410-mctp-rcu-sock-v1-1-872de9fdc877@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index f6de136008f6f..57850d4dac5db 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -630,6 +630,9 @@ static int mctp_sk_hash(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
+	/* Bind lookup runs under RCU, remain live during that. */
+	sock_set_flag(sk, SOCK_RCU_FREE);
+
 	mutex_lock(&net->mctp.bind_lock);
 	sk_add_node_rcu(sk, &net->mctp.binds);
 	mutex_unlock(&net->mctp.bind_lock);
-- 
2.39.5




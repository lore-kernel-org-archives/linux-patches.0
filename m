Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6A280CD4;
	Wed, 23 Apr 2025 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419764; cv=none; b=YrE75Rc3rw3G66A+Jko1/7BfJyPUuhuoz8Xmgr85xlGoxWhZGPMuJy/5CkxPx83OKhY46SOpwGwhpH34PCmHruwz9kkLhkeyEKbzowt+TC/ELG3nbu4Pla3vZ7S2kodrzR4QKP8IL37JK7J54U4aOwvBXx6PGtgNQqc5GKePAVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419764; c=relaxed/simple;
	bh=qDD4jF4dw8yHOxQjreqnE31HKok2GNCIr3xYlCuml8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEwpw/e0TTX4iT+ydUkPsYnydtrJh3Wq3c1trTwXVBXi3McnVV6Zpa8pB1Mzs+0d/0WcAeXW/Ey9KUORO5ySX0sbr2xIc+agR94Ul2ADrxM+0+6pm4rhMLSxeyRRArY0/ZGfjbMRH5gvVQtHNjfrABBQZL37C/8MuQMrYpNe4FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v73tUhAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v73tUhAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AC4C4CEEC;
	Wed, 23 Apr 2025 14:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419763;
	bh=qDD4jF4dw8yHOxQjreqnE31HKok2GNCIr3xYlCuml8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v73tUhAfiHbF4QPCT3uLhjNa99JtxHKdKITc+7c8vVP9RTSnswjB51CWzkeUTfSGC
	 DI8aPVsGOL8aET5G23EJuaEtO5G6FqwLbMgrvyzjVMrENCp9as67B8fhEUVCtCZpUI
	 xlbQ8sg3QWERpOhUTygAt8592fayqU1dDTvE3KHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/223] net: mctp: Set SOCK_RCU_FREE
Date: Wed, 23 Apr 2025 16:41:56 +0200
Message-ID: <20250423142618.928143451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFED41D4FE;
	Sat, 12 Sep 2026 13:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218775; cv=none; b=EqttRrKdkyiKKZJhdJRp4WGIdFrE54kIkbdasqfvcDTwrQ5I28UBpAUlBo4nYRXnBkquyJd7mj5cRoK2CzvFZp4KQCHScMm7orw9Sq/A2XDphJrk1S77HKCpbzdhxOD7YeGNmMq2tex2FeSBJIg93Uf78fMh3XJ8RQLGdnGWsRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218775; c=relaxed/simple;
	bh=8ku4IN6HNIiNfU6H8aUguI5PPla9sP0eOTcKJNqT+1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCudNlHB+DA3gutGUy+tZf1EMmqcPLJyZxESzhH2EcRmNhFM65epG8pfyLZpB/UybJNs2xg/9znDiafrZw0paR2L1FcNLdgxMQMMIgOzMb6216GcTiJBbsI2s8gWSNtVzHzq98I+6xwlIZjEcH57911FKNyTcy0vEFUHuvrDiz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFqY2x4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFqY2x4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4311F000FF;
	Sat, 12 Sep 2026 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218773;
	bh=kHIFZFssnd8glnZlN8Wu7hiezTugruGBx+2+s53sDAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFqY2x4M0x08iwKVMcH4MqE5u3kTHj9izbFEMtN3elRoQPkbCP4muMAuL6H8wjyQa
	 wVpuaBL9oIy7PTsmcdtsMIMPGBjy+NRzvoTBvgSaMu64F2ajKXSGse6ScMh7K8ltQw
	 0hLmNJxIAut2tPBeXjS2MoMoLc8Ra9Rx2FuLhQVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1215/1376] net/smc: hash socket only after full initialisation in smc_sk_init()
Date: Sat, 12 Sep 2026 09:00:41 +0200
Message-ID: <20260912065634.630518177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Mahanta Jambigi <mjambigi@linux.ibm.com>

[ Upstream commit 8acf691d8017012e1476c30e7381513c1e929c94 ]

smc_sk_init() calls sk->sk_prot->hash(sk) before several fields are
fully initialised: clcsock_release_lock, the saved clcsk_* callbacks,
use_fallback/fallback_rsn, and conn.close_work.  Once hash() returns the
socket is visible to concurrent hash walkers, which can then observe
uninitialised state.

Move hash(sk) to the end of smc_sk_init() so the socket is published
only after it is fully constructed.

Fixes: d0e35656d834 ("net/smc: refactoring initialization of smc sock")
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Link: https://patch.msgid.link/20260813074315.554926-1-mjambigi@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e5352d80a9e54..4005cb1c04970 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -410,13 +410,13 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 				      "sk_lock-AF_SMC", &smc_key);
 	spin_lock_init(&smc->accept_q_lock);
 	spin_lock_init(&smc->conn.send_lock);
-	sk->sk_prot->hash(sk);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
 	smc->limit_smc_hs = net->smc.limit_smc_hs;
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
 	smc_close_init(smc);
+	sk->sk_prot->hash(sk);
 }
 
 static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C317934389C;
	Sat, 12 Sep 2026 09:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204328; cv=none; b=Im65dVa6vBOqvKTyLmUhzTJy6KFzquepwSpiiv9vnc+n5k1KsXf1CpQNrjmvMJxK8rtkD01AL0qy0uDv54/mZiDkxg0esJNeLlys6pnE6yA4fMDijUcdItXoxeBXANkaPhDicY/PISPIirAyzV5bPnYiKoZljn8q7akbFsU4dK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204328; c=relaxed/simple;
	bh=ZSonDLhNokb/dtwtqGny2abY1lTMqJkPmbZFlBHmCQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM3W3lsj17PbLTnyQvC1MBUwTGrl0I8tk+JE+1AKgaIHVQKmRKgqcEOZY99riDKAWoATlIv4uhVCJUhQWGv7wfB4k5l4vSMuQhHHg+szqDp7MfhGF3fEaI5Yv/SA6x4yYhhZcYjpNlc+qXazKTBP8oqPk+Jqs2fW31OTyynxRfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWsyQ2sL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWsyQ2sL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BF41F000FF;
	Sat, 12 Sep 2026 09:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204327;
	bh=OjombzsS/TOZ14uSpDftiVRUGPfXXg15srbTl54T0w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWsyQ2sL6gG/P1N11Fgh8n3reJGpkQNOCcTPTxQ0FDdq9gsXrveRtoGqQmg1TYXeE
	 pBc3lgTQ2FOp34h16l9tHDIDJvNJ/8zgK6FQvQ1gB4X3WUIf+NB2ehVisb0IT+5ybF
	 FR1QhgFo2vwh0H2gZOqTRJL7ux8tS5hicQgVeGT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1589/1815] net/smc: hash socket only after full initialisation in smc_sk_init()
Date: Sat, 12 Sep 2026 08:55:39 +0200
Message-ID: <20260912065726.293775518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cff910cedbfcc..e9f93b3ab435b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -409,13 +409,13 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
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




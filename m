Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93463433BCE;
	Sat, 12 Sep 2026 11:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211693; cv=none; b=eKMfFNxe5pSH8iTc6+omycEhxT658MjSW2vCpdXezYFNXnEHGAiRZwRpzBDHMEn7ihUAn3iIAGw/DB7fSD8oLktLe3JOqzt6vD6MNDSLTr1TvNShZaq576yje+BuKrdVGY/LkMXYexXomDJCOw3/P12IM7BkXAsAGuQnVgZxMKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211693; c=relaxed/simple;
	bh=FHKiuLpaaa68f1oqBZ3oAqwk+NJwWTIcIeDnLKU1ZSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5hT+84CrykmjpD/G0pO6+Ur+nlyn9wDn5RIYjWceCfaln3sh4w5xd4s69Eofwil6kxaKIu590XvUIGsPAjfXrnfkncIjNoQCHMa3he8KFZNjmqPrV3xsQDQnPfDDKv3hRA4+QasRM1QlMHf6bzi3NTwrVQ/u5ZZsZtnJHo7VY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyhUODv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyhUODv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93FC1F000FF;
	Sat, 12 Sep 2026 11:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211692;
	bh=LJcere5QpVfhfq/4bTeykVST04QeCtP6XR/1dv1Lr6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyhUODv2bO/iJojVNCcIMBllgw7JuvQ8XVBknZCbINkuubtXJgfmkht5FtiTxjfIs
	 BLOl/jEXsV6wWc+kP4n6f6j2OP+BUudhRyChSSu/HX4CUMU5eWK6v+mcgl1FeLgied
	 QwnSF+j8CcL95ZcGb8gmhfv+7sZaVFua3rGOb6F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1281/1518] net/smc: hash socket only after full initialisation in smc_sk_init()
Date: Sat, 12 Sep 2026 08:57:30 +0200
Message-ID: <20260912065652.491214686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6057a7d9718b1..e23390d9326b1 100644
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




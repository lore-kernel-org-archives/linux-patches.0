Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CAB28BA82;
	Wed, 23 Apr 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421847; cv=none; b=GWulu+hqj+8Uu/Qrh2ystr4uObWYsWW02hqmM4MrEG2497jb7rcRlj/yzwEu55cTYnald021sZQgK0BkIla1C0n840NPpoSWA2A8F6tClVu+eyhS8FcPnUWCCXRRhwMfKke1Ay4wJtqIrnkyyZeKuHT19ve3I9MTPyCPMPaPspo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421847; c=relaxed/simple;
	bh=mHhTKma7nyxSk1Lv/V6p4/6odAWEQ/8wN9ams2VrMmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srKGvQYso9wvz9/kqCU5Z0zbDGZ6Eaq9L4nLiR3y5ZIskeqr3fuVJ7uDSXyIwc9YDv3DWvG6quICIyFmSWPY4NovVFu7eztRmvkiq2vUksH+kydG4Demgs2UYGojY6gEh06siQDax/3hOXhbNrByJWGJILZQ6kjAOpK9FpKNq08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hXPNFyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hXPNFyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F400C4CEE2;
	Wed, 23 Apr 2025 15:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421847;
	bh=mHhTKma7nyxSk1Lv/V6p4/6odAWEQ/8wN9ams2VrMmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hXPNFyt5eY9vsokyU/xuToCqZgcvKFUmit7bAaH7hTP3sHDELuIrADBQmAYTbq5N
	 aSyBw+tCB4U94B1XKV7s32GWtVXxyK1pd7HP+m8RU2fqoVRbLir1tCt5ZwxJo+c558
	 tpUtAP5i3TtEhGWc2xgLd3eoSvQsNywdh7QFkTxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/291] net: mctp: Set SOCK_RCU_FREE
Date: Wed, 23 Apr 2025 16:42:54 +0200
Message-ID: <20250423142631.937092908@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2316e7772b785..6a963eac1cc2f 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -551,6 +551,9 @@ static int mctp_sk_hash(struct sock *sk)
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




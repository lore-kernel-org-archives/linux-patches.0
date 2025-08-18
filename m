Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04D93469F4;
	Mon, 18 Aug 2025 13:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525449; cv=none; b=HV1sUL4Dr2KErUlVWDjYNg19nrKAKRhO6TADzsk8MWhSqfTgw1aMrnKqj4lzjm9m7ephoi26khYW38OjbT3GRMG8XSLgnOciOvIA7sStPcC05h+9uMtA/Elcw6XHpZuPqOPahib2V29eksAp4W+rht1pZFTyfyEu5DoCuPDXeiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525449; c=relaxed/simple;
	bh=GY1G0X4FJiJ39L01qwz6EZhCz6C5cgvF1QC+xbv2xSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+jU9Mg0f0p0rXCr9r+CkxSHv0J3/x+38qQJtf0gFJt4Pi3Qf8LDHsjzD6vVeUhr7/Z9x/FJuLawdszNxQO4E/OSpYJBTfzMcNpWtQSveUTrwShakQpcew5bCRJRpnp8ll6apeeypEBrO7n+2zeCjIjFhCJ9oGVxOqIsJ9cMKps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM+lNbse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM+lNbse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F4FC4CEEB;
	Mon, 18 Aug 2025 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525449;
	bh=GY1G0X4FJiJ39L01qwz6EZhCz6C5cgvF1QC+xbv2xSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM+lNbsew0LBCKRBJu+8brtab/zkALE2HbRjrNW3X9b3nsJwYlakC+CD6042AtGT+
	 yS1uw6Zjy+yYDaR7Xc8xAzOIuF5f6buVEhWkh9nraDeToFIQKvXpM2x8JYFx8I7jKB
	 r3ZHhGC+QXQdZBo5bVsJTlqLa7N+CpxvWNnU1vD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 239/570] net: mctp: Prevent duplicate binds
Date: Mon, 18 Aug 2025 14:43:46 +0200
Message-ID: <20250818124515.027612368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 3954502377ec05a1b37e2dc9bef0bacd4bbd71b2 ]

Disallow bind() calls that have the same arguments as existing bound
sockets.  Previously multiple sockets could bind() to the same
type/local address, with an arbitrary socket receiving matched messages.

This is only a partial fix, a future commit will define precedence order
for MCTP_ADDR_ANY versus specific EID bind(), which are allowed to exist
together.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20250710-mctp-bind-v4-2-8ec2f6460c56@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 9b12ca97f412..9d5db3feedec 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -73,7 +73,6 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 
 	lock_sock(sk);
 
-	/* TODO: allow rebind */
 	if (sk_hashed(sk)) {
 		rc = -EADDRINUSE;
 		goto out_release;
@@ -629,15 +628,36 @@ static void mctp_sk_close(struct sock *sk, long timeout)
 static int mctp_sk_hash(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
+	struct sock *existing;
+	struct mctp_sock *msk;
+	int rc;
+
+	msk = container_of(sk, struct mctp_sock, sk);
 
 	/* Bind lookup runs under RCU, remain live during that. */
 	sock_set_flag(sk, SOCK_RCU_FREE);
 
 	mutex_lock(&net->mctp.bind_lock);
+
+	/* Prevent duplicate binds. */
+	sk_for_each(existing, &net->mctp.binds) {
+		struct mctp_sock *mex =
+			container_of(existing, struct mctp_sock, sk);
+
+		if (mex->bind_type == msk->bind_type &&
+		    mex->bind_addr == msk->bind_addr &&
+		    mex->bind_net == msk->bind_net) {
+			rc = -EADDRINUSE;
+			goto out;
+		}
+	}
+
 	sk_add_node_rcu(sk, &net->mctp.binds);
-	mutex_unlock(&net->mctp.bind_lock);
+	rc = 0;
 
-	return 0;
+out:
+	mutex_unlock(&net->mctp.bind_lock);
+	return rc;
 }
 
 static void mctp_sk_unhash(struct sock *sk)
-- 
2.39.5




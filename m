Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08F2334379;
	Tue, 26 Aug 2025 13:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214404; cv=none; b=PUc45DZmY0Y4xtnBfH7ELhqSiLyqMV0jIW/3r2Uf8AA/nok+P/P2gF9Dr4KNa97VqyVHHp6CVXSp2hZVtVOKJStTva7jThp18mHTWi5v47vuRnAsZ+mnaMKJjmM+DAsy6VzOCWbovEe5+4l2JpaqCoNb02HRsBXG/xCqC8F0mMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214404; c=relaxed/simple;
	bh=w5sqj+qaKfpes6c443ffesGQJtxcz9/sRM1YBVcJ4rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6h1fHkS9DStWNvol9lcS/fLFUe/5tPW5yj6P1fs0scHu2L/XLdEMip9mOrHx75cJwMah6ldMOGLPO4+TbvWWYK7xrNk0XtMiCWb5A2YPCuvs+TqNyp7alNTQoHXvHSzQJJJF35sqJ1/tXAtpAxAFK1/Axsgqx7iAI8pIqal68A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5DFlp7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5DFlp7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1737EC4CEF1;
	Tue, 26 Aug 2025 13:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214403;
	bh=w5sqj+qaKfpes6c443ffesGQJtxcz9/sRM1YBVcJ4rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5DFlp7ng6EPsvEc4nkpkfvcHzGsSFry8tVxYsH/J6ya99yN1ScdcIax55VpjNk2M
	 JckG+G2QU8Jgrc4mFJysLzK2GpNz3r8ibw/+CJOLVZ1kw4lnssyeuqKTrcNmedxezZ
	 RBZKafDxfZWunN86lvRaOsDBoYGbgQ+4Cud3xTbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/482] net: mctp: Prevent duplicate binds
Date: Tue, 26 Aug 2025 13:06:18 +0200
Message-ID: <20250826110933.910624180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
index 6a963eac1cc2..0f49b41570f5 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -73,7 +73,6 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 
 	lock_sock(sk);
 
-	/* TODO: allow rebind */
 	if (sk_hashed(sk)) {
 		rc = -EADDRINUSE;
 		goto out_release;
@@ -550,15 +549,36 @@ static void mctp_sk_close(struct sock *sk, long timeout)
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




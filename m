Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B01A0BD0;
	Tue, 26 Aug 2025 12:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213029; cv=none; b=Z7ObgGEavd+8GfsnVFiZk7nCl9TqPdNrlwZo8nT/XfELiw3YFkbZoWSsmb2VjjmFnr2fr2bE18MIh9NCSvb+HUV2LLxGLR5dMdK2UObxSxZuGbITtX8/05OnKwr46I47RSrktadOVSvABgF0auppmg9pqJZRf5vJrHMLVHDI0V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213029; c=relaxed/simple;
	bh=mIaazettDwWgxMxCqsOe++y8UNKGtTVtfSPMHDOZIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlFKuoeZWcACqyaqdTvjLP0JbqgljzNz6WyxynBwQ4V959Z8akc5w1UpO/e4C7v5W9Jodr6g8sZgHRZZn6eytj+iJtm47JSnbNcp63ypxINrfl7IGsNnk1pOjUECK+ZrDBcBJ9pd78ue7hkLNOX044CY2ESEfvt0d3feGxqnhnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aReAeJPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aReAeJPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5219FC4CEF1;
	Tue, 26 Aug 2025 12:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213029;
	bh=mIaazettDwWgxMxCqsOe++y8UNKGtTVtfSPMHDOZIdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aReAeJPI77koUk73Jd0+6GLVN9qC+4pLCeqeuSXiMqRczB3bv/8RRwTva4wlBctHX
	 QlwpvebtvWbW305e2xo/Qy/ixk6apYeKcXi8zInCezMuNEfx/+KK4RBP8A1J/Ii3m6
	 aXLSrszMhDFpXTySlWKpiCAkxZpJQCgjQ/6tOMAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/587] net: mctp: Prevent duplicate binds
Date: Tue, 26 Aug 2025 13:05:03 +0200
Message-ID: <20250826110956.865295244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8032cfba22d1..5f9592fb57ad 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -73,7 +73,6 @@ static int mctp_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 
 	lock_sock(sk);
 
-	/* TODO: allow rebind */
 	if (sk_hashed(sk)) {
 		rc = -EADDRINUSE;
 		goto out_release;
@@ -549,15 +548,36 @@ static void mctp_sk_close(struct sock *sk, long timeout)
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




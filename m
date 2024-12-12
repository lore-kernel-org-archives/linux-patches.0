Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BF8222D7B;
	Thu, 12 Dec 2024 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023530; cv=none; b=XFBsIcRa5F+tT+eDDmfDGbnjhhBMAHs/kFYcGW7/GXMD+q5Z/SQaZrQwV3OWCK1p003I2qDukdA6COBAVvQK7HK0OGE8DuT3USP2qgaJqxIijTn9PCxDQNVvAIuaDJDk8N7ByJMl3YPF7DUucQyoWjxPqnUEWLsGUdxbhjeom1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023530; c=relaxed/simple;
	bh=xrDCwL2ewL4dEqjIZFSSo0FffkZUNmwvJQgrMLg4KF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIMc3T1j3x2aEunah+LKBBcHaQCbgS5DRmY4YCtCpsAcX9fuGWm7hhJrgGQ19SeWmxYtMiZc4OW0rUS8cyQc3FqaLHzhbfvuBP/o2jl35ev22ZGTS3CSKghDiRnBbmLkzH5HfLW+wSJy6fZZCS15+RxKZ4uYGI5XhPC0cC1L08M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxnLo3El; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxnLo3El"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310DDC4CED0;
	Thu, 12 Dec 2024 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023529;
	bh=xrDCwL2ewL4dEqjIZFSSo0FffkZUNmwvJQgrMLg4KF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxnLo3ElFD8p7uq7B+5C9ZfxgBuZDxpmXKS5kG2Ys2Ir1BSVUspRLglIAobnKyTiX
	 R6d8m2TudCackHcSu44vhclx8arqJOZ/SkqMJym3+CMPY7B+HBUiK5STZJHhb9HTB1
	 xWeQbuN1lG4XqnTItQQVfmC4P3tIde5GZc/ttL6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 564/565] net/smc: Fix af_ops of child socket pointing to released memory
Date: Thu, 12 Dec 2024 16:02:39 +0100
Message-ID: <20241212144334.181942631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karsten Graul <kgraul@linux.ibm.com>

commit 49b7d376abe54a49e8bd5e64824032b7c97c62d4 upstream.

Child sockets may inherit the af_ops from the parent listen socket.
When the listen socket is released then the af_ops of the child socket
points to released memory.
Solve that by restoring the original af_ops for child sockets which
inherited the parent af_ops. And clear any inherited user_data of the
parent socket.

Fixes: 8270d9c21041 ("net/smc: Limit backlog connections")
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -79,6 +79,7 @@ static struct sock *smc_tcp_syn_recv_soc
 					  bool *own_req)
 {
 	struct smc_sock *smc;
+	struct sock *child;
 
 	smc = smc_clcsock_user_data(sk);
 
@@ -92,8 +93,17 @@ static struct sock *smc_tcp_syn_recv_soc
 	}
 
 	/* passthrough to original syn recv sock fct */
-	return smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
-					      own_req);
+	child = smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash,
+					       own_req);
+	/* child must not inherit smc or its ops */
+	if (child) {
+		rcu_assign_sk_user_data(child, NULL);
+
+		/* v4-mapped sockets don't inherit parent ops. Don't restore. */
+		if (inet_csk(child)->icsk_af_ops == inet_csk(sk)->icsk_af_ops)
+			inet_csk(child)->icsk_af_ops = smc->ori_af_ops;
+	}
+	return child;
 
 drop:
 	dst_release(dst);



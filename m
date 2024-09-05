Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49988194A5B;
	Thu,  5 Sep 2024 09:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530268; cv=none; b=bI2kRuK4dug/KSNmD0cCHpR3i1SEUOhoGDA1UVKHq5Myt/feJtAn3TUs+7p1AqbdGhbLrov/ExqUkT2toV6W04uKQQUFtV6Ea0yYF9Z7DTyLXYxQsUEMm/LNDTxgWllBklLdZ7nB80e/ztDSTOXN7m1g8Mtj3ZMZ6p4VfzHd3/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530268; c=relaxed/simple;
	bh=1t5/8PgfDLN8QWQN8vX1NeVK4KN/L2iyx49VUahGcWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hv43eMtOzM82wUau0892AKx5Qb03ekLbkl+eF9ARR10t/g01pGvg/Vb30hT8zK+3zomk30EtUjZxuNAbW0ml3l24D6tkaYBBHPf1jMwoYLt+vJxDoQWRzGuLFrZ8IG39+Qs3a2OSP2oUI9BL7tXCiHDdHKw8E4GjXhOblt3w/QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epVW0Mrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epVW0Mrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F2FC4CEC3;
	Thu,  5 Sep 2024 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530268;
	bh=1t5/8PgfDLN8QWQN8vX1NeVK4KN/L2iyx49VUahGcWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epVW0MrcuT/xCMirpL5hMUJ4imNNUVeEL3opTAT+3XveY1fnLwklWxDIZq7ydsme+
	 aIbUGB3ue13fiMlkHplhfVMcg3VPEt4oEy1p1AImzZpzZaZjfEm/l/JBZXP0gKmpuZ
	 GiO+PlFPK7tLiCbWSpXMtvJzqN5QVaQrr6U+QhIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/132] smack: tcp: ipv4, fix incorrect labeling
Date: Thu,  5 Sep 2024 11:41:33 +0200
Message-ID: <20240905093726.356116579@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Casey Schaufler <casey@schaufler-ca.com>

[ Upstream commit 2fe209d0ad2e2729f7e22b9b31a86cc3ff0db550 ]

Currently, Smack mirrors the label of incoming tcp/ipv4 connections:
when a label 'foo' connects to a label 'bar' with tcp/ipv4,
'foo' always gets 'foo' in returned ipv4 packets. So,
1) returned packets are incorrectly labeled ('foo' instead of 'bar')
2) 'bar' can write to 'foo' without being authorized to write.

Here is a scenario how to see this:

* Take two machines, let's call them C and S,
   with active Smack in the default state
   (no settings, no rules, no labeled hosts, only builtin labels)

* At S, add Smack rule 'foo bar w'
   (labels 'foo' and 'bar' are instantiated at S at this moment)

* At S, at label 'bar', launch a program
   that listens for incoming tcp/ipv4 connections

* From C, at label 'foo', connect to the listener at S.
   (label 'foo' is instantiated at C at this moment)
   Connection succeedes and works.

* Send some data in both directions.
* Collect network traffic of this connection.

All packets in both directions are labeled with the CIPSO
of the label 'foo'. Hence, label 'bar' writes to 'foo' without
being authorized, and even without ever being known at C.

If anybody cares: exactly the same happens with DCCP.

This behavior 1st manifested in release 2.6.29.4 (see Fixes below)
and it looks unintentional. At least, no explanation was provided.

I changed returned packes label into the 'bar',
to bring it into line with the Smack documentation claims.

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 6b92e09d3f78..98c2bdbfcaed 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4354,7 +4354,7 @@ static int smack_inet_conn_request(const struct sock *sk, struct sk_buff *skb,
 	rcu_read_unlock();
 
 	if (hskp == NULL)
-		rc = netlbl_req_setattr(req, &skp->smk_netlabel);
+		rc = netlbl_req_setattr(req, &ssp->smk_out->smk_netlabel);
 	else
 		netlbl_req_delattr(req);
 
-- 
2.43.0




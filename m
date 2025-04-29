Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE75243964;
	Tue, 29 Apr 2025 17:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948870; cv=none; b=ko7PzthAaNBF0G0hgdXyZ3zkb8vWFin+vxdWHoZL0VqP6tg+5Tn0mHTwOgBi5QDn/VphfhgTyZaGm4J0eoBbR/CHlo58i/KwGBTMFgmGT9ylEu/XGQyCSoDhW6AZcyb/uwHOD/n4Z8t9JOQRmFJl+/2MkYvTbDFEZq/N3wHZlXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948870; c=relaxed/simple;
	bh=YkutJcz7QKYEG3H6tlZB7UC5aBxkClo4Rg14abSx95c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mR33ElL23xFdD6D/GvNBIl04L4FQBojdgAMTAZzNEZmmeDzXMClhzHYyrIxcHO0iDveX8MMvT6Yti/ueoj9Bj1GvNLlIimf2JOxdIV769kDFU7a+0DaNeuex+w85MYyWS3RGyr4s5OYWHLCDI6UxfzFlJnoLL7pJXA0oUsWojQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7UkpdxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7UkpdxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54C3C4CEE3;
	Tue, 29 Apr 2025 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948870;
	bh=YkutJcz7QKYEG3H6tlZB7UC5aBxkClo4Rg14abSx95c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7UkpdxABHhFSaifSyb8fbNhKmXAbwjS7Ht+OOLjqITG75jlur/5NFVMq69iZql2n
	 0vRqEXvEaNjGz6OcCrZP9PyQPookZw+eyerg3dIL6vnV0EydGfVoSB6/wDT0i6uCp5
	 SnyJXvlrCHgQhJk1mcd6aNyDzx+DKosQdinFdZpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/373] net: mctp: Set SOCK_RCU_FREE
Date: Tue, 29 Apr 2025 18:40:21 +0200
Message-ID: <20250429161129.089031056@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ca031866ce1a..53b3a294b0424 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -253,6 +253,9 @@ static int mctp_sk_hash(struct sock *sk)
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




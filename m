Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71474F85DD;
	Thu, 17 Sep 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664378; cv=none; b=Fc9l7c7MEWVbWoeakp1BnX/hgIgSWqgLTfvnZgxMhwYIjS8ImvPIUM0F/+e0FgErz39FOuzn7U2eFB+r+VVIMBcSLEVWBvpRMJN4gpAvH+HAwJaMW5WU3f7UV/UJyWdmpwaGg0g3SBYWnutKtIYWlmxsvm2RuZKjQBX14ZlovjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664378; c=relaxed/simple;
	bh=TaolKg3UH9oJwD27/0yfUoj4fKlK5qWOyuOuskPjGkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKmEPbKUxgkemJG5HtXnEuXokrJYWcF7osNi+1JpUxg/mGRsjlIQhdkOG152X/y5PwTj7PNP3xV0cGfNseV7teNZYaXJnMryDbdKGTYzDe0Ma0muQvFwnt9FYQm9ouj91iitzPhtwu9TzFNVeG1+5x1nM5/Sn/RrRAEixD+eDDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqiwVYSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqiwVYSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2DA1F00893;
	Thu, 17 Sep 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664377;
	bh=uMZTb/TjrZMSrS6gVYtNLx8fkAdoso2XzQ9y1/1dBXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqiwVYSr2zy1eturm9+bBhUjhHcdO+x8LEqanbKr/DL53xrfGUNcel19VRj7Fc9H5
	 c49vb0M2e1NDoc3WTFGKaugBTwoBsMWD7NA6xdpkZZMn6Q2hyMFXnrlUYmSaaLiVVC
	 AEpO6Ro/LwzV0z3gLdCfgV09FENiFar8s8lFZAqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0336/1250] ipv6: use READ_ONCE() for bindv6only default in inet6_create()
Date: Thu, 17 Sep 2026 16:02:11 +0100
Message-ID: <20260917151601.193515417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 7a20eb54224ab7481c1f5a1619a6a5677be93eed ]

inet6_create() reads net->ipv6.sysctl.bindv6only locklessly.

Use READ_ONCE() for this sysctl access.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260602002414.1504106-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/af_inet6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index f8e1dc4f3227f..1c45e1d15506c 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -226,7 +226,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
 	inet6_assign_bit(REPFLOW, sk, READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
 				      FLOWLABEL_REFLECT_ESTABLISHED);
-	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
+	sk->sk_ipv6only	= READ_ONCE(net->ipv6.sysctl.bindv6only);
 	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	/* Init the ipv4 part of the socket since we can have sockets
-- 
2.53.0




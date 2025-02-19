Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE31E47A5;
	Wed, 19 Feb 2025 09:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957488; cv=none; b=RD2udxrhet7mO9knNYM9oJr8dxBGpbO8ZFjs0rqUBvtLmHf51zmrujPMVt3bHW1muKOM57sYsPB0UiTk5hDc1DVh9UGPXpfITJJRRk+xuzg5mPWe4XT9v2q+aryUgszZdGXGChgJcwDkIN4nIadTLi5PENKgvoCaBN/x9uilZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957488; c=relaxed/simple;
	bh=nKv56Ils0Y9/D85hEa+B3jlOUWLCtS+koJ99d5uwe8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8zl7eWE3vZY5okIKLc8p+S79MUUluO9bYYkhATedEZJOKVTQEiBP5p/nFRq9vvmfv6KaX6bGPOz6zbpLwaHCduOPGZfvwJrnx0FX5alHvx+MU8oCoeY9Yj34n77PYR8VLneClDzpqJ8q94VakucIdCtRUACXqO2AZ8FdYdKDzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU/uQogs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU/uQogs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D921BC4CED1;
	Wed, 19 Feb 2025 09:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957488;
	bh=nKv56Ils0Y9/D85hEa+B3jlOUWLCtS+koJ99d5uwe8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CU/uQogstSEM0bIrAh3digX0q+3re4g2fqU0uyodbO9JI6h6Sxs4w5ApnFsSAoz2t
	 ZM4qBWTtG5a/kuc6KxRguEyCauclV7pm6CxHZqhkXzxwNUkvwNGnwpmh68YSsfBdJm
	 6BHcXwUu5OmZX7OzwX4aUAVhRLPFDEGVTbQeM6J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 543/578] ipv4: use RCU protection in inet_select_addr()
Date: Wed, 19 Feb 2025 09:29:07 +0100
Message-ID: <20250219082714.329470880@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 719817cd293e4fa389e1f69c396f3f816ed5aa41 ]

inet_select_addr() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: c4544c724322 ("[NETNS]: Process inet_select_addr inside a namespace.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 430ca93ba939d..1738cc2bfc7f0 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1320,10 +1320,11 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 	__be32 addr = 0;
 	unsigned char localnet_scope = RT_SCOPE_HOST;
 	struct in_device *in_dev;
-	struct net *net = dev_net(dev);
+	struct net *net;
 	int master_idx;
 
 	rcu_read_lock();
+	net = dev_net_rcu(dev);
 	in_dev = __in_dev_get_rcu(dev);
 	if (!in_dev)
 		goto no_in_dev;
-- 
2.39.5




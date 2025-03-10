Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E06717A2E8;
	Mon, 10 Mar 2025 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629727; cv=none; b=f2b9txJImez5BDiILH810T56oqBYqfp7HGzvqzQIILrLC60zm/w3xwT16KZQHYck6APwsjBl1NNLNAINw4jEtwCMUrL4/K9hYycC/iQb5zXOAzzBjSaKLXTshbYtXTqlQZHNcj6LhDNDOucxhGbS2N+SlU1tbFlhtWpHjDScUoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629727; c=relaxed/simple;
	bh=V+mKPAjzViWrgkOicHikaFK8/NTfYV4aMGOqAe4QGLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9GnVC4+bxecJzh2P3VzJk/OMo+MSyubCfjPXqGWDjP+AjRea70ELMxP9y0S9yVnJn+TlCqIFis/0Wb6IFabj6y3YMdO0OszxZ9Fdtnlid6NfzX/+WrwR8G8pcFcxKjyEjXBoffhTH5DAiEKm3MZtG6Z+r/7VWc6sGc65eIuk+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVYY1fYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVYY1fYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1795EC4CEE5;
	Mon, 10 Mar 2025 18:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629727;
	bh=V+mKPAjzViWrgkOicHikaFK8/NTfYV4aMGOqAe4QGLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVYY1fYJT9GA5j3II6uZLHL8+ldFvUYBaen6m/4e7xnb0KZY7GdUiaaAOsBLRRBF/
	 DkCYHsNSJ/Uv2HMqFbGdHXK/nYBKY397xKugnKpNKxCbVEDvkNjsaJjXS9aYPpmW90
	 Qw+E3sd3IgtAqPkNYTdlnuSAoVCPZN9vB32nbnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/620] ipv4: use RCU protection in rt_is_expired()
Date: Mon, 10 Mar 2025 18:04:01 +0100
Message-ID: <20250310170601.183464959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dd205fcc33d92d54eee4d7f21bb073af9bd5ce2b ]

rt_is_expired() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: e84f84f27647 ("netns: place rt_genid into struct net")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 3522801885787..3ad78bbd6261b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -400,7 +400,13 @@ static inline int ip_rt_proc_init(void)
 
 static inline bool rt_is_expired(const struct rtable *rth)
 {
-	return rth->rt_genid != rt_genid_ipv4(dev_net(rth->dst.dev));
+	bool res;
+
+	rcu_read_lock();
+	res = rth->rt_genid != rt_genid_ipv4(dev_net_rcu(rth->dst.dev));
+	rcu_read_unlock();
+
+	return res;
 }
 
 void rt_cache_flush(struct net *net)
-- 
2.39.5




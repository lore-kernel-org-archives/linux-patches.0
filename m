Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E136D25DD0B;
	Tue, 11 Mar 2025 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705950; cv=none; b=MlPO//o0tt5udNVpGLVTS54qa3tqnY4qTRY9RUk4Lpm85scnoZMVgln3mtLpRPfVb25IwHZjNeECGiwm6/lsZL5LNRC4MHUt8+4ELIc/qFhohiJ9Mmeg+ErzShdTVbGpB515PVl1RBBKqR7UI6JfT6eGXFdBY7h1CB6rl2a/nxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705950; c=relaxed/simple;
	bh=7N3a5h6knIjxQJTKzEVzofJ3DOrBsYwxVVCmcdaMYao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=se3vzwtCk4MYjkrLEqXpEogB07xsRhTkXzUshPNI/ZlWjc1ike+M90ZxY9wuBPw2hIP+fmeq55QvKIDvIhH0K+k30ND+Hj9Je0UvqYepMbJK8pQRikpAL7zY7mg33ryKlEM2CnZotH1ZX+9NT9HRc72sn6HK8Fou1+PGyqnZ6b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9OqTU2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9OqTU2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64265C4CEE9;
	Tue, 11 Mar 2025 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705949;
	bh=7N3a5h6knIjxQJTKzEVzofJ3DOrBsYwxVVCmcdaMYao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9OqTU2dV0eSo6DnD288rBrtkExx2F4YDJVvRKXq7TMOarFiT8dEn1W3eyahx4uOM
	 vTXqrLniqGbCAJP9RzAqXxa3bERfMk87WMvwT1i8TfArm7/H/T3CWphiaCzH+oEouy
	 B0iKpP0PobA9pnq8ow4cmG2uWhiEQhLH/DBeHSdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 203/328] ipv4: use RCU protection in rt_is_expired()
Date: Tue, 11 Mar 2025 15:59:33 +0100
Message-ID: <20250311145722.970388252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f3e77b1e1d4b9..da280a2df4e66 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -423,7 +423,13 @@ static inline int ip_rt_proc_init(void)
 
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




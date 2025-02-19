Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58BF1E3DCD;
	Wed, 19 Feb 2025 08:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955276; cv=none; b=X2AeDZhS3/H7G8MjmmR/5nf0MVOQtU+cVHLtbhNxGHBZdmc32smK1F0+BaMb5MRrpJArU6+5F92YjghFKaSTYSrOeq11Gl4IEFcDd0FZliZCs/iDLMtuQSdG+y7Tcfedf2gmyjQl3qAnA0sraW8Bgw4diFHwq7uZRXC16pSnsH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955276; c=relaxed/simple;
	bh=K4wJIgy8K5MAcAuNxzT/QezWd/JFTk+4qs2Wke7FLnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VT93oBnlO008crg1bFXLPib+mgw7acxahkN7xNxf4D7EyZVtGGI4irwuSqwHsXfngl5F3umEfIcob9IixauiMI/q5c3m2FNB1O9nGOfJzNpD61JHUSdL2np0lq38AFqWesl5rArrduWH0bti2SFlOdUVfWQl0Hp9NHC5KCLUPV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYOKUWkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYOKUWkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6733DC4CED1;
	Wed, 19 Feb 2025 08:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955275;
	bh=K4wJIgy8K5MAcAuNxzT/QezWd/JFTk+4qs2Wke7FLnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYOKUWkTrh59ArcL/2YoiJeRRv/gK6NhyoiVaqtOVsoS15LWuP160kx/k9f61Xu6F
	 b8uH61+w0uDco80CPfFRBV2DTSc/Hrht5eFFZjYf7ivx7ZSbZNj2S+C0uOzHvzySFB
	 zGWW6h2ZzovYyJ+kSr70raZVMxcVZFeuEKAsTJfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/230] ipv4: use RCU protection in rt_is_expired()
Date: Wed, 19 Feb 2025 09:28:23 +0100
Message-ID: <20250219082608.977894829@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9709ec3e2dce6..e31aa5a74ace4 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -390,7 +390,13 @@ static inline int ip_rt_proc_init(void)
 
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




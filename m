Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B811E5B7E;
	Wed, 19 Feb 2025 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955272; cv=none; b=MkXVuMNJbKNwNLANG48TkJmx8wTvRMygLTNpfyzJqD43Cyk4hxgobbg263lbJGP41wwkhm8JzPOyc+tm6wehnGxA90rSaBGAyBjJ/W6HbWW/IRNsI0xQSqNRyNjQX2SKc1lDorKPBJVs2APR6Mh9jRuPDSiLEeKKO45h/e/wdk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955272; c=relaxed/simple;
	bh=d6JFwVQj4DGAszbxpQq6GKlRexR2Wp91XEbGnjWVqnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+Pu7DRxsBs1IoY3565yOSrolBnuRNa8AEHknaTIqXY0Q4FwP8fmNUZl7hS5j7lWr2HJJ2ZBpJqCK2/3yBVQHUB+ewlwNy1NCmj858nCNqUlEsprGElasXf6DYzi7xD6t0ADAKJQkTinBKkfdf+6g/BcQew4G8SET8QAQxI6bH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFV+bLwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFV+bLwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFFCC4CED1;
	Wed, 19 Feb 2025 08:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955272;
	bh=d6JFwVQj4DGAszbxpQq6GKlRexR2Wp91XEbGnjWVqnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFV+bLwBq9/oPVppEs82wpDSOPLoRotj9kgDsJe16bhezCCeOk+b1klFNQLzQawbV
	 QdiHL58kXen8vwV8B9gOTS9IOyTKQdts+06Kqo+rgyPMuO5W3YYvriYpyjt54rUmtN
	 w6EXxyCz/sHOWye4icQuGSHxtEj+qWo3fXzf2fbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/230] ipv4: use RCU protection in ipv4_default_advmss()
Date: Wed, 19 Feb 2025 09:28:22 +0100
Message-ID: <20250219082608.940236105@linuxfoundation.org>
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

[ Upstream commit 71b8471c93fa0bcab911fcb65da1eb6c4f5f735f ]

ipv4_default_advmss() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: 2e9589ff809e ("ipv4: Namespaceify min_adv_mss sysctl knob")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2a27913588d05..9709ec3e2dce6 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1294,10 +1294,15 @@ static void set_class_tag(struct rtable *rt, u32 tag)
 
 static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 {
-	struct net *net = dev_net(dst->dev);
 	unsigned int header_size = sizeof(struct tcphdr) + sizeof(struct iphdr);
-	unsigned int advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
-				    net->ipv4.ip_rt_min_advmss);
+	unsigned int advmss;
+	struct net *net;
+
+	rcu_read_lock();
+	net = dev_net_rcu(dst->dev);
+	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
+				   net->ipv4.ip_rt_min_advmss);
+	rcu_read_unlock();
 
 	return min(advmss, IPV4_MAX_PMTU - header_size);
 }
-- 
2.39.5




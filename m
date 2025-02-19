Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770DE1E51F2;
	Wed, 19 Feb 2025 09:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957485; cv=none; b=Bd9B6U7ICH/0MsEIJwfo+DYGml2A6xEpc/VBvVzQYQLWifpHrFMr91558uYruE3IzMT9C/g4rcdqMcY/qsqjZ+12gEEYnHlxb/iFcAijic6a44gqZFAk/xxyWwEe0uPxg2NFSYT6NtooyXoV1bed0N+5ii73E50pC+Yr3/yyO0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957485; c=relaxed/simple;
	bh=61FJBTNs/RKf0j2LAD2r3Mebr11ERM6iV1dFifa3puc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2/bsXhqrjX1Dl/aNYTxvmuxGnd2wwIIDwwGw8ZWtIkaBZ6aOGkNzIGxKilvx2tIjdRTzEQddjWEFON6bsCSHw3+FGHOrXNkP4euGqGIkitPzvcDqY6sTFKBTnXO95u3auFyC8JxBE4qeszUSj+wLMaj8Wv3gdY5HcSDcVi7f4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCDAuMer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCDAuMer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A3FC4CED1;
	Wed, 19 Feb 2025 09:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957485;
	bh=61FJBTNs/RKf0j2LAD2r3Mebr11ERM6iV1dFifa3puc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCDAuMerGGUkaJiP/fE6rW1ehFPVoBRuo5fiECKI/IR/B5CpumxnWQTFfftRyJg0C
	 57hBz9Uf8uVMEx2y6KArDmSX9fp/1oYJMoP1JnYSffnv6La0XR9+nsulsHNnqtlpGC
	 8surEXZNtUlcgWZ4IuvWzQWhVzvsfZU7nHNkkjCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 542/578] ipv4: use RCU protection in rt_is_expired()
Date: Wed, 19 Feb 2025 09:29:06 +0100
Message-ID: <20250219082714.290146686@linuxfoundation.org>
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
index 5f18520d054c0..ae56d94f68d9f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -393,7 +393,13 @@ static inline int ip_rt_proc_init(void)
 
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




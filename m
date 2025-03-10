Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FEE2309B0;
	Mon, 10 Mar 2025 18:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629749; cv=none; b=uZCCgjZttV5bi/NA+v2h7AacFTLvt9E+B2HYmsLonw5KTC5Eujd6NcXOKuyjJgfQOQguFnYFLw7NQl/XssCoVvr0taiEcpMSLsAF/zNgSZ7igTljEY0T3FLPDmJ0kgJ7PWuVnBgJgRN993MYCJIixu5oaJ+NHEGvSRz1u0J15AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629749; c=relaxed/simple;
	bh=Gf2FFqi+wRlR2dDrrR9jdwhgJr/C0HMSpLYxh+JvhbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV0RhyhhwM9Aiw3QOBZtekKrYZlvDBoDhMRv5GZo5Lf+KXQualA6X78LdRbIqbiddt8iFdOgW1d/uQVeRPc0om8C3ZdWGo9y0oHMCoxfVDtg+tnRmvtMgsc8cBNcjPmSIVv8JZSOF69nfZKvsETQJRAQ70CKXGLv1o0vEiAGZYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFGj4E4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFGj4E4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40036C4CEEC;
	Mon, 10 Mar 2025 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629747;
	bh=Gf2FFqi+wRlR2dDrrR9jdwhgJr/C0HMSpLYxh+JvhbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFGj4E4QfwBUhPKguvpk2biHIP2GyeEv+LsU+RLYwF6T9XONx1pfE7N2Ua1m4+tsi
	 kKUC2i/QfJCGAKZliyE8JmiqhjYOjdHls56wrjEqON6A5tV7IlQC3Yaea698HzUkzY
	 NVQGVQ4IhpUrxnK1tGHvYsQqr+jcSyLVdwVMGY2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/620] ipv4: add RCU protection to ip4_dst_hoplimit()
Date: Mon, 10 Mar 2025 18:03:58 +0100
Message-ID: <20250310170601.068023039@linuxfoundation.org>
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

[ Upstream commit 469308552ca4560176cfc100e7ca84add1bebd7c ]

ip4_dst_hoplimit() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: fa50d974d104 ("ipv4: Namespaceify ip_default_ttl sysctl knob")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/route.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 30610101ea14f..036e3ee3b856b 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -357,10 +357,15 @@ static inline int inet_iif(const struct sk_buff *skb)
 static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 {
 	int hoplimit = dst_metric_raw(dst, RTAX_HOPLIMIT);
-	struct net *net = dev_net(dst->dev);
 
-	if (hoplimit == 0)
+	if (hoplimit == 0) {
+		const struct net *net;
+
+		rcu_read_lock();
+		net = dev_net_rcu(dst->dev);
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
+		rcu_read_unlock();
+	}
 	return hoplimit;
 }
 
-- 
2.39.5




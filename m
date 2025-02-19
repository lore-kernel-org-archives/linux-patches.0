Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38D61E3DCD;
	Wed, 19 Feb 2025 08:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955263; cv=none; b=aCWNCpkzH7ORwOz+l0vaFsiY12QPcyW8fBckBsafhVN97uIUYAgRTDPnwqUJntZqOgWjsqNAyADM14glmVMJ5SfEoRpAARweIpdItXA+yaAxlKZYQIOuHohcOBqkm0aG7pxpz6NgYeKCB3LjkolN3P9G5Vy+dsR9vbujOFpY6Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955263; c=relaxed/simple;
	bh=Fnp1h+pLwnF0M3yVznGRqDBEIHLVeJaAtjXg2Fkd+6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI/nv37k5Ihr63TW5EdyfLx/MikJ8jdAJKypYpjMK4+CjyHlyebLTOOYeMvL4he3Mri5GPv5pEamferLsW+vAbfgyG3uvYHsGv+ie8fiFo109oYmZby9/LHr89ffbhl3siuN6a2PzJn9e5AMSI306zmc4C+PP20c+Ey+sBTngaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgs24oN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgs24oN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21276C4CED1;
	Wed, 19 Feb 2025 08:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955263;
	bh=Fnp1h+pLwnF0M3yVznGRqDBEIHLVeJaAtjXg2Fkd+6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgs24oN7dAPlgY4dX6akiUxad9QbmLyjjr5edUF3N7hKazpKCvjxNVWh5MMh7b42m
	 G81rGRtrWTU6zvSP0jMB6piXQS4Ix/x9m7okS02I6bD1OdycjssxYcpJFaOXF5s510
	 ysZMx0ZNV1Qrkv0UT4J/xpE3+tDY7j9M0jIC2zH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/230] ipv4: add RCU protection to ip4_dst_hoplimit()
Date: Wed, 19 Feb 2025 09:28:19 +0100
Message-ID: <20250219082608.821341218@linuxfoundation.org>
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
index 1789f1e6640b4..da34b6fa9862d 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -363,10 +363,15 @@ static inline int inet_iif(const struct sk_buff *skb)
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




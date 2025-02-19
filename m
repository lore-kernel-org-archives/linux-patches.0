Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BD71DF977;
	Wed, 19 Feb 2025 08:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954484; cv=none; b=cwozS7iLPl/8ABHhCa6aRrwm4PUZlvoM0CPWEd2wQ/h9j3U3tEVEVJQ9AQYhLQeM/47XuIeeBW5bsmqSDYyuP1MnE6j1rBqS9rX+3kU0LhTQvUx6M3v6+sYLoDQUeN5SOFJeqzasrUTlwzUmLdJJ72G4rghvTEx5VLMIu2xzpTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954484; c=relaxed/simple;
	bh=04yG23WKX5ggqdmjN07FwJOwLW+ZTz/fDei1lvxOPYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJldwhVQuYimr+2GyUQOp72Vb1r6CFtgork2fJzfgDGZeu8L9o+olOxxn/O4lhFWGcZv41vql5TL5oNTZGjqx4J6jOb2+6q5VY4MKgPVYY2jpn1s9pqTY3BlKprNdjYkWuZnPa7pfbEOomPV+1OCT5Y5eHF0KUwWnhIicBMtxrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaqsEhg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaqsEhg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95FFC4CED1;
	Wed, 19 Feb 2025 08:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954484;
	bh=04yG23WKX5ggqdmjN07FwJOwLW+ZTz/fDei1lvxOPYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaqsEhg+tlexJjAbNEjmgI6EyYMGBQNHSxLUdnwycF6+O6dynu/iYR8cyGK63HMBs
	 pJ7ZxbNJa4dIYGTQg3btPxrFXclUvO4ucIe6hCzeTyobnMFQqI+KFGLEkgxwrllnc3
	 T5MrAFsz/d7p2DzAY6maWlr/XFv8gBojfwX0kW74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 217/274] ipv4: use RCU protection in ipv4_default_advmss()
Date: Wed, 19 Feb 2025 09:27:51 +0100
Message-ID: <20250219082618.068856335@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3a1467f2d553f..829c8d41aaae2 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1307,10 +1307,15 @@ static void set_class_tag(struct rtable *rt, u32 tag)
 
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




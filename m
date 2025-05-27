Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A222110E;
	Tue, 27 May 2025 17:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367188; cv=none; b=KyOlVcNf8c35U8Nn3vSCGwnPIu1GpaHXWDRtH7zBC0/SAXJiC9Uvcyqi+JMRhXe03BPAbk+3JSfVM4V+Sfm138VzeHast15wHxBr5PCvJvLRe4vFLIfSTsdn6tMlGYguyVgG3lqsNMo+sI6Uu7YSrhpWEExHhsBgbANu+jBguzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367188; c=relaxed/simple;
	bh=r0muhJtmCraaG6mWR1yx2UbvGAvEYpc1i7bLqQ1wCbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIkMSBuM5JQMRb2J+4G9wVGzzTfG0rqZbL1ZxVLyoDYY4uo22AHWwFjQpVqhyRj58+llxbI0CiZHdkwoNc19RbU7N54kD0z4iU5da3qkQM5YWsEqib6t+RYdhp5eTmr8LHjqiInI8+VGim0N+s8Exmyw+6Fo3TQUd26BnRpzkL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrKnZUJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrKnZUJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8D8C4CEE9;
	Tue, 27 May 2025 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367188;
	bh=r0muhJtmCraaG6mWR1yx2UbvGAvEYpc1i7bLqQ1wCbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrKnZUJ1dvh9Ylw8avPc4JgexdCg+APNyubsRpKV55ydceKBVICMwALIRRiG3ZtIj
	 wN6dEAqd0RJglzdUldh6TbQnw7iFkOOQm96iYfl0M8t5VdVSXoHJBwdmkzn7xJMord
	 Fx4YtV0TFRNFwn6FaW3XHr2OeJimz0jwGPyhroeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 306/783] ipv4: fib: Hold rtnl_net_lock() in ip_rt_ioctl().
Date: Tue, 27 May 2025 18:21:43 +0200
Message-ID: <20250527162525.532636061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c0ebe1cdc2cff0dee092a67f2c50377bb5fcf43d ]

ioctl(SIOCADDRT/SIOCDELRT) calls ip_rt_ioctl() to add/remove a route in
the netns of the specified socket.

Let's hold rtnl_net_lock() there.

Note that rtentry_to_fib_config() can be called without rtnl_net_lock()
if we convert rtentry.dev handling to RCU later.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250228042328.96624-11-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 493c37ce232d3..8470e259d8fd8 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -553,18 +553,16 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			const struct in_ifaddr *ifa;
 			struct in_device *in_dev;
 
-			in_dev = __in_dev_get_rtnl(dev);
+			in_dev = __in_dev_get_rtnl_net(dev);
 			if (!in_dev)
 				return -ENODEV;
 
 			*colon = ':';
 
-			rcu_read_lock();
-			in_dev_for_each_ifa_rcu(ifa, in_dev) {
+			in_dev_for_each_ifa_rtnl_net(net, ifa, in_dev) {
 				if (strcmp(ifa->ifa_label, devname) == 0)
 					break;
 			}
-			rcu_read_unlock();
 
 			if (!ifa)
 				return -ENODEV;
@@ -635,7 +633,7 @@ int ip_rt_ioctl(struct net *net, unsigned int cmd, struct rtentry *rt)
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
-		rtnl_lock();
+		rtnl_net_lock(net);
 		err = rtentry_to_fib_config(net, cmd, rt, &cfg);
 		if (err == 0) {
 			struct fib_table *tb;
@@ -659,7 +657,7 @@ int ip_rt_ioctl(struct net *net, unsigned int cmd, struct rtentry *rt)
 			/* allocated by rtentry_to_fib_config() */
 			kfree(cfg.fc_mx);
 		}
-		rtnl_unlock();
+		rtnl_net_unlock(net);
 		return err;
 	}
 	return -EINVAL;
-- 
2.39.5




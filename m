Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D725DCE5;
	Tue, 11 Mar 2025 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705987; cv=none; b=uT84VPih9OYt0NrUE5BeaW39Rm1Itpgbu/sM7eU3IqHrgHFd1c6zEn4raf94fH4RDEZDoU8jaEOGobd5C+MOpx4uAedneIM7NgAQJD1s9niEl4Mq3pJWFk2+UxLfDYS5jZ+xt0hpWZCjOkxuI38gNKSt8K1zeYm3oiKczDuudlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705987; c=relaxed/simple;
	bh=lpx7osaaPRWZSbA1GdAMYTpRo0T8qjgGrSmWSDDIH8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiUBlvzSGsqMnkoq/oShGSTYQ8SJ/xBKPC3QKfDueVNRTGeBH1/oYKJkNdpC0L2M/xkivnLKkrD1mlPtems5CcEdtfIdsbJgIE1+4wuXeLb6IWRy7W4Uh5XWBv21ihr4qmFegwDQsbVudkxEkn6O67pUFCm3mWWDKhNtKxBLEjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+W7XSky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+W7XSky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA520C4CEE9;
	Tue, 11 Mar 2025 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705987;
	bh=lpx7osaaPRWZSbA1GdAMYTpRo0T8qjgGrSmWSDDIH8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+W7XSkyYg+0jf1LpbwGuL5uW+roLcZgdKqRfQKzVOxmQEJWYUSOuD06cxsmCv4UK
	 M/rkYNLFVM4fz+P/X3a93p426Dt6Yg/I91SJXawZjJmJAui2wwRmuSmIxFTmrwQocH
	 DUo3Tf5mUSMKRPaVXQNZvz+H4+idi16wZFaMpl3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/328] ipv6: use RCU protection in ip6_default_advmss()
Date: Tue, 11 Mar 2025 15:59:35 +0100
Message-ID: <20250311145723.056258655@linuxfoundation.org>
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

[ Upstream commit 3c8ffcd248da34fc41e52a46e51505900115fc2a ]

ip6_default_advmss() needs rcu protection to make
sure the net structure it reads does not disappear.

Fixes: 5578689a4e3c ("[NETNS][IPV6] route6 - make route6 per namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-11-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 364abcf4b6c14..99908861246d3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3090,13 +3090,18 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 {
 	struct net_device *dev = dst->dev;
 	unsigned int mtu = dst_mtu(dst);
-	struct net *net = dev_net(dev);
+	struct net *net;
 
 	mtu -= sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
 
+	rcu_read_lock();
+
+	net = dev_net_rcu(dev);
 	if (mtu < net->ipv6.sysctl.ip6_rt_min_advmss)
 		mtu = net->ipv6.sysctl.ip6_rt_min_advmss;
 
+	rcu_read_unlock();
+
 	/*
 	 * Maximal non-jumbo IPv6 payload is IPV6_MAXPLEN and
 	 * corresponding MSS is IPV6_MAXPLEN - tcp_header_size.
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78061EB1A1;
	Wed, 19 Feb 2025 08:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955297; cv=none; b=DzJ6m5RKdlmg/aadbhKacdY0ihNLgHVtUp9Ez4yGPgwCFBZSZDvTHjMMQ4yizbbJQH7wj2h2wYLEHLXGhvg7imIvnP/1g4/Tw4G9gbPss3WsYHlG4z78qZJ7z2Tp8CgcFf8XncO7w8QmgT8VKkiz34p/RJsQbojdxZ7EgQSy/lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955297; c=relaxed/simple;
	bh=a65jHU6hIwDAaV19bPKCnrh6bXB/jPtm88Mbo2qwpMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg7Dv+6bXaoHw4g00K9CGt3zB448MsUJ2a/kzH/biF01y9eBX9AoOFAk5ibsIxRmxtDQORnKzk5wxw4q/CySwG3frX5jZ1Dxk5tsIIvgOWv/G3NfwHUzJsOs56GwDAv6ed8QQd36eJ2mEpyUKgx8H2UaOslzlsB7xjO76jKbulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7pmUtOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7pmUtOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B12C4CED1;
	Wed, 19 Feb 2025 08:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955297;
	bh=a65jHU6hIwDAaV19bPKCnrh6bXB/jPtm88Mbo2qwpMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7pmUtORJHlVDfPGv+oo67BtkLAmxHtW2RJYNErJaCVaUctPIIM1AV192KvSXztq5
	 DKbj4230zfpQ5FY4zM0keV3McJPPVgzo6hCtcJ+gymBi6xDQhr2JIrYXixFtLdyPbW
	 zGgfaszb7jdeKblLK31v9hp4aMOjIbo60bS/BOXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/230] ipv6: use RCU protection in ip6_default_advmss()
Date: Wed, 19 Feb 2025 09:28:29 +0100
Message-ID: <20250219082609.209187035@linuxfoundation.org>
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
index 8ebfed5d63232..2736dea77575b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3196,13 +3196,18 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
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




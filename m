Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22DF17A2E8;
	Mon, 10 Mar 2025 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629724; cv=none; b=a/vkZOwm4+TlRZLf7kqbhHjvvGlR/QVv/b4c2wvy1Uq3PqOPgjgO89D99EkNwWevdK0bwLFCL31GkHzsQ3lSkRP89OOn9niUzulSkDSMV9GXOCG65KArupQ+lGCejTCGGW/BRZVE3AfoKIccedoQ+kEXMV2rkIdXlMmG9aNvqqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629724; c=relaxed/simple;
	bh=quL3eU30GturEgR8mp4HseT40csaM3+NZo12626fabc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IITG2AI7Z4Y/28vPXHJmy2gKv5T6Yws2svLsArrC1Vlr66wtvu+oNU8JOh1d9wnHa7FXkJk1hJp/JDHZJy7byFl1RK9Yd9NTkt4oYgxyCRpqheLVTX9/39yA2TS81rnjBfyMTUyo/tg1Cj4aQSamXD86Cv5m/J7dN2v66Kv/if4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhgRGeMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhgRGeMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39393C4CEE5;
	Mon, 10 Mar 2025 18:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629724;
	bh=quL3eU30GturEgR8mp4HseT40csaM3+NZo12626fabc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhgRGeMuF8AIdsMm7B1szG+rI2y7oW2ddk4voThTtlxpugGUxWK4z+Dq7L/jDNJ82
	 Gzp7jyAr7ZXz/yPNIodr7GnM3i+iA/Zle6URdUEOCSWC2EVS1ila0c+RGda3gPPQur
	 njh2NgJVBwxqsPZyXU7xvJexg1tP/0l2fWZs8T/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/620] net: add dev_net_rcu() helper
Date: Mon, 10 Mar 2025 18:04:00 +0100
Message-ID: <20250310170601.145276440@linuxfoundation.org>
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

[ Upstream commit 482ad2a4ace2740ca0ff1cbc8f3c7f862f3ab507 ]

dev->nd_net can change, readers should either
use rcu_read_lock() or RTNL.

We currently use a generic helper, dev_net() with
no debugging support. We probably have many hidden bugs.

Add dev_net_rcu() helper for callers using rcu_read_lock()
protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: dd205fcc33d9 ("ipv4: use RCU protection in rt_is_expired()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h   | 6 ++++++
 include/net/net_namespace.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 829ebde5d50d5..79b528c128c14 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2454,6 +2454,12 @@ struct net *dev_net(const struct net_device *dev)
 	return read_pnet(&dev->nd_net);
 }
 
+static inline
+struct net *dev_net_rcu(const struct net_device *dev)
+{
+	return read_pnet_rcu(&dev->nd_net);
+}
+
 static inline
 void dev_net_set(struct net_device *dev, struct net *net)
 {
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 0b6bea456fce6..ff9ecc76d622b 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -336,7 +336,7 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #endif
 }
 
-static inline struct net *read_pnet_rcu(possible_net_t *pnet)
+static inline struct net *read_pnet_rcu(const possible_net_t *pnet)
 {
 #ifdef CONFIG_NET_NS
 	return rcu_dereference(pnet->net);
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10F71C5F18;
	Wed, 19 Feb 2025 09:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955855; cv=none; b=DAJU/k2Q/3l97KqlBenMv7/oeioVJE/PoKJjOvGinuA9fLZvzavFckLNXZGSboe+vwQdH/qGq0IAyxg9y4kUGda+1wwlUuT6wDrzngmtzv1DPWgN9/yvhnJOnT5iHFx3SMgQ1XbrWEznMX015WUPYv9LlmHNhwGsEsAzwANLH4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955855; c=relaxed/simple;
	bh=bHyVomJ9kQ0kGGjviph2o5Vd0tzAP5d+TWDgFN9aZDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hynPs/ShgFjsr7qlynvG6eBPerqhV3Uk7iN5O5WEVl+L+6sMewMzVjYtgq5x90PGTSTmBFvpDOHC74uUzvpHtgcA0/7J5A+2GRA85PiW5paSMsdEBZDPM5w80k8VI/wkyRs/fjsXbLmVRInzRPqlwXWLyDknvSHaPav1NVCFSg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV8A+98W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV8A+98W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C3DC4CED1;
	Wed, 19 Feb 2025 09:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955854;
	bh=bHyVomJ9kQ0kGGjviph2o5Vd0tzAP5d+TWDgFN9aZDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV8A+98W1F81rfUKFpS9GV8lHsFVrgTp55GLNd0VAB82KyrV5xyDvvyNJnga0Jwpf
	 fBiBRiC4jJtLwVmuTC9FVodA9OAd2HobkXQ3OpYTeMfXeoycY1GdycVuCUmU+N8vl1
	 rrx9SoG+GPv4t4mtOnLEQ7SckHv6J9yzFyL7zez4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/152] ipv4: use RCU protection in inet_select_addr()
Date: Wed, 19 Feb 2025 09:28:37 +0100
Message-ID: <20250219082554.173310567@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 719817cd293e4fa389e1f69c396f3f816ed5aa41 ]

inet_select_addr() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: c4544c724322 ("[NETNS]: Process inet_select_addr inside a namespace.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 4822f68edbf08..c33b1ecc591e4 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1341,10 +1341,11 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 	__be32 addr = 0;
 	unsigned char localnet_scope = RT_SCOPE_HOST;
 	struct in_device *in_dev;
-	struct net *net = dev_net(dev);
+	struct net *net;
 	int master_idx;
 
 	rcu_read_lock();
+	net = dev_net_rcu(dev);
 	in_dev = __in_dev_get_rcu(dev);
 	if (!in_dev)
 		goto no_in_dev;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C712FF178;
	Wed, 28 Jan 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615981; cv=none; b=jvJJ3vgHBHUwuUQ6MbQPFd1ejm2nx1RGuKr9hIpSD6h0x7RzH5v6rosjhRsKd0HwsDSMqqYzXylGjyFF3ptxcSpN/dJJ1N9BUftSnK7J7jI/4U+RBDJLGZRBw6D4rSQJRzDFhoTizrGPClYDvrloleWo4QAO+T+3KvIDWmbn/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615981; c=relaxed/simple;
	bh=n7opsP60JZMctz6oZAlAbuOYyp3BcPLUttV0d7Rez2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE1cGD5AUqJHfTnYTJjRZEr8c2GuqqztIkT7+OeYAdCPC871z92d3D1xH57CA2MDgHqoLm2+njgYfBFn2ywiKYsy0yYPbybRtPBC8HJ4RFRqKaGrqXTjain7L+lxVp6Snb0akxoD3K4FpgueS8nqrtHUo3Bh4Ekni7avSkq/Yzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxiYOLfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxiYOLfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E2BC4CEF1;
	Wed, 28 Jan 2026 15:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615980;
	bh=n7opsP60JZMctz6oZAlAbuOYyp3BcPLUttV0d7Rez2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxiYOLfaVrWz5TessUVgdEWzqdrBo7Z12edsrD+/R9V9GjYo5VUwCh/bxQS31Hiaq
	 gHQ/mv+uMHCHhLXlW8eNCm/2Dcjxw7bPkanYvjjTOEcNODDh1GTRutW6C/W3LfNZah
	 ewEuZGCYgDdAoz/xz9Mv/TpI54Jgpr+9VpVwunTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/227] net: dsa: fix off-by-one in maximum bridge ID determination
Date: Wed, 28 Jan 2026 16:23:04 +0100
Message-ID: <20260128145349.461565587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit dfca045cd4d0ea07ff4198ba392be3e718acaddc ]

Prior to the blamed commit, the bridge_num range was from
0 to ds->max_num_bridges - 1. After the commit, it is from
1 to ds->max_num_bridges.

So this check:
	if (bridge_num >= max)
		return 0;
must be updated to:
	if (bridge_num > max)
		return 0;

in order to allow the last bridge_num value (==max) to be used.

This is easiest visible when a driver sets ds->max_num_bridges=1.
The observed behaviour is that even the first created bridge triggers
the netlink extack "Range of offloadable bridges exceeded" warning, and
is handled in software rather than being offloaded.

Fixes: 3f9bb0301d50 ("net: dsa: make dp->bridge_num one-based")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260120211039.3228999-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index ded9a291e6204..0505e90033f23 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -157,7 +157,7 @@ unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max)
 		bridge_num = find_next_zero_bit(&dsa_fwd_offloading_bridges,
 						DSA_MAX_NUM_OFFLOADING_BRIDGES,
 						1);
-		if (bridge_num >= max)
+		if (bridge_num > max)
 			return 0;
 
 		set_bit(bridge_num, &dsa_fwd_offloading_bridges);
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2DC14BF89;
	Tue, 11 Mar 2025 15:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707213; cv=none; b=efHNKWV7d43Puisy2SQWdme+WT4GbwMDcuQfTDC35U6I93JPXByaMvEgpcksWYUfNeuWPMc5EOyrwq8bwScXiD9/IV9wyaaBReyP6W9cMFxDqIlK6R5QW5tECgIePLtnLxXtnf3lvWsNfPMUJHADx1WIDcaWBSM1Y9ktprtzidE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707213; c=relaxed/simple;
	bh=aEaxXfCfvC92kbwWmTpaCRuWOmRoKf0b987/trALE6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGEg7SZUbYw5g5bqSNvSYjIafHueWD/PxHAFg1gwpAE4zXbcX/lg1sP/HN9X0g7xnpYevVI2qnUmB9ePTfXEgXvSXExzns4Dw4ygZiGQ4gN6cY0WovPHqJw8kzXMwdDxEexF62DvhLUIHO4uFH1HXw7HYH+zjI+47Qm62TeJFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHT1BFK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHT1BFK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CF6C4CEE9;
	Tue, 11 Mar 2025 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707213;
	bh=aEaxXfCfvC92kbwWmTpaCRuWOmRoKf0b987/trALE6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHT1BFK9gJXLpHg3LX87n15hIN+xzvU8pBzoFRfSU/L5PvAzzTA/9SIObtI6oJ2DX
	 MoVIQ8/kVH/A2rSvdAgwoUfZxI3MLcK5SOhNDtP2BoOSBFyOnge31QzO0XsD0Xqk8e
	 h0bBbIC36q2VXJlkPLWh+bUcvXYJYX16UrzPElmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 282/462] ipv4: use RCU protection in inet_select_addr()
Date: Tue, 11 Mar 2025 15:59:08 +0100
Message-ID: <20250311145809.512801039@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6918b3ced6713..2dc94109fc0ea 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1317,10 +1317,11 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
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




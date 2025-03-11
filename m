Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F275E25D8F9;
	Tue, 11 Mar 2025 15:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705982; cv=none; b=KRX8qVBzBT7cAS9yXdZqI/NSrrO6JH32LrlDePLkEknLRO3IHl5wQngJ7LFap0VkNV2krXXy0WjfMbZ1sz51QGfZCXmqcHjdUQgMzK1GIjjvTEEun2Pa2lG3X3lcK/cor8slr/wj1cwBGjqS8PmZcssBl09g1OG4QFZinrGLl3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705982; c=relaxed/simple;
	bh=Wc2Q3aAhXGziNnmluTG4SPz30b7gLplJZPL1d0ZxLYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4f0Jc/lpZL/iYIUxWpUun+vW8kj/EJxHqPfTQE+VbXVmSCGz8Oi8BgvaLxEtaYYsSKD+AvUfmJl89EECL545sYGMVIt6sZxtPrMSO8FyCBnvZ7OYkqKUcI3EClYcayOeXyGXvdEMjXQR40K6dwfPn49tChwaFLtG73NRRBCMbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwrJ199V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwrJ199V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ECFC4CEE9;
	Tue, 11 Mar 2025 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705981;
	bh=Wc2Q3aAhXGziNnmluTG4SPz30b7gLplJZPL1d0ZxLYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwrJ199VO6bUtg1QTK64DXv9abBnNDwRDY89jH/AhghRwRaOJG/HKK5TT1pF1ilHX
	 NZ4VIuyPlJY3eEwfE2DZ9IioZtkV57kiooO07NZniMHsHq1PNwGePEZxx/w+g0KRBH
	 zqkn3DfIf6NdMOFhvfoapmVh8oYunDl+uU6V5+v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/328] ipv4: use RCU protection in inet_select_addr()
Date: Tue, 11 Mar 2025 15:59:34 +0100
Message-ID: <20250311145723.017307719@linuxfoundation.org>
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
index 9910844c890ba..6855372d57a34 100644
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




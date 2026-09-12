Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2A0357CE9;
	Sat, 12 Sep 2026 15:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225807; cv=none; b=YGYE3I57TX3FcK7YkhNdkW/doosGXmgC2u92teMTPWxzKzsojrfb9i05mjLaj7iJEPhbjMWAzCP3DgzMFK0xDhohQIBc+IeFBgT/efj7D+4IDE0JZ2q9OkINoroyf35jvEcsvZ7pebLszd/PFAIpA5jQwGIx3eiigHGCqqXPPeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225807; c=relaxed/simple;
	bh=I7QnBQHrjGGs87rAZF2vnC4tNAEbMt0yyhRE9oPunUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDyd5GBHdxGqQH/HaCy3vuRh9+A0KkeXBsQq/w/erV6KTVqRCzrGzS952JC2CPNKpZYCHS+7cg/pkNJQKAfT9OrExwjwzofPePg9VILTELLzf6pbHCwW4ylQwre8Lh4Fvk5jVLn4HR61xN0sfeQPyZhn/GrM32gw+x1EosFXAXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYgYdNTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYgYdNTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7FE1F000FF;
	Sat, 12 Sep 2026 15:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225798;
	bh=mlp4ow4JXIywTVH4uUdpqoJDRpzQCRPtlIVhOIiNx0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYgYdNTZxsJ5QBjt/HbK0dutHc9yN1tFFyRIb97QIHMuJs/ux+zAvadBng75ZVlUf
	 ruNqpZOyHLhtaNhfBIciNQHzAiAMIV4Y9I0xRxF1409czNl1bjtMCQYT+6dsEYy9Ax
	 LN/3mXXWJtbk+TGRH7gJ/VGhRmotnXcws0WdF++s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Xie <xiexinet@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1269/1424] net: hsr: free learned nodes on device setup failure
Date: Sat, 12 Sep 2026 09:01:41 +0200
Message-ID: <20260912065635.697830488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Xie <xiexinet@gmail.com>

[ Upstream commit 7f16289b91eb316f170a6bd22d32e6c632f6a5b6 ]

hsr_dev_finalize() can fail after a lower-device RX handler has
already been registered (slave A is added before the failable slave B
and interlink adds). RX handlers run in softirq regardless of the
master's state, so frames received in that window can learn dynamic
nodes into node_db, and the error unwind never releases them.

Free both owned dynamic databases in the unwind, mirroring
hsr_dellink(). proxy_node_db is provably empty on every current error
exit (only interlink RX feeds it, and the interlink add is the last
failable step) and is freed for symmetry. The order is safe:
hsr_del_port() unregisters each RX handler with synchronize_net()
before hsr_del_nodes() runs, which removes remaining entries with
list_del_rcu() and defers their release with call_rcu() for readers
already under RCU.

Fixes: 81ba6afd6e64 ("net/hsr: Switch from dev_add_pack() to netdev_rx_handler_register()")
Signed-off-by: Xin Xie <xiexinet@gmail.com>
Link: https://patch.msgid.link/20260808110814.1637-1-xiexinet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index b0e4a9f32f7f3..def81cae14f21 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -738,6 +738,8 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	hsr_del_ports(hsr);
 err_add_master:
 	hsr_del_self_node(hsr);
+	hsr_del_nodes(&hsr->node_db);
+	hsr_del_nodes(&hsr->proxy_node_db);
 
 	if (unregister)
 		unregister_netdevice(hsr_dev);
-- 
2.53.0




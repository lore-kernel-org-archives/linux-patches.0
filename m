Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B393335F602;
	Sat, 12 Sep 2026 09:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204223; cv=none; b=XnS3ZZzjDuK/CejvDaX9LA3bBBc/OZnFonSqo+lxTAty2YksEpbVuRz3vqZ2qU58BMuWQ1G/WMi9pIph4HjUa8vBN9AO/xxhGveS7L5CekdZPiMq3o511aMZeGJwxrFafkj414nyecjUFyfoxGrkci19m0ju2hQmJGtuUy2trPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204223; c=relaxed/simple;
	bh=kEVIF9L3UvBMHhS75kR7f3jBWDjRkzX6qJxP/QVw2UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBMJReS3NAF+kENPMplsjY+pdDVS3BJ9Bf7PwjzZqzoCQXEJHGLnms8JXz3vBdNxn4arAVm4lAZm2LxTx5q1g/qDINPNqeWxW43pNA8Ejw5q8gdPMpzQxfFlybVHgx9H8y4gqbDqbNRM3xJPpDv08vCsPkvEZhlTdn43PULwOXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8BsBL5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8BsBL5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548631F000FF;
	Sat, 12 Sep 2026 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204222;
	bh=Xokn7P83LN0LhYFw7pxYucdXDTph3a0+U4QYL6P6IqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8BsBL5zQdeclh5+dtoRU8Gns5NEzqGdiRp8oHYbfrhtnotLAVgZzZCIxAZr0vh6A
	 S6wZM31W9NsRVaDwXl0qs71qaljnYUusa9Q04KhojM2GGL1c20sYcQMiQJDyp7geT7
	 udd+CYsRolqkhteYoECp+TejPG4seGulkr89QcQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Xie <xiexinet@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1569/1815] net: hsr: free learned nodes on device setup failure
Date: Sat, 12 Sep 2026 08:55:19 +0200
Message-ID: <20260912065725.827561734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5555b71ab19b5..9c3078dd38c2c 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -820,6 +820,8 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	hsr_del_ports(hsr);
 err_add_master:
 	hsr_del_self_node(hsr);
+	hsr_del_nodes(&hsr->node_db);
+	hsr_del_nodes(&hsr->proxy_node_db);
 
 	if (unregister)
 		unregister_netdevice(hsr_dev);
-- 
2.53.0




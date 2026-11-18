Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047923;
	b=C2E4NVYTorbAAEvYzHMk1UCZ4nwC+DMnqqfYLIOVRarewYOvIXdCCXgvu1sraxsakn2s
	 pWU9H6CHR+HJfYa+36FSNavHxunE8grVfGiO/U9Hwvzd5Ro/Eb8WdYp3OE8L+67ZHCcxO
	 1VB50HLSSDJOew0OX3wqVBUm2sWtiWAQI3TUULnUNxZ7s+pyMWTppzk9QsHcW/u9dNhFC
	 RmEs5XEqd0vGNH9Y1XOj/pbP4XAq59rlBnJKa58hompDI4BVmCJ/J92D6E29DwIkvLPNv
	 qqJR3vHm+5bLxp9UfkYktuw721GWO7fmcCGA+FM1dS5CfYm4VGtk1yHfVY6Kfg3l5BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lDD4PjsLAL+vP4qoGys1s2g96fgEYU5Lp3kDYhDko5k=;
	b=ZgJIS9UjjdUk5bw9dbWMCH8wgxvr+ihb2eke1w5m6wHDkE50qdQHkdiP6806ocW15Zkm
	 1MKQmLQnAbm7O2Sc4OgDPP2djg5/NFvy+NLWhQYiMPUuoXK8dMdkv+KJb08WcQ7xFpr9+
	 tjFdKDCAmUSjkvZ52rgAwzmqPV/fqCcXK6db1UrTHF55Q/xxs1PiSnBhxSuT2vi1fepaZ
	 FL5mqqlfXK8uZBxahYujT57XLrZ1JumkskpZ4K4U9AWGmy02Jq3dmUrctRgp5QUbu+gGj
	 wXJ8bz9yPnhLZZn2bSNm33iec5KwkGO3ogCftAZYN6X2BG1DRIZFm1BStbPI4Z1a0EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjBEV1uU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B74D606A325;
	Thu, 19 Nov 2026 00:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjBEV1uU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD651F000C6;
	Thu, 19 Nov 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047922;
	bh=lDD4PjsLAL+vP4qoGys1s2g96fgEYU5Lp3kDYhDko5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjBEV1uUBl+r+2evf6ejkO61kXMXibWPZJlW1VFnUGcSyildcaY9OZKg4+R6qK2/A
	 03qTooui+RDPzWwOzFs+7+2yoMP/2asRORHCEpiZZAGsqpIHMY/s2wq9s5z6g/qeNg
	 d01AZOcjFAfzYaDU01i9ciOb0KIKEKDAJsyxfEaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1809/2857] drivers/base/node: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:47:23 +0100
Message-ID: <20261118150306.384348709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 6d7e9bc51d8f2d73b3403c759c769f880082f9ae ]

node_init_node_access() frees the access node with kfree() if
device_register() fails. After device_register() the embedded device is
initialized and must be released with put_device() so that
node_access_release() can free it.

Fixes: 08d9dbe72b1f ("node: Link memory nodes to their compute nodes")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260907024732.1452228-1-gonglinkai@kylinos.cn
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/node.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 6153dbd5be903..9fb3803625a48 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -145,20 +145,19 @@ static struct node_access_nodes *node_init_node_access(struct node *node,
 	dev->parent = &node->dev;
 	dev->release = node_access_release;
 	dev->groups = node_access_node_groups;
-	if (dev_set_name(dev, "access%u", access))
-		goto free;
+	if (dev_set_name(dev, "access%u", access)) {
+		kfree(access_node);
+		return NULL;
+	}
 
-	if (device_register(dev))
-		goto free_name;
+	if (device_register(dev)) {
+		put_device(dev);
+		return NULL;
+	}
 
 	pm_runtime_no_callbacks(dev);
 	list_add_tail(&access_node->list_node, &node->access_list);
 	return access_node;
-free_name:
-	kfree_const(dev->kobj.name);
-free:
-	kfree(access_node);
-	return NULL;
 }
 
 #ifdef CONFIG_HMEM_REPORTING
-- 
2.53.0




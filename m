Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060371;
	b=TNbAd2AXG9rb8lUDcU4Txuu/P/k8R0Wu3Z9W2J1SESTUHNgiWtLgGmZYO70aQgFyvRcO
	 eXJ4Pi9vQZgepQtSylPDIFVHh+LhyVL6KEnBnjZ4ftlbkFsxahOXsEm/e/TG+obB/kSk/
	 tQu/Z7CJehRwXzODkspLzzjaDFMQ+0ImYqfwLS7syefT3ebUsLBPf05bMwMi8DKcVXDJR
	 sebotLVnlBuVY3+KkJYcm14MKcVvq9Xlpj1cwK4fHgU56RPqhafk+9UIGWtlhta/ny/tk
	 FT0+nDMVLaKhy0OrNLh/GPs5TodEdZs7KAPut+GLw5TPpZoB+WtWzd5cm+h4scIwEWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h13Ea40NhI/omVnHWCARGg6eS0MK07ibw8IcElyBuTg=;
	b=rqe6hE5XnL3qi8m6A3HHej8nTkl/50IhNV3KPXBfyOHIwAm9p4PUJJ8ass7/VUmFZ3M4
	 NEy9Rdv1Y7zMmoL5jiuKFPbgM/NXYFiocyJbU5DhMTlPoxZ9FvD7I7zGNwwSO/VJBm/LT
	 rMQGsc37GIGv+7ysq4dEZIX9/PiAPeYfZgmrqhBqx2aq0PCQ4Rw2wGqAStemnmCxtP55w
	 D/j8UmCwGiW9VGkuijNE+NfoWxqryBjnVruyFTGNpgkJw6DymxSpQ2dBcldQy7/ok6U3X
	 we/9jDpsdwqI2xWMiudcKhHn32gyR4VZwsR7shr0GYGM6yBIJ78AcIkQVdlSII5GboA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ik2+F7qr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B859606A326;
	Thu, 19 Nov 2026 03:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ik2+F7qr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E521F000C6;
	Thu, 19 Nov 2026 03:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060371;
	bh=h13Ea40NhI/omVnHWCARGg6eS0MK07ibw8IcElyBuTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ik2+F7qrbZ44SkFJnFOzbABAHC8eP8ZtAqEhWz33h1w/1Dt76x8rZNwMh8toPZM59
	 lkkVt7jOxRl+cotCXpgEgGEnId2DoR7lPua5rzqR9vVYAZPNS08ur5xDvpP7oh1P3Y
	 KOnGcqMmmoNSb/05pdaZdaGloZVQlXYbuN9kRrdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1175/1848] drivers/base/node: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:53:33 +0100
Message-ID: <20261118150008.787217493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f34ae036485e0..fcde5b27be065 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -140,20 +140,19 @@ static struct node_access_nodes *node_init_node_access(struct node *node,
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039343;
	b=Ozlyq7xMuwHoiL0h7U1vCCCI8wiikxVhBWzSirYZyUBrMkC4n0PKX0IoWyFxFZN0cyDx
	 8tdyGuVJJxaXrqhwQjcAVYPbndihD5B2Vzj2MEAgojRubO+xzrcVOtuFUyNbV3zi9v3mx
	 I7tKI8GKeIGB/VyiqpXKd6ybknBptu/JDzOpy9Q98CVJt8E9nRDZrlo5Gh2aMzgBcvMyX
	 fgW6l38iT4hgfSxhIzjy4oYPYd2Q7PXCN3nHz3JO/gV8lEro9X1QHbj0PxKdviTxAy/32
	 MjzdcZ5VJgZhKSeuO2dc6inVpnymEs1esBmCypf7Joo2kYm0U/p79kXYrz/Gf6dk6/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1JEldoqDNu8YB4yDNvZ3P+mTjigEstkiipk5ItRrVQ=;
	b=Kmg7UdC+pu6FIyo/16u1mSHd4T1CVN7MMSk89V3Qb9yBZzWwTvyCamdHhv/0bYHbONp6
	 iW+loWLKAT4ogjLU/L17nsWEfHMJ/LviRnPNoL1AcnMwsHDGgzrperQyT5hYrgaqKUibN
	 3Rj432CgZp3TzllEC5XLgCj0zSjUGpie7mLYhgR1rP+TFIqQikQs83JHPSUG9m/2dbL/m
	 ZHC35APqZJSF1+J1XnYFcctvTew/GBX6bO4WZT9skWfv327Rf2KM+2uud6iIKU1zfB6sU
	 WWTHWG4e08o69Z0PK122Kqp11+gZLx2puXYd5aobKtt/S9j8QssyUUwwH8Efh0XWTzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcLoXRAg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C4860A2601;
	Wed, 18 Nov 2026 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcLoXRAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475B71F000CD;
	Wed, 18 Nov 2026 22:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039342;
	bh=B1JEldoqDNu8YB4yDNvZ3P+mTjigEstkiipk5ItRrVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcLoXRAg5D3Un9abYA1/Wi5y5JSUHflpreJHruUveAzRWyKtXPiuhIHj3L29nr+ju
	 Tas0GEfLjZCGQu7I5DzXmkJODE6dQu1nHmmhlc90S9lRNuna4o4AXa9/iRXZqXBkFf
	 ztplPDe+Wo5/qfBA6luc+Z4yt/Q8gG4sYYglGqjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2067/3318] drivers/base/node: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:44:49 +0100
Message-ID: <20261118150424.088211073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2b398c8a0f06c..b345390a46bf1 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -144,20 +144,19 @@ static struct node_access_nodes *node_init_node_access(struct node *node,
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015670;
	b=IPG27dlVL1j/5dLxbkbbfX9R9bO64n+I9WTJM/jzREYHhHofNh+9yLf4+Nr0QZf25vh0
	 EZFTemNhrvU4NdIP3bY0RqEKpCGLAcwdPFjppF3+9mpy8iRZZUxm4Q8R0GVQ5SDy0U0s0
	 GX/2fsFHRpi57VhCEx+YV7Seg1f4h8qRjOuPMW23tQvWRgrfRa/0UpaLj2jUTt2fC1ckx
	 zN5EIMx/o2Luy/UDZcVU6shPoJmjrr7GILrGIIKboOhwLnvEzJy9MqRWUOz7ADt3j6Pbg
	 SZsDRro8D4Oq++kLPCGCULrl8eZ45tTZw7xJy86sKgZuwac0l29kqGlRBWBpr574RaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+MhBJpF6rvJczHB65EWp22RMS4VH6s2Dj6RAamPOU0=;
	b=rXXrYZooBYUsqLDcjqylD4WdpBRlWQkaY6Jjl3OoM8/qxzLqUooRRTQUITd2xkP3pcHg
	 Ddl+jEhHbQMBnxJ7RNEbjW3jCUFhxzztG4/h2s7W6+r96RGkQgpMvHn9tJRilyDVHlbWI
	 UxDbJjSoL84sc1Hngbc64M/9U0IYPf1NYoAY0AktQPUgJmT0+iDH+NuzFTdweRUK86jjk
	 aoutVIem8QqQmyEhgwe5UovRJU16h7+RbSErfko8hqhDW/isp5hugmvAzQ1d3XWGQaAbJ
	 Y/sQnmQ9zjFOt0mz3AyDCGQJv2Nvw3a3qmfQmZ02mB1aKNi3rRiFLTUGkg+b+nOUPag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eS+nsSWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D46E606A338;
	Wed, 18 Nov 2026 15:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eS+nsSWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997AB1F000C5;
	Wed, 18 Nov 2026 15:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015670;
	bh=Q+MhBJpF6rvJczHB65EWp22RMS4VH6s2Dj6RAamPOU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eS+nsSWquua55TYJhILdkGXRsidWhZU5MhYxeHkdJmfjINrp/TcW+txTEXEbCDWrF
	 ptMFJryA4EBPTRDHDrJywBQ2usItUgD/JK2vTAqh1BO5n6+u4RAbfU3Aa3rEnK3qFU
	 BdpHDTS1H3Rw3WLW9C93g1jKomczA+FsmCBijcDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0257/2651] drivers/base/node: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:24:57 +0100
Message-ID: <20261118150257.115523868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3da91929ad4e3..dcdc8626627a8 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -167,20 +167,19 @@ static struct node_access_nodes *node_init_node_access(struct node *node,
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




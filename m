Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054782;
	b=WPTMVqxr7sq0Jg42EceVTwIrX4O8CT1/nbQrIIsQ8mnooBfSBET4Y2pWYOo9O5P+nit0
	 XUKf388D3TNVkKYvQb/PBbH1QNVGhh96Zp//uA7WhDVeegj2mEe55eh6z35LX2I3jQ8CZ
	 lxqds3CKl9itjLu8sFmGG3i1bPJgqXkIfxAH3oa8zWGlqTYNBxuSK1d4y6KkoSY1BiEmN
	 +fWHOgn7U4+e7Jok3dpen9jxcukEOasvBAitR5cKN/DsYjSm72elUsqBh4pDtQ1HynAFi
	 2vpNHX0sfuQ0GG7x3YI70PCiN0iA8BMpv1FD9JTtejkNNW21Q+4Hf/eeEQisjgBv+kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7r5gwpK9E9qaq93iBA0jTUmGvzgzLGWrH8M90h4GETI=;
	b=s6fXGT1Fz68uyZ8SllC4C90WHdZWSfuOw18PYq06H36DkWptqv0gi6KVrEUf4uBw43QR
	 O/E8GF0kjclprY8mHJsbBfbSi+Hfm771H32M3pOst/KwJRVdYfAp1rv+x4NhiUSFtMI6Z
	 iAQAmgX7mNb4Ql1Fuz8ZzSCKsYYjILAdYyb73dlEhxD06ULlJPC1FoaQUQAbVeIkVKa60
	 9qjTupXwt+3N7YdEIZbAOrkRvWFSjFZC0Krg79V/sT3i1iC1Fy8qxLTOhiVQQOQJtcoKz
	 g7maOTgW0xGxig8OMHl6LRCW8vePQEKqYJTW/SgehX56I2FvX6ZxwTThwHl+0z34PBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nloeNS2h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F090F606A31C;
	Thu, 19 Nov 2026 02:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nloeNS2h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F081F000C4;
	Thu, 19 Nov 2026 02:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054781;
	bh=7r5gwpK9E9qaq93iBA0jTUmGvzgzLGWrH8M90h4GETI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nloeNS2hz0V4DLkjFvukSFVhsTVC0j+/xsJrxvNMDStj8p7f246XzTPuAvoXw2VW6
	 bbj3adRWyWq+hUynwQpXhbxom4KLT23uLtSUj15CLviX5yv6he4ipSzMFEdqRjcYv7
	 qAU6BGXCDII8uQxk45vubT5sDpdEr5s1ie1aJDw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1397/2214] drivers/base/node: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:51:13 +0100
Message-ID: <20261118150107.176932893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd8c8fdfd158a..848a9882e31f6 100644
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




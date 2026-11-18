Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029162;
	b=c17kxYktSorH79D0o5Kld1HPRUWNomaund6X/zuj/IG9/tvlS/TXaRwTkfWlFHhg835k
	 7JkaLxNZmdlTfRPvQXtDRdJ7xphiY2GXRjkEaNyPowwBTdKUeAjEGTZqjHEn1TXQ6ZL8H
	 KwBteN7Vr6OKpsV8uFY6gUaTIL8Fy1860QdZVm9UD0lQ/Pk144tU8uEol52NMPTAEhu6m
	 b9bsFHlnnjjcZpShBrdP/Eljx+zR2aZivKwYSH/uIlqccorqkskO7CE7OVFovMLmadWpH
	 lGKwNFDfvGu2eKom2MZRCUtRUDy5zDXyRelOqlzFPYPOeQfaK2Ma0Yq6J8XSFM37k2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9CTGoV6yOOmke+qpcyzxbBUWcqgyYZDjXDMi/amGBQg=;
	b=jmhmSAuJd3T1xsPscGn2C1Kx4nVXpxhpbA8W14HVrMxHQvznN5LstcOXISL9T1/shY06
	 +3pDAVEuknQuHDNlYhcO2g5HuwmqMmI2aG+956vWZJro0Nk75k6jUczj3QXF/ms1xIr2v
	 o6yTk21zuTLiXa3hRMzQZ71JJy/qBmhoPC0GICzJnXLvUcG4cwlvvFNHtABxyT5RH5VLy
	 6Brcf07wXhB7OI4bzScTVVVB+CcHZs2GkGCQnGTvYvAZzJ4W+JGQkTbmf1X/RjLv6bUa4
	 XELvDewUVZq+s1zT5YdOnwI4xyd715XxuFkSrHLCl4K3p0CC1VZBpWA3nN/VZSOxCeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/UqEDft";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F3C606A320;
	Wed, 18 Nov 2026 19:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/UqEDft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58171F000C4;
	Wed, 18 Nov 2026 19:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029162;
	bh=9CTGoV6yOOmke+qpcyzxbBUWcqgyYZDjXDMi/amGBQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/UqEDftxlKHAF5KJL96/ZNnikkRnh6pcBsU9+z8SUPneEyAHWlHFVSPfsP/nv4qN
	 YK0xAG1jLqH4DSJrXEcWmBXTF9dxEcDkVhD+kd7ME00bO66bF1d3KhX1+KOobw7Bke
	 8pY0s/5t1mIrETaAVJDdGESJlhohDxbVVaNAlJdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0251/1756] drivers/base/node: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:39:38 +0100
Message-ID: <20261118150018.377986914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index deccfe68214ec..091e397b72b47 100644
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




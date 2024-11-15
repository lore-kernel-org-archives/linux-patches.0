Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C59914EC77;
	Fri, 15 Nov 2024 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653630; cv=none; b=pAFcsQ4nwvY/4CnlDKKQv+K5F4hkXO7EQum8dmt/b83xpC6noDwOyOD0ymQOUzbK0lxv0OVW79QLnMm7ABlm/4yMNMZlXgiRZoGzS4lbfXWW/bglj7C44pJuHlcGMLmCGC3/hBS16Q4cODVWjzDgXdrJi3+njbXmy9nBrVYmHqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653630; c=relaxed/simple;
	bh=LPZOBUIavDapwelH2J0VHr4iRztmHJoR3dFy3t6xjrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+vh2nFbEjIVEnh9NlX5kZy/ZP0yuD16CQ7wrvm0Fpgxozuce2YzjY8YlXDYGR6FQLycjkYoSAtA9p/gCMMY5KZlD/S4LMN2n1osz4axfCNHvYWi0Syqa8B1Cmssdp8laUvjvsKy8iGcHkqr5QT9vnTpnyVpqGnpEiuAUXkHd2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIpjbvdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIpjbvdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE262C4CED7;
	Fri, 15 Nov 2024 06:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653630;
	bh=LPZOBUIavDapwelH2J0VHr4iRztmHJoR3dFy3t6xjrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIpjbvdZnbPm7lwEFJBtXN0XrKUEGt46f7R4BlJEtqO/aLxxxg2MDqOyWjHjgUJKb
	 HXM8qYJeTmFq85hByRy6Acp45KeshPUDjm39UEMvVJcS0thPnWE6nwVeClE9ww5Jf/
	 JzWn+ZpsLb6icgtWrrKaSJn3GgiQSTiPUNHo599w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pedro.falcato@gmail.com>,
	syzbot+3c5d43e97993e1fa612b@syzkaller.appspotmail.com,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/39] 9p: Avoid creating multiple slab caches with the same name
Date: Fri, 15 Nov 2024 07:38:16 +0100
Message-ID: <20241115063722.839131990@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Falcato <pedro.falcato@gmail.com>

[ Upstream commit 79efebae4afc2221fa814c3cae001bede66ab259 ]

In the spirit of [1], avoid creating multiple slab caches with the same
name. Instead, add the dev_name into the mix.

[1]: https://lore.kernel.org/all/20240807090746.2146479-1-pedro.falcato@gmail.com/

Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reported-by: syzbot+3c5d43e97993e1fa612b@syzkaller.appspotmail.com
Message-ID: <20240807094725.2193423-1-pedro.falcato@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 0fc2d706d9c23..18db0e23e2f15 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -969,6 +969,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	int err;
 	struct p9_client *clnt;
 	char *client_id;
+	char *cache_name;
 
 	err = 0;
 	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
@@ -1026,15 +1027,22 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (err)
 		goto close_trans;
 
+	cache_name = kasprintf(GFP_KERNEL, "9p-fcall-cache-%s", dev_name);
+	if (!cache_name) {
+		err = -ENOMEM;
+		goto close_trans;
+	}
+
 	/* P9_HDRSZ + 4 is the smallest packet header we can have that is
 	 * followed by data accessed from userspace by read
 	 */
 	clnt->fcall_cache =
-		kmem_cache_create_usercopy("9p-fcall-cache", clnt->msize,
+		kmem_cache_create_usercopy(cache_name, clnt->msize,
 					   0, 0, P9_HDRSZ + 4,
 					   clnt->msize - (P9_HDRSZ + 4),
 					   NULL);
 
+	kfree(cache_name);
 	return clnt;
 
 close_trans:
-- 
2.43.0




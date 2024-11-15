Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62786188CDB;
	Fri, 15 Nov 2024 06:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652889; cv=none; b=YD3yLErnY62tA2tMM9McAhvHhp+9zJL0NtTYvOSOcupXVhXZxFeid0gUb8ArBSSRTCY1fFv2w2VXULodHcMsOAHKdiXkfBpNOVJZLqLDZAwxw6SyHRnSLUAfD3grWFuu/Hz8kwNH3PzRba56KVkPTTy47PMpP8zNtlJ+0UNDz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652889; c=relaxed/simple;
	bh=5Ry0NAk641BdLBXEaogiDkBHWnFAZ7cJ+S0SFNDWDN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGDaxe+jrjleDhKZAZbUEFu7PJFgI1eqUgjbn6fYi3RBO7+VopcPx3UZ3UzOrt7vG1KRkzA2ZCCXSUV70bjsm+6CDYCRs23R0MmgcALlmfEfG18QXa/arqA5QMNVJdl3Z4Csee2UGn5oR/TLuy7nxFIUgkwbMtjaQ2kQPt4KLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pfbhnk0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pfbhnk0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EC7C4CED0;
	Fri, 15 Nov 2024 06:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652888;
	bh=5Ry0NAk641BdLBXEaogiDkBHWnFAZ7cJ+S0SFNDWDN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pfbhnk0SViik5w84f/SIcy4ENxns8zG38ctEwQj/3RMKGktIz5jyIGPgWR1LTdLUn
	 sQlmTXCYe6+1ibT0aEacyutzgvhA4Fys5Y9bZSph2MurCx6BU0ocF8k1qmu14Dm/CW
	 N1RqYbknsvMP2zEuYWO1BW2ufTE4mbzaYE2Kd6vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Falcato <pedro.falcato@gmail.com>,
	syzbot+3c5d43e97993e1fa612b@syzkaller.appspotmail.com,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/52] 9p: Avoid creating multiple slab caches with the same name
Date: Fri, 15 Nov 2024 07:37:58 +0100
Message-ID: <20241115063724.479847527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a7518e8e76265..e6eee4eecf24b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1018,6 +1018,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	int err;
 	struct p9_client *clnt;
 	char *client_id;
+	char *cache_name;
 
 	err = 0;
 	clnt = kmalloc(sizeof(struct p9_client), GFP_KERNEL);
@@ -1070,15 +1071,22 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EB435F602;
	Sat, 12 Sep 2026 09:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204174; cv=none; b=civHDkT/TJzQV2Puuc9e48045eqk2IZNJkmlSBlvnJUu1g7hTMlJ/bdtjQS/TsG+8qIqIMVSvbnlq0VQp+56qtF+YLugJG0tFm276chaHFqKkbmUZfg2sQQ4afPrOWExZVrZLFJnQMJJM45KM5aM2R2BI9yee7YJcxc1deo0dSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204174; c=relaxed/simple;
	bh=5DsOHqpVU345OoSd1tLkAEXru3YXTUOvf/yLwZh8AbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovNx7U1ol5xCE6rgj4TnOyVB+Hqk+sZGNySOi1+wSDQzQGug/pFAI2tQ1twb+Kc7WMxMPI10TumpJ6yqIYFRPXMurqGEmnxkRQOvEOl4HRJaXXJGl3q3Hij7w6xz7Qjb/q40g2oc29v8mC1sryURNvkZGPc9yme43t2xm7X+2YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ar+pwVsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ar+pwVsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BDA1F000FF;
	Sat, 12 Sep 2026 09:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204172;
	bh=tkHJuT7cU4p1z71qYeJkVvW/BRdu9bHHctpaI1fbXAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ar+pwVsAC2Jg86lB6RjXoOh228C2b9+47cR9d1pWpOcvnyGEBspBvfRumxri/rYuJ
	 sWtUbqsZp2GxZ2zf35Y3YLMJ4JnznDCED923c2C13BiwBrnDT/8R3uqpHqMwcodAv+
	 ZZYwSO9+8TjV4sf5KZsURf4YpTl07kS4cHLl0E4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1515/1815] smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()
Date: Sat, 12 Sep 2026 08:54:25 +0200
Message-ID: <20260912065724.566655908@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit d2ccf905f47d2344270749f4dfa905afcd3edeb0 ]

See the procedure below:

  ksmbd_tree_conn_connect
    ksmbd_share_config_get
      share->name = kstrdup() // fail
      if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) // false
      // do not check `share->name`
    ksmbd_ipc_tree_connect_request
      strlen(share->name) // null-ptr-deref

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index 6f97f8d39657c..b4f56e7338659 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -158,6 +158,11 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 	atomic_set(&share->refcount, 1);
 	INIT_LIST_HEAD(&share->veto_list);
 	share->name = kstrdup(name, KSMBD_DEFAULT_GFP);
+	if (!share->name) {
+		kill_share(share);
+		share = NULL;
+		goto out;
+	}
 
 	if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
 		int path_len = PATH_MAX;
@@ -203,7 +208,7 @@ static struct ksmbd_share_config *share_config_request(struct ksmbd_work *work,
 				share->path = NULL;
 			}
 		}
-		if (ret || !share->name) {
+		if (ret) {
 			kill_share(share);
 			share = NULL;
 			goto out;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD1C1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC27BC433D2;
	Wed, 28 Dec 2022 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244503;
	bh=GtikZnRZ4OaT2m0mUo8jo9s7mJwxMQk3RZknu1q13mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYgcrDZkolcKrYofZ7Vb2vsFdt/BSyqnEYmJgMbf/0Ag1AZo/b9gXKYZdBguwJhoc
	 HLd9Z7Ud0alEgMwnRoRiqLc5YFdiz+yRye0Y6BQsqx+PiB/DjAW2tEbeWqvpnxG5Fu
	 sqcMEJSuk6m/p713H/mhDYz46i1rekfu7I3b/p2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0723/1073] ksmbd: Fix resource leak in ksmbd_session_rpc_open()
Date: Wed, 28 Dec 2022 15:38:31 +0100
Message-Id: <20221228144347.663307005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit bc044414fa0326a4e5c3c509c00b1fcaf621b5f4 ]

When ksmbd_rpc_open() fails then it must call ksmbd_rpc_id_free() to
undo the result of ksmbd_ipc_id_alloc().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/mgmt/user_session.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 3fa2139a0b30..92b1603b5abe 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -108,15 +108,17 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 	entry->method = method;
 	entry->id = ksmbd_ipc_id_alloc();
 	if (entry->id < 0)
-		goto error;
+		goto free_entry;
 
 	resp = ksmbd_rpc_open(sess, entry->id);
 	if (!resp)
-		goto error;
+		goto free_id;
 
 	kvfree(resp);
 	return entry->id;
-error:
+free_id:
+	ksmbd_rpc_id_free(entry->id);
+free_entry:
 	list_del(&entry->list);
 	kfree(entry);
 	return -EINVAL;
-- 
2.35.1




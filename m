Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580201EE02B;
	Tue, 12 Nov 2024 10:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407751; cv=none; b=p9Ax9ca33WjuEC7iiN69zMmq0B/UEGh57iqmU9x3S9dzqClF0w4cCiIQegEeEVHFPn83bvkID9knQj4DJCs44ZZuedMzpGpnMCbqGvc4Dn2WN5f7tnTEZfNgTCPiLZ7cwq4Enz2YHzsY/Z1I/wtmR4fEoJIuqQbBiA13LB7H1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407751; c=relaxed/simple;
	bh=UDyt7Z4650mLmUC6OWx3uWcA5b12r1dSLFp61ZX+ojE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHBQg4/4kiwekKZhsVxHc9QdEbjSFvbLGWVV6SJu7KjCkCsvgY0b0Ef0Plx62Ab0k02Rz1iOw+UWKiiTG7ZLTmeQjXbU8onidMABS5GNvhZUmRjvwRupsnzGOpsQjLUxJKvfmRSbzWDnw29/vlsJPqTN/Nuym/jxJLsuDrez2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKUATsKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKUATsKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4478C4CED4;
	Tue, 12 Nov 2024 10:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407751;
	bh=UDyt7Z4650mLmUC6OWx3uWcA5b12r1dSLFp61ZX+ojE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKUATsKEU1NEP6B1bUthJ7G7xoEegibR268otPTQYpk/pW+0/tB0d8jSFpEWA3W0c
	 y6SB3gpd5TCjeTOewtd5rnSEU+m0F/dgfKTNW3bw0V+4a8l3n1lH3ZYEOZPwyPq7+Y
	 r6D3kUXtxryQtN47XVZXB+3ynir7nQO2UqsmK5fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 072/119] ksmbd: Fix the missing xa_store error check
Date: Tue, 12 Nov 2024 11:21:20 +0100
Message-ID: <20241112101851.466329463@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 3abab905b14f4ba756d413f37f1fb02b708eee93 upstream.

xa_store() can fail, it return xa_err(-EINVAL) if the entry cannot
be stored in an XArray, or xa_err(-ENOMEM) if memory allocation failed,
so check error for xa_store() to fix it.

Cc: stable@vger.kernel.org
Fixes: b685757c7b08 ("ksmbd: Implements sess->rpc_handle_list as xarray")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -90,7 +90,7 @@ static int __rpc_method(char *rpc_name)
 
 int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 {
-	struct ksmbd_session_rpc *entry;
+	struct ksmbd_session_rpc *entry, *old;
 	struct ksmbd_rpc_command *resp;
 	int method;
 
@@ -106,16 +106,19 @@ int ksmbd_session_rpc_open(struct ksmbd_
 	entry->id = ksmbd_ipc_id_alloc();
 	if (entry->id < 0)
 		goto free_entry;
-	xa_store(&sess->rpc_handle_list, entry->id, entry, GFP_KERNEL);
+	old = xa_store(&sess->rpc_handle_list, entry->id, entry, GFP_KERNEL);
+	if (xa_is_err(old))
+		goto free_id;
 
 	resp = ksmbd_rpc_open(sess, entry->id);
 	if (!resp)
-		goto free_id;
+		goto erase_xa;
 
 	kvfree(resp);
 	return entry->id;
-free_id:
+erase_xa:
 	xa_erase(&sess->rpc_handle_list, entry->id);
+free_id:
 	ksmbd_rpc_id_free(entry->id);
 free_entry:
 	kfree(entry);



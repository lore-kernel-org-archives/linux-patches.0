Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A008C3F1AB8;
	Wed, 20 May 2026 17:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299128; cv=none; b=CZ29rrhPoa9wfN7Iks3t43Ie6qfHhZq2BDYj0lLEpDwrQLqs1G1vXmJrknu02XiU8tvcynkwYbGONXGxwTbxyBIFR2cXimGgMcHEPYhBJdf3nNXA+JyCPG5KQLEeQBfFngRplI3SFbTQDVbrgSyVEK2nSSX7+OsHrWGPgDs32pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299128; c=relaxed/simple;
	bh=UHDDRYk0nmnpJuE3LvDwB6Ep9bvcN3w0Vbll6FRYgzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCrHBUr0A9PGUL0T1OyW1vQ5FkZh0faxAtCJVNW864ZZb6YaHMDc6IarsKb6jGYyJ0VeVn9TXVPLGJ5ZIdJ+5rebH2VHadkD8U6Y+ppzHZezxrwPVDDRXz5xJ0dYaSo8AG88DUiG+sVSTT7E8FXuAsxVLDoQ1lQp8Z+zWK9+Lwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wqz3/pZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqz3/pZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112501F000E9;
	Wed, 20 May 2026 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299127;
	bh=Bc3Ixdcehf51fEq3PHBwgju+bRkaEoA08uSEwwe78BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wqz3/pZUTnn+K7l2nYW/MM+3cF92/fCZOl2ARoP5d1e/n5AYPouKnfDvPUJw9Glor
	 onblI3X5z6s9OSHQzuiQQ6MOhEDIfrAx0eMm+31WbbBkuRVABZOYOKgJCWF/SRY59M
	 o/zVS1xIJpqTzhJmA+C2u/h2ZKzrGxUvEOwPXZ/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 674/957] ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
Date: Wed, 20 May 2026 18:19:17 +0200
Message-ID: <20260520162149.154584877@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit c049ee14eb4343b69b6f7755563f961f5e153423 ]

When per-session tree_conn_ida was converted from a dynamically
allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
removed from ksmbd_session_destroy() but no matching ida_destroy()
was added.  The session is therefore freed with the IDA's backing
xarray still intact.

The kernel IDA API expects ida_init() and ida_destroy() to be paired
over an object's lifetime, so add the missing cleanup before the
enclosing session is freed.

Also move ida_init() to right after the session is allocated so that
it is always paired with the destroy call even on the early error
paths of __session_create() (ksmbd_init_file_table() or
__init_smb2_session() failures), both of which jump to the error
label and invoke ksmbd_session_destroy() on a partially initialised
session.

No leak has been observed in testing; this is a pairing fix to match
the IDA lifetime rules, not a response to a reproduced regression.

Fixes: d40012a83f87 ("cifsd: declare ida statically")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index ed343807660fa..afa0daa3f5d88 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -170,6 +170,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	free_channel_list(sess);
 	kfree(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
+	ida_destroy(&sess->tree_conn_ida);
 	kfree(sess);
 }
 
@@ -444,6 +445,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (!sess)
 		return NULL;
 
+	ida_init(&sess->tree_conn_ida);
+
 	if (ksmbd_init_file_table(&sess->file_table))
 		goto error;
 
@@ -463,8 +466,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (ret)
 		goto error;
 
-	ida_init(&sess->tree_conn_ida);
-
 	down_write(&sessions_table_lock);
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
-- 
2.53.0




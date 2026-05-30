Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025ED3112C1;
	Sat, 30 May 2026 18:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164532; cv=none; b=JqQtEEx9U5cSbAD2p/6BpFhu/aStGnNbbh+j6PDgI0kmlFP/Qh6LkkFIXOAqjPiELzbCVcXjS1421BsvKNXSHbmAmKJJDwisi5aIyVZvcFsxj8CHGKZHQ0kzFdSSwgyfKni9MrCey0B3oleJz/xJT9oJtZ3mkU7DLe8xYV3BA3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164532; c=relaxed/simple;
	bh=Ug4mMcHjI4sK5EmgznIzJ/BSgjSpfbYffrs5igO1VO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/a5tj5wF9vVAT3KyA9C1csblnKhQnrYG3pnbsvkHzmH6jSs4KVhcyBE/8zB7W8jMO9TYGe47Fy5uakw5DSiDEiDZUPB/YpiQ0qJc1JvjxvK1hdqA3OJUBHywFw6WiBZWgTgFKfR/kOiSFzoJBQOHPgUu6WZzR7+BV7TPMAEv40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bi2HUb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bi2HUb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A0B1F00893;
	Sat, 30 May 2026 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164530;
	bh=znEzxapq7vlFKktfBDIGeGU9lNo5r1sGctN1FAffqsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bi2HUb6eo9ggXijg/xWBTM0G/JEGrqfUl3KaRsnR8IuLUmWbsDoUTClgiXVmQApO
	 m3OiEcF76jtYseCy4UuYn1Qk/E+da/I7Sp8V8nnatLQ7P3nyikLWOrOJC9iQjJEVRr
	 2d9LODH81UTqIB/dSfPozoM/Qdxs9DY/r+6pWzIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 582/776] ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
Date: Sat, 30 May 2026 18:04:56 +0200
Message-ID: <20260530160255.125688803@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/mgmt/user_session.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index 8bd18610547d9..23a0662bbfd32 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -153,6 +153,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	free_channel_list(sess);
 	kfree(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
+	ida_destroy(&sess->tree_conn_ida);
 	kfree(sess);
 }
 
@@ -382,6 +383,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (!sess)
 		return NULL;
 
+	ida_init(&sess->tree_conn_ida);
+
 	if (ksmbd_init_file_table(&sess->file_table))
 		goto error;
 
@@ -399,8 +402,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (ret)
 		goto error;
 
-	ida_init(&sess->tree_conn_ida);
-
 	down_write(&sessions_table_lock);
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAEA2701C4;
	Wed, 20 May 2026 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302634; cv=none; b=gUQdhJvm6m8uI8Ayy4L2wOURGHVKkQinIV4hV2NMabiboyruicgjroB1r46J5bvQvcIlPZvFSCjpqkS6jP0ZPS2u5Zjdecj41AhGs9IEg9k50F8ns0b+/ec90O0nAFbNzwW3Opsnfr/agT0vILhCec7eeKCuNnC51AT08gOJsik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302634; c=relaxed/simple;
	bh=WmFuNuLcWLteAqKrAijyTeFAoU99Hwe+Bd8+A8B9cPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+jWIsge4wAgp1qqVjIoEec1h/eqLAPSpQYyztSqt/76g7jdQzSqHh6XEjQ4KVJUErVikMAD+m5Zk/8AzNzCO7pjOyhCEubq/kk91348ss61Wv/D6UXy5UTepO5ii+ySuB3bOwr5fUu+ImIqPU44+L6tOdjUtnOsFyKwRg1RHqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA7QL5ro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA7QL5ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AC71F000E9;
	Wed, 20 May 2026 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302633;
	bh=i5GcrwjhnBkI+Q6c4qGDR21pttTi/0cHiDiGI6wcM6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA7QL5roRKKhypoIr+wWGckkdltMjjsR09rc01tR6HQX5qnCEUdY7x0E7rO6ta6xB
	 Pqt6dmSzJmuh4zQCDeN8NLhu5a3pWkatzFmGQAkaVtu/fAeXovo+12VdaPZz/KkyD0
	 Fs7H5aLd5Mjh5PQsv2oYu88q8pdwxgmY/I7sbvPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 339/508] ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
Date: Wed, 20 May 2026 18:22:42 +0200
Message-ID: <20260520162105.978331225@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e344475a41bd1..d0a13a5cccece 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -168,6 +168,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	free_channel_list(sess);
 	kfree(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
+	ida_destroy(&sess->tree_conn_ida);
 	kfree(sess);
 }
 
@@ -438,6 +439,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (!sess)
 		return NULL;
 
+	ida_init(&sess->tree_conn_ida);
+
 	if (ksmbd_init_file_table(&sess->file_table))
 		goto error;
 
@@ -456,8 +459,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (ret)
 		goto error;
 
-	ida_init(&sess->tree_conn_ida);
-
 	down_write(&sessions_table_lock);
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
-- 
2.53.0




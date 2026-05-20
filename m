Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C1028DC4;
	Wed, 20 May 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296620; cv=none; b=Uzw63MpHi+IxGk6d7EuxWAf8x7OevX+5aWwYHwuanRhlmUFxUY66KmuMwXGbpNSOqWDMquCjtocc8QnmaC0aV+QwhsKImoxPCOcdgNc/habNCbS+4iOkSQ3Obt0R6DT+Q42RM+/c54VFY3APO216Jpq5KJuVf36LLB0TTTNdvcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296620; c=relaxed/simple;
	bh=sJAkGCkb+FPp1zhBfgRMWzRp6LvJDNEcQWvDTyrEWWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkWoa4p16lQNlLMk54pLG72I8LL4s78THXirWcbH6DF624LngXodG+Ksx8v49e/XwJd/cb5589T3/Ms+ua+iFqEx7usRCzI0exJTJ8Bjn308UYkP4IjMu66633SeWEmxWn/f4SbepvovTyGapIsS6XfSGpSSZq5NwjhOuHDw9eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8yeocA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8yeocA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B55C1F000E9;
	Wed, 20 May 2026 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296619;
	bh=dyVD/lU3UiGkHtf2lDvFRDcbI4NG+Zijt4rvXXDI2xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8yeocA6DpRY0SutM1iv18W19/yPuckgu/cg3/OVo5suO5DrAkuBTBukf62aDM6iw
	 GjpOJgq+CcPHdM40RJ9oJUre6YquPLGwr6xdnyElr5RUvTIZJAzIlWW/YhZKg/Lsm5
	 sFeNEXsSlkuIn5aPIST20O/KUvXN1A1w7ZG5LJcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0826/1146] ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
Date: Wed, 20 May 2026 18:17:56 +0200
Message-ID: <20260520162206.925036330@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a86589408835b..0dd9e6c976ac0 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -391,6 +391,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	free_channel_list(sess);
 	kfree(sess->Preauth_HashValue);
 	ksmbd_release_id(&session_ida, sess->id);
+	ida_destroy(&sess->tree_conn_ida);
 	kfree(sess);
 }
 
@@ -665,6 +666,8 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (!sess)
 		return NULL;
 
+	ida_init(&sess->tree_conn_ida);
+
 	if (ksmbd_init_file_table(&sess->file_table))
 		goto error;
 
@@ -684,8 +687,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	if (ret)
 		goto error;
 
-	ida_init(&sess->tree_conn_ida);
-
 	down_write(&sessions_table_lock);
 	hash_add(sessions_table, &sess->hlist, sess->id);
 	up_write(&sessions_table_lock);
-- 
2.53.0




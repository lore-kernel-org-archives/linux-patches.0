Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD503FB7FC;
	Wed, 20 May 2026 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302775; cv=none; b=DmkJLluaBxGgPkhvfkPVi87rUhrOWNeCiiEjtMSBe4t+idIx3VGFfi0LNuDrWPbxgtBmRyy6qflkSd7VLvwnk3P6WfRUEgxJejBqwShcY/1co9ho0RrfVFbqs/6pnBZpDD+ENy9CpvScyAo1WTw+kVtZ/hGtO6TwviZbgcHggwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302775; c=relaxed/simple;
	bh=zCNsgg9019a/wu6YEerm2rbPszHbku9X2CT3AcfpJ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeiJsAsOs/C5eblVAejRhANr0jpGa/472JdAC9zFBM/jydWF+TaNH6OHaonqECmpawtGWOg8PGp7tjSaV2/3iXMhmk6+LQB+FTO+8xVnoLln7rA18heZw/jXx/pVTwnFhFkSreOJFBYL4fh8fl7Trdnzr4I/U+XKP3cNS53gilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUr9abfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUr9abfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AD01F000E9;
	Wed, 20 May 2026 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302772;
	bh=cKlL/nSbNjxQSn+XoDa3SMhblkn2mvZAIv4XN/ApyLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUr9abfccCkUabBpr4TFdfIdJmSe4MxcYrysZryjsjkspQMtC+12XOnR2ge3F+jCr
	 9v8E8FiM1z3qJfH842YCkWMI+ulTkMMjZb1Q+frJkOi7/PQ2/O+RbkPTnWK58BCwyD
	 JCDJ6BhyAcpWjO3q2Q91ILT63KBV5t2I7iwFRKkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 343/508] ksmbd: fix durable fd leak on ClientGUID mismatch in durable v2 open
Date: Wed, 20 May 2026 18:22:46 +0200
Message-ID: <20260520162106.065116915@linuxfoundation.org>
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

[ Upstream commit 804054d19886ac6628883d82410f6ee42a818664 ]

ksmbd_lookup_fd_cguid() returns a ksmbd_file with its refcount
incremented via ksmbd_fp_get(). parse_durable_handle_context() in
the DURABLE_REQ_V2 case properly releases this reference on every
path inside the ClientGUID-match branch, either by calling
ksmbd_put_durable_fd() or by transferring ownership to dh_info->fp
for a successful reconnect. However, when an entry exists in the
global file table with the same CreateGuid but a different
ClientGUID, the code simply falls through to the new-open path
without dropping the reference obtained from ksmbd_lookup_fd_cguid().

Per MS-SMB2 section 3.3.5.9.10 ("Handling the
SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2 Create Context"), the server
MUST locate an Open whose Open.CreateGuid matches the request's
CreateGuid AND whose Open.ClientGuid matches the ClientGuid of the
connection that received the request. If no such Open is found, the
server MUST continue with the normal open execution phase. A
CreateGuid hit with a ClientGUID mismatch is therefore the
"Open not found" case: proceeding with a new open is correct, but
the reference obtained purely as a side effect of the lookup must
not be leaked.

Repeated requests that hit this mismatch pin global_ft entries,
prevent __ksmbd_close_fd() from ever running for the corresponding
files, and defeat the durable scavenger, leading to long-lived
resource leaks.

Release the reference in the mismatch path and clear dh_info->fp so
subsequent logic does not mistake a non-matching lookup result for
a reconnect target.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6c41a67be725d..d68fe617369e0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2827,6 +2827,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 					dh_info->reconnected = true;
 					goto out;
 				}
+				ksmbd_put_durable_fd(dh_info->fp);
+				dh_info->fp = NULL;
 			}
 
 			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-- 
2.53.0




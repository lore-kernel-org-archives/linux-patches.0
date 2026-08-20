Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA22E2DB788;
	Thu, 20 Aug 2026 17:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247628; cv=none; b=Yc6Q+X/DnzaLfzl/ZiSogjwphvoKtxEmZboGzZzrJqFszes07CdNSzOLu3EArbWz9h5f5huvkEX9cyCsJjgeunV4hQMFoY8SKECqgTRSHXFaqFfvVXt6FBefUPLzzGygzESP6UEk29ASi6OQxJ8xhzK3Qb1SCM/BAGQApfrpUr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247628; c=relaxed/simple;
	bh=6X+bxvv0BjjqgasMDUOicxex7ZgEwwO3Yc8JAGAkpC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRqe7d4CkCeO8bRU2osBWBFEPkGe01Arwhc24ksPPia55WxQ++r5UN+5uXks2YpgpiHfBZw7A7kU+fuhtq3qPkbWpKXesI3KVBAbIy3VdE+05pdIldMyGqxD20nT5pVZ4p64lAe4a0YyGLVc0PXrYMrHHGy1eAkxPRH66UA43IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks1B4w3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks1B4w3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5095F1F000E9;
	Thu, 20 Aug 2026 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247626;
	bh=x1mZdh/6hVhaK3l2q+95Bkd/JuZXow9lWZU4F/ZPWSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ks1B4w3NXsScCSJqXXc0qyF9e4vcNDoS5oJeJU1lE6Ni0GVUHpW0WI616jjXQQA/f
	 b47+AsI5YiVpUhJGBX9VoSJuE3FSSLjSP6I7cIUli6+UhHu7LbsM9tQXqg6jBu2KG2
	 XghhdJ+nbx7vMA/qJLLPggB4M+4O886EdkY1TBnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/166] ksmbd: conn lock to serialize smb2 negotiate
Date: Thu, 20 Aug 2026 16:56:10 +0200
Message-ID: <20260820145214.505347668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit fe4ed2f09b492e3507615a053814daa8fafdecb1 ]

If client send parallel smb2 negotiate request on same connection,
ksmbd_conn can be racy. smb2 negotiate handling that are not
performance-related can be serialized with conn lock.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cb469993b3a6 ("ksmbd: reject repeated SMB2 NEGOTIATE requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1114,6 +1114,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 		return rc;
 	}
 
+	ksmbd_conn_lock(conn);
 	smb2_buf_len = get_rfc1002_len(work->request_buf);
 	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects);
 	if (smb2_neg_size > smb2_buf_len) {
@@ -1264,6 +1265,7 @@ int smb2_handle_negotiate(struct ksmbd_w
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
+	ksmbd_conn_unlock(conn);
 	if (rc)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 



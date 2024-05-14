Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78492943F;
	Tue, 14 May 2024 10:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684098; cv=none; b=K8Bt7nYyf6VD5XL27ra4LK3opvFsp3dXnDQ6SKP1VMMeiKXdP9AhWdhaz8THdMTlYkPoVr8NzU+73LTUqvFntHMjKfknIx0TKZyFqeTB7Ffo1pwh24Ym9Y7gtvYrB8tzs/9uXpRnr30ELxOvkCWIP9dEjdT0XBBDrAuE6Yt/4vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684098; c=relaxed/simple;
	bh=ktoZY9TIj8FmM4kxEYQd9wp3OQ0/qui1e/iopQuhicw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1Xao06YU6/NGx8aTWTNsamwsPNDD0VrFqQ6OMgjmkGtVSs+k2wg4NRGUZOaxlMVyhA/DU9RkTEoD8ydPVagZjGikIFrdy0wN1nzd9ncbdZ1728Lj66zlUE062zmYM2KCRuLJGoXODp34OM846Smfub/WBdaFfqXRhPC+m/4gRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cs4Kek4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cs4Kek4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DD2C2BD10;
	Tue, 14 May 2024 10:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684098;
	bh=ktoZY9TIj8FmM4kxEYQd9wp3OQ0/qui1e/iopQuhicw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cs4Kek4AO0Ll6f5KDhqr8R4qbFG7JCGhD9o3CeWAnIslRDNZFhI0Yw9GW/A6kqhBW
	 6llmgKLI8gItpCKWKxVw4oTySOox2/7YLjMwVnwMI6qfhyK2yQY/P1qku9pUrw8hYX
	 jniR7IOWcaVCJ3Png0IN9AbVFgSDL0q0Q9JlhQGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 324/336] ksmbd: do not grant v2 lease if parent lease key and epoch are not set
Date: Tue, 14 May 2024 12:18:48 +0200
Message-ID: <20240514101050.855938469@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 691aae4f36f9825df6781da4399a1e718951085a upstream.

This patch fix xfstests generic/070 test with smb2 leases = yes.

cifs.ko doesn't set parent lease key and epoch in create context v2 lease.
ksmbd suppose that parent lease and epoch are vaild if data length is
v2 lease context size and handle directory lease using this values.
ksmbd should hanle it as v1 lease not v2 lease if parent lease key and
epoch are not set in create context v2 lease.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1208,7 +1208,9 @@ int smb_grant_oplock(struct ksmbd_work *
 
 	/* Only v2 leases handle the directory */
 	if (S_ISDIR(file_inode(fp->filp)->i_mode)) {
-		if (!lctx || lctx->version != 2)
+		if (!lctx || lctx->version != 2 ||
+		    (lctx->flags != SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE &&
+		     !lctx->epoch))
 			return 0;
 	}
 
@@ -1470,8 +1472,9 @@ void create_lease_buf(u8 *rbuf, struct l
 		buf->lcontext.LeaseFlags = lease->flags;
 		buf->lcontext.Epoch = cpu_to_le16(lease->epoch);
 		buf->lcontext.LeaseState = lease->state;
-		memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
-		       SMB2_LEASE_KEY_SIZE);
+		if (lease->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
+			memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
+			       SMB2_LEASE_KEY_SIZE);
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
 				(struct create_lease_v2, lcontext));
 		buf->ccontext.DataLength = cpu_to_le32(sizeof(struct lease_context_v2));
@@ -1536,8 +1539,9 @@ struct lease_ctx_info *parse_lease_state
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
 		lreq->duration = lc->lcontext.LeaseDuration;
-		memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
-				SMB2_LEASE_KEY_SIZE);
+		if (lreq->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
+			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
+			       SMB2_LEASE_KEY_SIZE);
 		lreq->version = 2;
 	} else {
 		struct create_lease *lc = (struct create_lease *)cc;



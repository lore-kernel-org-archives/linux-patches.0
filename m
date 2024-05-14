Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710C26311D;
	Tue, 14 May 2024 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685979; cv=none; b=f6JN03YDLw2Np1rWGIgVMR0nPiESWjl4C7f76sY/az0HPUYNLz0XwtEFh3NhBaHgWFZN2s8iet2ilz0oQ6dM9Vs4/w56IRi2vpJ1o+GgTdG92y1wdPZI+aYYKCMNmCnTsxPIQtE08kDtjyp+PT68C/XCOVYLQPb+MpHHv2VUR1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685979; c=relaxed/simple;
	bh=yfBV165BTo6j/Q9SsItp4MNa5X14027pEV8P0Bl3J64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1Vhg3EKDIPebbANoXmp4uc/pKl1fymiziy4X2M/EONdFkoDKvvwI/36hYmpbnkfP7GE08DIm/HdPA92BBzy/nPNHZTk4Jsrxx+WaXtxwFHMaQ/xMDeT8UYmur68mgJQ9qc9MYMyJZKLd4r1LzemeHar1dbwlRCTu2wnF2egv7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFWvOQc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFWvOQc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8FCC32782;
	Tue, 14 May 2024 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685979;
	bh=yfBV165BTo6j/Q9SsItp4MNa5X14027pEV8P0Bl3J64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFWvOQc90u+90+omcNCbwdRQmgRlPtKBUIS2tL7jlgRy+6M9Msz+RyDv2QSsSQrsT
	 75TFxWVkzdD803TmBy3GIcrZN+OqM5OyuHkiveSSDzp+PU8WtIJrnXmqpKQhKAocpA
	 MOdfvHH1M+f5gNRo3EVeadqYPj5WLCl8Esc2dEBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 289/301] ksmbd: do not grant v2 lease if parent lease key and epoch are not set
Date: Tue, 14 May 2024 12:19:20 +0200
Message-ID: <20240514101043.173322437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



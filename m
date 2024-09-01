Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D1225D9;
	Sun,  1 Sep 2024 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210133; cv=none; b=URnOguiuanMtWe/Rwd+X1ym7BExrhiLuhq7smzY2akUm+ZHAnj8F2rgO9bo7jU6qWsV29N72HgvOvyvwrcssMntIuCxE4/GhXMHXJgv6Pe1jE+l06J3gh87M4r4fqGoRcxxxch8lh24+aPJN9sYaPe68X4nQlmZuUDrKJHMHO9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210133; c=relaxed/simple;
	bh=f64LPuKafuWHDSh2QAJ6qLaEdyaiFMi6fWObykZBBxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FENMkXuT+lBUoSF7XKkuURPhWdvxRyO09SfkY8bXIsNpJM+sGhpcGjsXhgKbN7jZ8hj8cEPfoMJ6djb+JtcHlPlmDY1lPJf7J4tFC0bqdowMwsl9tDLH2FdlUOjv8z5LsCc3QCBSInK+c4yWeZEZeiaMX8IdTyJZo7s3iQIIKm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQONwqjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQONwqjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C66C4CEC3;
	Sun,  1 Sep 2024 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210133;
	bh=f64LPuKafuWHDSh2QAJ6qLaEdyaiFMi6fWObykZBBxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQONwqjcFKslZaXugMruZdhTzZRjZbZZi2JWxm/sPytWfN7FCFqp3E0/VFivSaTJw
	 wwK/mxl+bh2uxVvzaQl3aq/pPIlIO4np83FWTqvfdT2qp6kU6nMb/chv/a3zl+/kor
	 BYwEu4AlfR6PYIy2SK99FPu3z0maHgfoji/HIuNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/215] NFS: avoid infinite loop in pnfs_update_layout.
Date: Sun,  1 Sep 2024 18:16:49 +0200
Message-ID: <20240901160827.017248262@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 2fdbc20036acda9e5694db74a032d3c605323005 ]

If pnfsd_update_layout() is called on a file for which recovery has
failed it will enter a tight infinite loop.

NFS_LAYOUT_INVALID_STID will be set, nfs4_select_rw_stateid() will
return -EIO, and nfs4_schedule_stateid_recovery() will do nothing, so
nfs4_client_recover_expired_lease() will not wait.  So the code will
loop indefinitely.

Break the loop by testing the validity of the open stateid at the top of
the loop.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 9f6776c7062ec..e13f1c762951a 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1994,6 +1994,14 @@ pnfs_update_layout(struct inode *ino,
 	}
 
 lookup_again:
+	if (!nfs4_valid_open_stateid(ctx->state)) {
+		trace_pnfs_update_layout(ino, pos, count,
+					 iomode, lo, lseg,
+					 PNFS_UPDATE_LAYOUT_INVALID_OPEN);
+		lseg = ERR_PTR(-EIO);
+		goto out;
+	}
+
 	lseg = ERR_PTR(nfs4_client_recover_expired_lease(clp));
 	if (IS_ERR(lseg))
 		goto out;
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8831FB40
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294C2C433CA;
	Fri, 21 Jul 2023 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956027;
	bh=J93i8bXCRCpaMi01j61ocHjX+VfVknjwjaL4vnht0YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPZM1+zyfhkd7niTt4xs3SdhUbUnxy+9u1RYCOz3Y65qs8SUTM5a6G4ZEfS97tG8d
	 xMJvhZpKTw7VktCI5hSaEjaHqJXaN59asO9m2kvNCtveOBAO2H11G3jSB2jTxl3cWm
	 qglX1CtPvVO/H1laLatS5OHb8so7ilwIshmFTYdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.4 108/292] smb: client: improve DFS mount check
Date: Fri, 21 Jul 2023 18:03:37 +0200
Message-ID: <20230721160533.446313732@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

commit 5f2a0afa9890e728428db2ed9281bddca242e90b upstream.

Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
that are unexpected by the client, so to make it easier, assume
non-DFS mounts when the client can't get the initial DFS referral of
@ctx->UNC in dfs_mount_share().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -296,8 +296,9 @@ int dfs_mount_share(struct cifs_mount_ct
 	if (!nodfs) {
 		rc = dfs_get_referral(mnt_ctx, ctx->UNC + 1, NULL, NULL);
 		if (rc) {
-			if (rc != -ENOENT && rc != -EOPNOTSUPP && rc != -EIO)
-				return rc;
+			cifs_dbg(FYI, "%s: no dfs referral for %s: %d\n",
+				 __func__, ctx->UNC + 1, rc);
+			cifs_dbg(FYI, "%s: assuming non-dfs mount...\n", __func__);
 			nodfs = true;
 		}
 	}



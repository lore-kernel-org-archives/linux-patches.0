Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456921EF363;
	Wed, 17 Sep 2025 12:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113652; cv=none; b=iQs+f4rrQGUSRAHszZL1VTUkkQZxhiZSgL7GuDc31tZITgh04nWGLZT9rNB0PvVzt5AVKHKQbtnOsaRqJoGatK/M9cycoBtmkNiuqIWhM2jLOf5HXbS44+CCf6h1AxqD8n+nnRP6tbpiLa40+kdflq/uf/lEdmcicqBbuQByqrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113652; c=relaxed/simple;
	bh=P/qLRxuK5hKkoH2rhDabiELu29vgx2y3WHc7LP0fs60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST6e7Dand00ifOPjRWQly7AtcV1VB1VBKrPMK+XQNjJt82n/8YZPc/QQF8EqaEq55keiN6oNm8HAjDiN9qjGfTxEJzrIWJHgOvmHKYLw9JLrKpx87pAjOqO0KMxdyngSgcw0H2QY36Xz9bd/bNjyYZLjuv164giVFVEGfZIXBHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQWajt2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQWajt2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1C7C4CEF0;
	Wed, 17 Sep 2025 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113652;
	bh=P/qLRxuK5hKkoH2rhDabiELu29vgx2y3WHc7LP0fs60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQWajt2VDAhk6GroZHJll2RW9e6lh5NfEEBbUB7md5Qps/d8/oz5C+Nod92An7jzn
	 Ew6qyTmVn28uI5ahFtYeRlzqUNupXz+XXmQoNof/PrvAr5CjNMbtGNq1tgkT3U1tIs
	 y3jkH7gRmeguHVzAVpDCcWk4kfZ8zbifchcQ0bWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/101] NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set
Date: Wed, 17 Sep 2025 14:33:55 +0200
Message-ID: <20250917123337.164382558@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dd5a8621b886b02f8341c5d4ea68eb2c552ebd3e ]

_nfs4_server_capabilities() is expected to clear any flags that are not
supported by the server.

Fixes: 8a59bb93b7e3 ("NFSv4 store server support for fs_location attribute")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bc1eaabaf2c30..124b9cee6fed7 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3882,8 +3882,9 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 			res.attr_bitmask[2] &= FATTR4_WORD2_NFS42_MASK;
 		}
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
-		server->caps &= ~(NFS_CAP_ACLS | NFS_CAP_HARDLINKS |
-				  NFS_CAP_SYMLINKS| NFS_CAP_SECURITY_LABEL);
+		server->caps &=
+			~(NFS_CAP_ACLS | NFS_CAP_HARDLINKS | NFS_CAP_SYMLINKS |
+			  NFS_CAP_SECURITY_LABEL | NFS_CAP_FS_LOCATIONS);
 		server->fattr_valid = NFS_ATTR_FATTR_V4;
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL &&
 				res.acl_bitmask & ACL4_SUPPORT_ALLOW_ACL)
-- 
2.51.0




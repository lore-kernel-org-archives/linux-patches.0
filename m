Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B8A30CB2D;
	Wed, 17 Sep 2025 12:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113237; cv=none; b=s90xi/P2dOGM8GAxvaWmfW5em68h1NeBTPM33nEELnZ2AE59sI0W5/X9VV8duptColHepf+HuoXFdyNJVJrINjvLALx5erZZyHebw8ZuLkJqBIADFloFB16WJC0Cum3OJPx9JY166UfUDEf3j8DyuTyDSxBbZo+lyhUYqZ0eURA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113237; c=relaxed/simple;
	bh=xV2YlNx29Ykl5S462Nz6hUPpEX+Hyx4jag7iOlfJsg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxjORBv19ISOd5efEq+XSLJs19GWXiq/4E9PHRTKNSLNTaNXQXD9WeLbWn/T/ZIv7tX6V9t3c7j5dsuUTIJ/VzpQx5YTijwDx2nisx8fTAzbSREtH2vfA8EbcQkePg+KuLVgiyfsKF5WwL9JMNCR/+aeluWCVHcs28pcjMRXYwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDA7uh1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDA7uh1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7DFC4CEF0;
	Wed, 17 Sep 2025 12:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113237;
	bh=xV2YlNx29Ykl5S462Nz6hUPpEX+Hyx4jag7iOlfJsg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDA7uh1pFAZPIEvR0dCBDWtvcxgjHUQfKvgo7FQlALElrmXd1f8NKFvav2dwtEz4O
	 uQJDMks8c9H5WwDVqUSIzhK+AConi2wBYZT7ML6a/6K9u/1CqnxNzTncIdISpCD9y3
	 A4ZbeO0O4jJKlEJCm7bK27NanXlPtFEs8U8IGlzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/140] NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set
Date: Wed, 17 Sep 2025 14:33:16 +0200
Message-ID: <20250917123344.897679579@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3ac8ecad2e53a..7a1a6c68d7324 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3989,8 +3989,9 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 				     res.attr_bitmask[2];
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




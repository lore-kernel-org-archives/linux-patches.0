Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5962FCBFC;
	Tue, 30 Sep 2025 15:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244925; cv=none; b=TMtkJ+LFnl7Tw+lZUKpGYS0D0oCZUj1XjxF3B6uEruA1qPMbLNtjcDxjRoEzxQJ3wPkNGY2jYzpEuzIyYzXnkOm8tcaT8my2KbNuMJxlR7ON+dhQ/DNFgDlfPjVrYHnieVGLQYIk2S8JheBDiBodv5H/GJb0FQbf71pC2ZFToJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244925; c=relaxed/simple;
	bh=ns60+WQUW5/EQsCMEHNirdVI0XCP4KUkEX2Dutu/soQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZca/OodkYpBOPhWOZZEAmVPBCls0Vi/XjNLjJJJUW+Y4PYoLmZvMoVO0NVqupDvrEODWPrJuvHutPEfBMEXBOdvUo/jHXrdxnSjVkeG8e+hX63oR8Cw8spNUEegRI64RtSZqzG2LNtHXVsp0aurtZHsKXLScpE2VNiI+YI8QHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgfuS5BU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgfuS5BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFFAC4CEF0;
	Tue, 30 Sep 2025 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244925;
	bh=ns60+WQUW5/EQsCMEHNirdVI0XCP4KUkEX2Dutu/soQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgfuS5BU3FvsGPwJ3fPDGQTA3tenTz+3xU82+MQNb4CEUSjFKj0O4I24j78n3OxA9
	 Elz5m1fS6JKGZ1MQgTPo1rKMBJ+UbO42ysli8ac4wVNPKAEnBmAlISWQqCqI0JuzW6
	 QnII86meXTj4P/NeMA/GSNtuys5EJfnKWfHSIrLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/151] NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set
Date: Tue, 30 Sep 2025 16:45:42 +0200
Message-ID: <20250930143828.094008271@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 65dae25d6856a..3d854e2537bc2 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3904,8 +3904,9 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
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




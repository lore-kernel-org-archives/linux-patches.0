Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFFB13B2A4;
	Wed, 17 Sep 2025 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113243; cv=none; b=UiqPXMmgaBtMWJu1zALvonpRclWgEJQ8paSKcFKhcOxuGy4V+NBYoWH3VPtWJ+bpEYjMrIgR934S4v2lc7sYdYqWUXqPmaKArYqGtqempJek83Xd8wskVy/3uAlDkr56a9UIQmC9KU2wOI+PHzssdPOXJa3BYwTKFYJMALQFcXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113243; c=relaxed/simple;
	bh=xgeHZshSbOKDRHQeRmn2r9F70UQwItOKoO0yqp1aSYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGdjVG1fZ7sHf7r2v8C0rplZaM3wq1pJANkjRTPJlnLcZnST+24UtY/f1vj0A/2k3tI9NZoegiA9NR5Pk8bFhqO0hrYgGocp83Cs0ePuCgjF/8D7qQlvCfi6PiKaj7WC2ZNi3lbCBxrfPdDXorK80nRRVRWsHLvT27UaqCVvIyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDhi8DJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDhi8DJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11250C4CEF0;
	Wed, 17 Sep 2025 12:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113240;
	bh=xgeHZshSbOKDRHQeRmn2r9F70UQwItOKoO0yqp1aSYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDhi8DJ+6tfAaomaa4RQKfZjLLwV/2mWnYV4PkvX9F0EFQRccAOU6T4QHfh+bj3PL
	 Pe4wGqU3D+BFAPxnEZceZAO7z8TPhIzewQC9vt9Vxhc8FeuvZcxXF7mO1bTOyxtBHp
	 j9hPTpSe6gKEQRIACEbFcA8cgQeSiq3cycZn2aNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/140] NFSv4: Clear NFS_CAP_OPEN_XOR and NFS_CAP_DELEGTIME if not supported
Date: Wed, 17 Sep 2025 14:33:17 +0200
Message-ID: <20250917123344.920092355@linuxfoundation.org>
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

[ Upstream commit b3ac33436030bce37ecb3dcae581ecfaad28078c ]

_nfs4_server_capabilities() should clear capabilities that are not
supported by the server.

Fixes: d2a00cceb93a ("NFSv4: Detect support for OPEN4_SHARE_ACCESS_WANT_OPEN_XOR_DELEGATION")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7a1a6c68d7324..ea92483d5e71e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3991,7 +3991,8 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
 		server->caps &=
 			~(NFS_CAP_ACLS | NFS_CAP_HARDLINKS | NFS_CAP_SYMLINKS |
-			  NFS_CAP_SECURITY_LABEL | NFS_CAP_FS_LOCATIONS);
+			  NFS_CAP_SECURITY_LABEL | NFS_CAP_FS_LOCATIONS |
+			  NFS_CAP_OPEN_XOR | NFS_CAP_DELEGTIME);
 		server->fattr_valid = NFS_ATTR_FATTR_V4;
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL &&
 				res.acl_bitmask & ACL4_SUPPORT_ALLOW_ACL)
-- 
2.51.0




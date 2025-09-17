Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F918BBAE;
	Wed, 17 Sep 2025 12:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112609; cv=none; b=qjbWpINPKTKnbO21YhFruOXa6DpBQyp0VzOs2vq+LCTEMpj/QhAzu/gZM34xdYHDkoW4IdKbdW1pPKjgEQ0zQNWqZT8ivCfotDddT3RWbFuoS09IUUUcA2QPJnKJgQRauWlZh+z+UilNC6v9QkVCTmCmkQ9C5ZmRqhG89Bgk4sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112609; c=relaxed/simple;
	bh=CCbLL0YgcxPIxlz188lMuND1DUt2dqzC5/UreeWwEKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWffAM9U8jEVUdRCu6eRUFvTjNvbloUtGVQulrlb08GUsrTFbx5bj1N6nzAQavk0JD9TOJCajZFS1yasl9hxhmffyZFxq3MTwjsuARNPrhIRmcqLeWFdHVWgG2pjcf6/157NkO6d5CJvREiFVhc1i+ravAsH+ZvNFKTeeWh5a80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o78ESIh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o78ESIh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3064FC4CEF0;
	Wed, 17 Sep 2025 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112609;
	bh=CCbLL0YgcxPIxlz188lMuND1DUt2dqzC5/UreeWwEKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o78ESIh8AAfcPjmPt/OJK1TC/EoMjkqVCF5xJyRdU8K4qt3Y7hm2p1IGAzF0CrPER
	 Zh+lYcVY7lTSMGip8ELU1GJYrNra/mgxOvuFb01ar+fRUDW/w+7VcSBTRR6oIrzbLM
	 1d4A6GtEB8E0oGb/JDOOCh14simtp34GSbUhRwOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 023/189] NFSv4: Clear NFS_CAP_OPEN_XOR and NFS_CAP_DELEGTIME if not supported
Date: Wed, 17 Sep 2025 14:32:13 +0200
Message-ID: <20250917123352.420704701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index ccd97dcf115f9..8d492e3b21631 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4009,7 +4009,8 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
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




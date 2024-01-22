Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064124E1CD;
	Tue, 23 Jan 2024 01:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974004; cv=none; b=B0OLUZYL1OHEeC8Td9VIvdSCrY4Q1KnuJBSWQx4DaWsExObkSHmoHyoco8Cc+f854vRAL9+gPAiv2ns5fydza6eUK0b6iTURDMPXJ07QsMDhZGiuL3AHG2fKSIDusDQ7zDbP3ngNZpK6/Kc7yzDLxkIq39wDbCCxYZy3Cyre/HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974004; c=relaxed/simple;
	bh=eqWZT8JHWsIt3uaiM7Z8m+D89fD29zMi9kSTCG7dkUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln69clOC5RAKXGOUF5xdteORiRKmDPcjtrI8ygooymutJBKr9ILc2iSK8G+elwzejMfdU7VJJmNANtKHYxjlyxy3cyni66n7dVj7rQjYir9vMMYiRoIZWBA1sPgw+0sSjRKC91JfcO2vy0A7I1AND3VehZ4W8+0K8yJ2pCHaVgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsDP52gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsDP52gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AC5C43390;
	Tue, 23 Jan 2024 01:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974003;
	bh=eqWZT8JHWsIt3uaiM7Z8m+D89fD29zMi9kSTCG7dkUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsDP52gpedPLZmsyI7cDZMye3MkqkZWpFddiiGXgRa5RAm/WMWOpG5kLWzNdFEOqM
	 TzxBly7kFminZHj4Uz6ix78r1cRhgJNkccmxhF7ierkePRa7N2Boz5PMGf5NC4qg6S
	 RWK3pGGe6G3zfijn6Vvb0bYqqYD48aMJPHQDKGxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/374] NFSv4.1/pnfs: Ensure we handle the error NFS4ERR_RETURNCONFLICT
Date: Mon, 22 Jan 2024 15:56:12 -0800
Message-ID: <20240122235748.670789949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 037e56a22ff37f9a9c2330b66cff55d3d1ff9b90 ]

Once the client has processed the CB_LAYOUTRECALL, but has not yet
successfully returned the layout, the server is supposed to switch to
returning NFS4ERR_RETURNCONFLICT. This patch ensures that we handle
that return value correctly.

Fixes: 183d9e7b112a ("pnfs: rework LAYOUTGET retry handling")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index d65af9a60c35..a865b384f0fc 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -173,6 +173,7 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_RESOURCE:
 	case -NFS4ERR_LAYOUTTRYLATER:
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		return -EREMOTEIO;
 	case -NFS4ERR_WRONGSEC:
 	case -NFS4ERR_WRONG_CRED:
@@ -560,6 +561,7 @@ static int nfs4_do_handle_exception(struct nfs_server *server,
 		case -NFS4ERR_GRACE:
 		case -NFS4ERR_LAYOUTTRYLATER:
 		case -NFS4ERR_RECALLCONFLICT:
+		case -NFS4ERR_RETURNCONFLICT:
 			exception->delay = 1;
 			return 0;
 
@@ -9588,6 +9590,7 @@ nfs4_layoutget_handle_exception(struct rpc_task *task,
 		status = -EBUSY;
 		break;
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		status = -ERECALLCONFLICT;
 		break;
 	case -NFS4ERR_DELEG_REVOKED:
-- 
2.43.0




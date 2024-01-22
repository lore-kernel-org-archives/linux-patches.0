Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA135CAF;
	Tue, 23 Jan 2024 00:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968408; cv=none; b=T//tOU9I7a/yPg2OXe/sMxMpAYDRojA2paLt4VMk/yNUKt7fh9uEfZQxJRvQvVSDnLpeBUvldP0Z/Ai3KWwD1XU48uQtyz4CUsmo8/8Dm4Bmg0NvI0aT4eGg09bzW1DJIgOf/QLr0n9yHKrhU2anZNWwjyx4wa+uDgrrgzsAlEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968408; c=relaxed/simple;
	bh=5yRZC5lPfnzbPSrGlK2Eu5IFtqpv/L8tbtG/utTK2WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwYylz8hk3PuLL9unQkyUExWHUYh9BRRJ4c0ywMHLR7l+5tYnexNovLa+OfR+kE2EIhncv+QfBa2lH0/gx1V2dwmnEcMw7kCvYVpgPQ+b0y7EqInrnETFuY+B0hO82NWBvnI9CoozClU/hjjPR52WVaGthfUCZeJaVvsjvEQHPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOr1KETT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOr1KETT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBBCC43390;
	Tue, 23 Jan 2024 00:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968408;
	bh=5yRZC5lPfnzbPSrGlK2Eu5IFtqpv/L8tbtG/utTK2WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOr1KETTxDPlilIbNc3dP1LhqN+FIJikPEzAdA+dyDZ95AYLVAe6p7srqbGe/2mBt
	 EPJRUCoxTEaAA7TkV+4tPSaqnGqJ4G99XT6cIlUV2uQLN3LQ86H1M/37Jf3w8TsPPD
	 iU7LcCJRV9BNVOXn03x7bQ9FfaSQWlbcFgDOHkaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/148] NFSv4.1/pnfs: Ensure we handle the error NFS4ERR_RETURNCONFLICT
Date: Mon, 22 Jan 2024 15:56:59 -0800
Message-ID: <20240122235714.947701138@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c44efead1a32..c9db9a0fc733 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -163,6 +163,7 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_RESOURCE:
 	case -NFS4ERR_LAYOUTTRYLATER:
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		return -EREMOTEIO;
 	case -NFS4ERR_WRONGSEC:
 	case -NFS4ERR_WRONG_CRED:
@@ -509,6 +510,7 @@ static int nfs4_do_handle_exception(struct nfs_server *server,
 		case -NFS4ERR_GRACE:
 		case -NFS4ERR_LAYOUTTRYLATER:
 		case -NFS4ERR_RECALLCONFLICT:
+		case -NFS4ERR_RETURNCONFLICT:
 			exception->delay = 1;
 			return 0;
 
@@ -8876,6 +8878,7 @@ nfs4_layoutget_handle_exception(struct rpc_task *task,
 		status = -EBUSY;
 		break;
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		status = -ERECALLCONFLICT;
 		break;
 	case -NFS4ERR_DELEG_REVOKED:
-- 
2.43.0




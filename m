Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D67C12A17F;
	Tue, 23 Jan 2024 00:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968883; cv=none; b=lQEWjC7q9cbmWaDmwykHckbYSado0hQuxdlkBPNQkf/D7s0NqJeOGxxrV+Qcy+PdzKAdL3fFVHkyDwiv3N3aQ7qd0kAKd56H0BBKt/8ypB/4bXC1yUy/3bfLmzhkuL9Av3OcqEvuopT9DazmGAY6QqomkBTK3wDFdIestsQX/Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968883; c=relaxed/simple;
	bh=ig4P/rnc3fWXXwGMlIpbKKDZ7iZaU0P7Qsx9QY++GcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ietgHUEXOBwSSR+i8WEaCa4SywWve3lHst/ZqLMDrpxVvP6eo6P0IkxxTyj5NVrQyAt7R4Z4So6DbR9xrp9WKt3HN7t2iy1Ufl0o1/NGgQEqzSvS+FRJxOtOVUplcxMs6BtA//BEFwAA/ynynJTC5Kb6Y1UG/rx3AIrEUkz3imQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhDvnS4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhDvnS4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92865C43601;
	Tue, 23 Jan 2024 00:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968882;
	bh=ig4P/rnc3fWXXwGMlIpbKKDZ7iZaU0P7Qsx9QY++GcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhDvnS4apoAwMZBQ1NOahk/4QCb5j0gb02bjhMq+5SOvktbg9RcEgXJOItdENn7G0
	 4YclBldVqRHljB+intuw5WB7UsmwkaZVrbFqkx5JqPPKcxSamvIO4Ca//Ss5hNv+4f
	 BFt20tC5IqXOjLSr0EXmN8Qd9klU/E/7eYLWNb7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/194] NFSv4.1/pnfs: Ensure we handle the error NFS4ERR_RETURNCONFLICT
Date: Mon, 22 Jan 2024 15:56:49 -0800
Message-ID: <20240122235722.624499967@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b7529656b430..31503bade335 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -168,6 +168,7 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_RESOURCE:
 	case -NFS4ERR_LAYOUTTRYLATER:
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		return -EREMOTEIO;
 	case -NFS4ERR_WRONGSEC:
 	case -NFS4ERR_WRONG_CRED:
@@ -552,6 +553,7 @@ static int nfs4_do_handle_exception(struct nfs_server *server,
 		case -NFS4ERR_GRACE:
 		case -NFS4ERR_LAYOUTTRYLATER:
 		case -NFS4ERR_RECALLCONFLICT:
+		case -NFS4ERR_RETURNCONFLICT:
 			exception->delay = 1;
 			return 0;
 
@@ -9159,6 +9161,7 @@ nfs4_layoutget_handle_exception(struct rpc_task *task,
 		status = -EBUSY;
 		break;
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		status = -ERECALLCONFLICT;
 		break;
 	case -NFS4ERR_DELEG_REVOKED:
-- 
2.43.0




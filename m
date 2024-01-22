Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC49B626;
	Tue, 23 Jan 2024 00:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970690; cv=none; b=TndKLyXgiKlr5n6hG/toRlQ6E9yZolJ8bpLVwnMbqIBUHsvOh1LlSJmqa/PinPocBIgzjNKm68/OTTxJmXJ5MlZS3fBKr8SDUoKyCFdbj3WaOuJwftslHjKAAwciR31km9WuGlEQdeEUKVOalZ4rgikoFRkorQg73ANNGJGAW/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970690; c=relaxed/simple;
	bh=z1IkpyOGaWwSxFZaY7ncqSsKPsbeaPSxiDAzrw24ncE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/McbG0zRYBgwxnzcrHq+D8QHS64M1wvY2f4l5epp0Ir1nSWTVAfi3UmsJZrC3Eomd+heNuDtN6HjnYWEdVaSguNvJTGAtvSkDRQOegiAVsnq+AJDPpSLgjB3vwA7VndmP3un12JsQ8Tsd9AQy+wCka5LA2CGE1yoYZT5RfBMgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBfFWhNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBfFWhNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA40C433C7;
	Tue, 23 Jan 2024 00:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970689;
	bh=z1IkpyOGaWwSxFZaY7ncqSsKPsbeaPSxiDAzrw24ncE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBfFWhNTqZ9cy2r/d14YDFHlE/YkrODYFsBMGeZ7TqAnTEKfmrXkV2PoP5j0o4rVy
	 kqIMrUs6zqo16IC6LPUq/mRbX4Zkj5DQ8mEdV5yz3MM91IZshYhAQ705EUIe9T+4qh
	 uH17DKJUgdXjnqWpeqICxeYHCdoUuvlcjZSEASjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/417] NFSv4.1/pnfs: Ensure we handle the error NFS4ERR_RETURNCONFLICT
Date: Mon, 22 Jan 2024 15:53:53 -0800
Message-ID: <20240122235753.958385031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 85a952143e9f..ec3f0103e1a7 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -170,6 +170,7 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_RESOURCE:
 	case -NFS4ERR_LAYOUTTRYLATER:
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		return -EREMOTEIO;
 	case -NFS4ERR_WRONGSEC:
 	case -NFS4ERR_WRONG_CRED:
@@ -558,6 +559,7 @@ static int nfs4_do_handle_exception(struct nfs_server *server,
 		case -NFS4ERR_GRACE:
 		case -NFS4ERR_LAYOUTTRYLATER:
 		case -NFS4ERR_RECALLCONFLICT:
+		case -NFS4ERR_RETURNCONFLICT:
 			exception->delay = 1;
 			return 0;
 
@@ -9667,6 +9669,7 @@ nfs4_layoutget_handle_exception(struct rpc_task *task,
 		status = -EBUSY;
 		break;
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		status = -ERECALLCONFLICT;
 		break;
 	case -NFS4ERR_DELEG_REVOKED:
-- 
2.43.0




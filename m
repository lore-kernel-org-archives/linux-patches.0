Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FDE627E3;
	Tue, 23 Jan 2024 00:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971185; cv=none; b=RoZ2OOZncMkrahBDyRlb6K5wtLSbjfO32WuVnIQSjitgpcD0086+L2+LYfhAR0vYmbtLMS8jf2f8ctgS3RIWU1ZOwoP7Cdst9LdSFAglm+gvzXexUdaAnAP9kJ3Tx2Ywr/hkk4fMwS2kl2wZ6k7S8hjmp4JiJTs2G6WpYvL/JJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971185; c=relaxed/simple;
	bh=VwP+ThMdH4kMKa4mdSivguWOZ0/UaKPJ6+fGbEfJ714=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OebYyv3pBUKZ0tHvUyDt4CXeTxrj/qjTfTDiCf+cvyurxCt0RU1K1yWWbwBOvXsqdNtBCBy4owGOfkT0X5MhCV9kNKsXL3owfG43DZ+CMkP83xuukbiddk99PqbpGkQzi4jOmepivvUcmijqUq+0Kgz5NaSi26AKfPtHHoRFHc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwY+IO8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwY+IO8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09302C43390;
	Tue, 23 Jan 2024 00:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971185;
	bh=VwP+ThMdH4kMKa4mdSivguWOZ0/UaKPJ6+fGbEfJ714=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwY+IO8AweXXQ+cRV49sFYevXKZkuoS1NOzfjO8bIBRTawKNw5ACeY+hgT+uUPU8c
	 memti6KeVqWIWyALDTYbVGT8ymspfohSdZat6ELaWQhpLAejnoXSe38Uz94d6c2K9l
	 U9BuvEV56lICZq3gBTYx7paUWK/ZcRVV6e3IVTWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/286] NFSv4.1/pnfs: Ensure we handle the error NFS4ERR_RETURNCONFLICT
Date: Mon, 22 Jan 2024 15:56:53 -0800
Message-ID: <20240122235736.219070325@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f3f41027f697..7c3c96ed6085 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -177,6 +177,7 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_RESOURCE:
 	case -NFS4ERR_LAYOUTTRYLATER:
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		return -EREMOTEIO;
 	case -NFS4ERR_WRONGSEC:
 	case -NFS4ERR_WRONG_CRED:
@@ -563,6 +564,7 @@ static int nfs4_do_handle_exception(struct nfs_server *server,
 		case -NFS4ERR_GRACE:
 		case -NFS4ERR_LAYOUTTRYLATER:
 		case -NFS4ERR_RECALLCONFLICT:
+		case -NFS4ERR_RETURNCONFLICT:
 			exception->delay = 1;
 			return 0;
 
@@ -9445,6 +9447,7 @@ nfs4_layoutget_handle_exception(struct rpc_task *task,
 		status = -EBUSY;
 		break;
 	case -NFS4ERR_RECALLCONFLICT:
+	case -NFS4ERR_RETURNCONFLICT:
 		status = -ERECALLCONFLICT;
 		break;
 	case -NFS4ERR_DELEG_REVOKED:
-- 
2.43.0




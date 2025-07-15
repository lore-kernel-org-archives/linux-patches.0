Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F682E1757;
	Tue, 15 Jul 2025 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587714; cv=none; b=tYz2XawFB0WYhRFk37VFcsYVqI/Nvc21v7ASh0GMCIEpArU88WKL1Fu9lH9RaA5VXLs3p3ZIYm28tc+HprfJidpHdev79kK39iSTc4/niKt/DNGG7mY641pOL7FasOsmpVWUWwkwrEqItlILr4Y5no+uT5NNhOqw1US96TKuphQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587714; c=relaxed/simple;
	bh=hjd/OR+KvhA7NBmBF56ERX4GZjbC6Tk6DTU5y3u1rDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUKDJCo9dauiISsTeoi/D0dMyOTXrD6+ds4ubC3lqpayt2rEs5qDJSO9lcXdaci/HXZVFx4Fi/CwonRQP6yRDgl0fOXZ5mTIYJXhv4mP6bjHxyzjMEuSTwKm4bMr/BekItPKngm2neadD9wyISHSX3Pn1jLA9bHs5c+LoWy4FBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cq4z3jCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq4z3jCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A970BC4CEE3;
	Tue, 15 Jul 2025 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587714;
	bh=hjd/OR+KvhA7NBmBF56ERX4GZjbC6Tk6DTU5y3u1rDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cq4z3jCgtB8g/dMnY8704fBhEDbB2yO/e4o2XGJ2XjyXKoPSUfMnT49HV4dtyd92g
	 bIeiw+oB8AIRVq3xfTnjWFgHv7pLMsy+fZ275NdIrwvUs4D8pWaoSqM20l1w4O+Jss
	 9MFwyBTboG81J7n+O+WOD0cbdbKMtzYZAxbUZUmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/208] flexfiles/pNFS: update stats on NFS4ERR_DELAY for v4.1 DSes
Date: Tue, 15 Jul 2025 15:13:44 +0200
Message-ID: <20250715130815.555271026@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>

[ Upstream commit e3e3775392f3f0f3e3044f8c162bf47858e01759 ]

On NFS4ERR_DELAY nfs slient updates its stats, but misses for
flexfiles v4.1 DSes.

Signed-off-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 38074de35b01 ("NFSv4/flexfiles: Fix handling of NFS level errors in I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index ce9c2d1f54ae0..46b106785eb82 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1127,6 +1127,8 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
 		nfs4_schedule_session_recovery(clp->cl_session, task->tk_status);
 		break;
 	case -NFS4ERR_DELAY:
+		nfs_inc_stats(lseg->pls_layout->plh_inode, NFSIOS_DELAY);
+		fallthrough;
 	case -NFS4ERR_GRACE:
 		rpc_delay(task, FF_LAYOUT_POLL_RETRY_MAX);
 		break;
-- 
2.39.5




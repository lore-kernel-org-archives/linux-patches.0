Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7AE1DB127;
	Tue,  8 Jul 2025 16:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993402; cv=none; b=buVD/4E7GSvY7YoLx98q6WWbC/u6GfcyDQJo749cdndse+au0cxMnqHaxe+hTIvDBvYNFf14kpTCDRJwSGxEuexCrG7+sXNFN+ggrFFinX8jtwaTZ+kveUVf3WgJflFRDeFE5DfCNWJ9cM0BVQTsN5WU/f9MUpAGTuZM2ZxNniw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993402; c=relaxed/simple;
	bh=x6lQwQXepsFbFwiqvjorencRsHV2ta7X1eofOHsOcDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9COnESQyAJM9tYi9g3H5i4If4YkfjXUdIDQ7O15F2HSyjc04vyaev1hY7JWSF3vxfVty+IdZGhg7UcwO1tSiAWpmafCdN6oRC0yR6gv6vxSElrO1yhWvUPRqeeJgQHMLuOfVcBVJcsPwU5M8MBI+2Q5g9xSD575GOquBNsj8HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdJN+DiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdJN+DiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85026C4CEED;
	Tue,  8 Jul 2025 16:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993401;
	bh=x6lQwQXepsFbFwiqvjorencRsHV2ta7X1eofOHsOcDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdJN+DiKWgBQk1KuOqGJbFWlbZETBswlHkD1Onm/4tU8zdV0dCVdIg4md/j7fDTyr
	 vLgeEXgg6pxd24ZonsVsLX5mKAN+ivblu+xalKWFqoS75dMiwjiGQkcahS8hENNtKL
	 zCeDmi3/b5wOdcxpcXZrbiJanYqlJLl0DpL+pY5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 061/178] flexfiles/pNFS: update stats on NFS4ERR_DELAY for v4.1 DSes
Date: Tue,  8 Jul 2025 18:21:38 +0200
Message-ID: <20250708162238.273293702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e6909cafab686..df48074605967 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1129,6 +1129,8 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
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




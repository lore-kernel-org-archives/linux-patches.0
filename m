Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E15A2D3732;
	Tue, 15 Jul 2025 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586605; cv=none; b=KuaM2UJB8vP9KUeB7emVklD/gYaAlYeig6/uDd+gcxGMbNN+CFi48j76QSBRu6t4UqF9HXXsmrUFQLCl+El9z1PrMTqxsLVaFLtkblpPV3f8wTTQ4yy+Z9hBLnhVqPWMXRYfsqhwWaaC/ws609/0qlpS8ISIqGLkGuSoq5876Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586605; c=relaxed/simple;
	bh=veK55CD2mHbjSzHbWt2RlO0O0BugyCitpVHuvGtWpc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIDVk2KwC4qTfzKWxhWrc6fYAQzeqCyPHaIwPsn2dNXvEvI3XAV8Grs9Lk/UhOU3qX83QccvklBOKj9KN03TJrUOrS7JJAPZw098mOLlV1uVmsL0ffioglH2n9r8n8V81KneMxpsEHiBGTB3Nnu88Vd24HSB38j0a76EN8Vqs8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGMEPhH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGMEPhH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A532CC4CEE3;
	Tue, 15 Jul 2025 13:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586605;
	bh=veK55CD2mHbjSzHbWt2RlO0O0BugyCitpVHuvGtWpc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGMEPhH7o0dPdQavJcO2M7a351cLbybme7ijGPt1L/+PK8nG7Kd6Z8dOBaQgqT/zx
	 74NqXj+lxFmEAopXweLlL4D2SeOkzDaVV/lNYttM5APUh5VeaRjRO86Vodg3RotUj3
	 XRu3GFm3sWoecM9X0iqHzC2VIE2YMceQ9stUi8lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/148] flexfiles/pNFS: update stats on NFS4ERR_DELAY for v4.1 DSes
Date: Tue, 15 Jul 2025 15:14:10 +0200
Message-ID: <20250715130805.418713849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3b4f93dcf3239..87e8b869d9696 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1153,6 +1153,8 @@ static int ff_layout_async_handle_error_v4(struct rpc_task *task,
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




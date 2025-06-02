Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9222E22D785;
	Mon,  2 Jun 2025 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875919; cv=none; b=HBTM6fSf0GL7V4vIVxgEZeNACCieSeOkChmXfAIpAh3/uTao5RYuC/PfxNKF0T/dn1f9l/UbhUJObuuDDTW7Iciw+6gL0prszUbiaTGQD4DwnAS+EHYQsVtc84wtTjDwY/2xrN8+8AAWm/y5MoI52OIpvr5RS2/lKHnZb3THIxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875919; c=relaxed/simple;
	bh=jgYxxFcdotbLIKbF13G3eyt48C/L0DmcUyG+7EiQ/uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id1fBSpgjuquy98fX3pCElH+2n9NjPRaReqaxGsCB36bES+k5bSCQaH4OSPr7WRgir5IinRXsJARyTtF3LPrrw/TN2EpnMiTEQd47S/TCsJFvWOFXfOPku9PfaeYTVket3CL4Z/yznC3YIWk8hc9BxKb//sVx/vvzx6qS6cCFuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtqWFtUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtqWFtUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB48FC4CEEB;
	Mon,  2 Jun 2025 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875919;
	bh=jgYxxFcdotbLIKbF13G3eyt48C/L0DmcUyG+7EiQ/uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtqWFtUDGHfrfm700HlhhGDK5qC0N4QiTpu9CUQwXlyP6HtYGXOkEt6QbhuZPa0eh
	 pHQ07/k+m+Muk2i5Zx3ySO/JOo1aqT1oqMZLXyR+lWv32Ba26WXq+ZzzNEFF8RPeaz
	 dVqRJsbKho2uQiCyLdt9HuxyK9CNOjMhx0snh2a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/207] NFSv4: Treat ENETUNREACH errors as fatal for state recovery
Date: Mon,  2 Jun 2025 15:46:27 +0200
Message-ID: <20250602134259.371047234@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 0af5fb5ed3d2fd9e110c6112271f022b744a849a ]

If a containerised process is killed and causes an ENETUNREACH or
ENETDOWN error to be propagated to the state manager, then mark the
nfs_client as being dead so that we don't loop in functions that are
expecting recovery to succeed.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 76e2cdddf95c1..b1dec7a9bd723 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2726,7 +2726,15 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	pr_warn_ratelimited("NFS: state manager%s%s failed on NFSv4 server %s"
 			" with error %d\n", section_sep, section,
 			clp->cl_hostname, -status);
-	ssleep(1);
+	switch (status) {
+	case -ENETDOWN:
+	case -ENETUNREACH:
+		nfs_mark_client_ready(clp, -EIO);
+		break;
+	default:
+		ssleep(1);
+		break;
+	}
 out_drain:
 	memalloc_nofs_restore(memflags);
 	nfs4_end_drain_session(clp);
-- 
2.39.5




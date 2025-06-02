Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140AE21885A;
	Mon,  2 Jun 2025 14:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873150; cv=none; b=Mak5bvbX/APJChi6II4p8iDS+a3ftqLS5qdxyoPFMVxDUm9iVwg3J7lr2jLS17T0Pi4Z89+lRktLUU1EnKFfJkph6sC+EBB8Fi6twkw+Z4td+7li+xXSQLPHeaa7M//Nd14kSAhjHRR7gckcGUtBVCxl0hA5oS3d6wgFJ/MMr8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873150; c=relaxed/simple;
	bh=Ml0VFSeElR2L+a1Cyh9DcFZQ4FcMPaLgECQzh4vkyj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtfOr2ONQDbg8Y2MDjiRyTd6IoW8D4Vue/1VzIPtEyZ6ky801WHo26L5AxvXClNHbDvGFem2wUINrA6emtmZEQfoLQXWsIwnP4qVykrI9E4fdtEVQr77DDKIpybOKRo65fyJqqnpwELpEQj8hffwB6UDxl+IiAEjsXwlxTRjRHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7RFqcY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7RFqcY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99769C4CEEB;
	Mon,  2 Jun 2025 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873149;
	bh=Ml0VFSeElR2L+a1Cyh9DcFZQ4FcMPaLgECQzh4vkyj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7RFqcY0opo23dH+0edf7TOnXWm4QEIKJ5X3xHaaIeDSWsz4I/bjHYOojSNFFxYrH
	 1q6HqH4P13m5HzZXW733YyCTH5B9DKuiFizxvU++xXmSC1CUXOYvrzoBUjOVY1rz+R
	 +5tNpSgDMDGedooB2DJFXuEqjahpKXPIenLyzyF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/444] NFSv4: Treat ENETUNREACH errors as fatal for state recovery
Date: Mon,  2 Jun 2025 15:41:58 +0200
Message-ID: <20250602134343.120911621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 794bb4aa588d3..9fc71dc090c25 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2741,7 +2741,15 @@ static void nfs4_state_manager(struct nfs_client *clp)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788C22CCC0;
	Tue, 27 May 2025 16:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364485; cv=none; b=OyZR+I1ly7f8pnMwC8TzsM7MZms4IIB7X6IJ+Sk9NQMocmyaAnXj3BEM6slgpreLQQ8ywznDiuhVTKx7tu4asb82oRha7zuj5uvRJv20Vbo3eUnjQ3wwKeTnOJVktvTV7DgTPs7mm3hmOTe2c8UwnXR6CUrDWuLOFB749O37BNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364485; c=relaxed/simple;
	bh=/SWdvGClLseASs7DiIZ0a6j8uWDKPCscMw7gVVho/rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTE6640vrWNaPwvB8V4jILj9jXpihQzqGVrDKcB8Iao/pHNvu+x9yoi9jsyanclBEpMCe9FmCaX6hLTXqUEc77NUDUrNVDnN+URKcNLukQ0bmiuuupq3qAw26UfZZDq6T4FS3dAMuwPZJbFFVMSXT8BaO52T2EzXgS9Wy4tBM30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhDKhYYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhDKhYYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84237C4CEE9;
	Tue, 27 May 2025 16:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364484;
	bh=/SWdvGClLseASs7DiIZ0a6j8uWDKPCscMw7gVVho/rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhDKhYYQe5hNz2retDEZ2n0vrcUxHKvcTDQBTBwyYCyTYSqKTLqVb3etkvI6hfasQ
	 244z0DqSrktgcKnkPWf+CFPCHJzs9CTN8BSTrpUSZi5pgcmhFtqljp3AhRVaKbdF/m
	 FIphebl1ELQS2w2SqnIkKTvSm9IuGak4lme8pBZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/626] NFSv4: Treat ENETUNREACH errors as fatal for state recovery
Date: Tue, 27 May 2025 18:19:24 +0200
Message-ID: <20250527162447.936275781@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dafd61186557f..397a86011878f 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2740,7 +2740,15 @@ static void nfs4_state_manager(struct nfs_client *clp)
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




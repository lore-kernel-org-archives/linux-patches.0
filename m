Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDCE1586DB;
	Tue, 18 Jun 2024 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716258; cv=none; b=cxgFjPtPp4YTJy3serGkewQGfWLmxT9FxgOuEIZlmsMk3beKiRfxq7VlnSKOgZ8WplDOHQBSY0NXdcbHrIhdE6qe+59f0IRADy65cjV5LiV+aJw2bqou19G0yiLhzXYn0670p5tYMnXvef4vZBlFOAS3cmOveuKjB5y4rLUGfjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716258; c=relaxed/simple;
	bh=GOr2e7qgJS7uX0ZTpdGCoP3OIo2VJogkXsMzmlCP5ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbZe7hOVSOQxUuSstkcqesScX75kpQW6QyKFBDdqyd1rAlhTYmPU5ksm5E+DUgXMbgS85pjNj1+OsTthh9nEDbyGFxitdu286DEfPbCX8CEDD6AFrlUqjbHcSMA83Ih7LW809/alP6pwaQ4COO/idK0K5RzLrB2okBx6ygEdfKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjO3HtO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjO3HtO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3621C3277B;
	Tue, 18 Jun 2024 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716258;
	bh=GOr2e7qgJS7uX0ZTpdGCoP3OIo2VJogkXsMzmlCP5ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjO3HtO0ab04wcK3dxYGQXSNUZ1jnozPjqLkG1M/lMdpJ5VRwzlgWZCSheSqHtNli
	 tuiC6QO5G4kQifgHs4pTulZzWjwrcg4eh5FjiqFvO95xrIdHyS/02BR+N/QFST7JFn
	 6FjnumqlZPtAE6N5p9LPaSkfDmIYLQBFvScRNTfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 554/770] NFSD: Demote a WARN to a pr_warn()
Date: Tue, 18 Jun 2024 14:36:47 +0200
Message-ID: <20240618123428.686723324@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ca3f9acb6d3faf78da2b63324f7c737dbddf7f69 ]

The call trace doesn't add much value, but it sure is noisy.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index cb4a037266709..08c2eaca4f24e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -630,9 +630,9 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	}
 
 	status = nfsd4_process_open2(rqstp, resfh, open);
-	WARN(status && open->op_created,
-	     "nfsd4_process_open2 failed to open newly-created file! status=%u\n",
-	     be32_to_cpu(status));
+	if (status && open->op_created)
+		pr_warn("nfsd4_process_open2 failed to open newly-created file: status=%u\n",
+			be32_to_cpu(status));
 	if (reclaim && !status)
 		nn->somebody_reclaimed = true;
 out:
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85447260569;
	Tue, 30 Sep 2025 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244038; cv=none; b=g68M1rUZeN2Uh43LxDt9fvsdu/A15JitGW6YArmvNf+5/xK39Ou3bXnUYrijKskt6I6BoAtRdfJi42/5rFNzL3Xx3uqQqMz67U458kWK88vXcJ6IIbjiZ99yHxUZtHin0ZtU40gXVemvdTkGlMu8azc5RGCvGH1UoM3CI30k6BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244038; c=relaxed/simple;
	bh=JIqyHYtVRnyw7AAY1dJSewte4PQGOO+Jk+SnO2SZzEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6nr5/BHUrOFOiGd044cZZI5h6Xklib65YE8GhVQjy+ZLlpFf3gAfrzWLcwceEcwD7k3B3s1KFJ+yXLU99jGEDXi8GMrQL5+gL98ZDzKY2PGPPq3fRT7Sr4pmcV86BrGe/aQH73bGdmzZJgoyiUd01akZi4b5NxduRCn3SgWO4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yakPw515; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yakPw515"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E886DC4CEF0;
	Tue, 30 Sep 2025 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244038;
	bh=JIqyHYtVRnyw7AAY1dJSewte4PQGOO+Jk+SnO2SZzEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yakPw515U0bVaYZEDrhkY2uJroJhINTJBxwjMsc/Ve5j73jbPA+EnBDIeYM1h7sYm
	 ytUnGbK0iv9OtzeuXQy74gJqcVpPaLgeZ+XVyjNYZrS5Egc3TCuh2aZdTcIReIquAG
	 4iYAfxdSLDEBMmHUX6o07sDPoxHT0gRgdLlspQQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/122] NFSv4/flexfiles: Fix layout merge mirror check.
Date: Tue, 30 Sep 2025 16:45:41 +0200
Message-ID: <20250930143823.400347939@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jonathan Curley <jcurley@purestorage.com>

[ Upstream commit dd2fa82473453661d12723c46c9f43d9876a7efd ]

Typo in ff_lseg_match_mirrors makes the diff ineffective. This results
in merge happening all the time. Merge happening all the time is
problematic because it marks lsegs invalid. Marking lsegs invalid
causes all outstanding IO to get restarted with EAGAIN and connections
to get closed.

Closing connections constantly triggers race conditions in the RDMA
implementation...

Fixes: 660d1eb22301c ("pNFS/flexfile: Don't merge layout segments if the mirrors don't match")
Signed-off-by: Jonathan Curley <jcurley@purestorage.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 43aefff2e6b06..ee103cde19cdf 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -270,7 +270,7 @@ ff_lseg_match_mirrors(struct pnfs_layout_segment *l1,
 		struct pnfs_layout_segment *l2)
 {
 	const struct nfs4_ff_layout_segment *fl1 = FF_LAYOUT_LSEG(l1);
-	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l1);
+	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l2);
 	u32 i;
 
 	if (fl1->mirror_array_cnt != fl2->mirror_array_cnt)
-- 
2.51.0




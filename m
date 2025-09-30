Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1582236EB;
	Tue, 30 Sep 2025 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244935; cv=none; b=TSQ6Rn9+LJM/SSAMqStW6iLHyzzLA9Lwr8UQTdOnyiftNoDsgA2aP3B/WX4l7/0l3qucQFQVGLJNzjiptX7G95FQ8IJAUYNYFOQmv5UXvbyMtToRa+eeLM0ZkLXyzLe4opKt2xVBTar2Od8Jk5Dlymg4Y1LhbwMGEhWfKTli99o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244935; c=relaxed/simple;
	bh=YxjJaN91RSpHYbtycnBbaCvxaqzuRUCfDopgCeWv6Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQR9gZg6EJzGFiaSaTyhITXPgusxLqHgWOL8bF6p1tM3vzHWcT7ZnxF9PuyvieRvQRwWHlwFiF44rFLoKFZufH7s7ZVFB/GzQ9zA56qIMF1HO5Z2AW577pKia6iMAaVRRXzs7LnGvs7PYxp1Kied12rumx+h+29qSzZrCuI5M3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1D6OHiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1D6OHiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD53C4CEF0;
	Tue, 30 Sep 2025 15:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244935;
	bh=YxjJaN91RSpHYbtycnBbaCvxaqzuRUCfDopgCeWv6Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1D6OHiJZEfthXABAnikfYvGgWJ6dNziegIVndnNOspHSwfn9vC2C6EVViRbXPvyZ
	 3LZwOaN2Etb2WpW4gfTJ8pnBlBrkLdLPYvPTAcEzym+mzdEqsx0oyZ5cEZAdtanBf7
	 c4Gq4RArAklKc8QPQ5W+407MPEpwGdlFTE1VfaSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/151] NFSv4/flexfiles: Fix layout merge mirror check.
Date: Tue, 30 Sep 2025 16:45:45 +0200
Message-ID: <20250930143828.212107318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 798e2e32b3fb6..24d97d7ba12d5 100644
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




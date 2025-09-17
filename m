Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E857B36D;
	Wed, 17 Sep 2025 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112650; cv=none; b=SvMPw8SIy6URdsch1tWMqrgnZFKub6i6Un/GZVcPd2OduET+ocAfsRdnuSpDB1AeDfF3jVkwJtM+Dg+jTKWdQqwpcKCtL/qUuTAUCSCRpYLbcr18lxGHVex7/yuB1mVDzlQNO63iHYpC7bCD0Uf9CGPXVQgx/cZcwBMpcGgDtXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112650; c=relaxed/simple;
	bh=gRrzOyi+cU45DUHMCP0ImBtgf32vkkVzDkUistEFcAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrJalcDSC/cQK4Ge6t62gyRGWKC35URL/HmLh1QeKv9n5HlHGAXDfJ09FgmFsIvpxdaGS/VQWFxPw2hx24nrRmmaeH7E2FJtH6nT2GwNcitHMpooHzbcvO0kRUYHXeHZ93RL57A1WUKeWaQ8Ge2YntjLzTAnPI3V9zI/9yIQoSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sr9/4E5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sr9/4E5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08693C4CEF0;
	Wed, 17 Sep 2025 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112648;
	bh=gRrzOyi+cU45DUHMCP0ImBtgf32vkkVzDkUistEFcAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sr9/4E5e0+Gy/QUs0+rmilZdXM2l96pFzZAo3doG7uw+O1H+dRa/QWCYm8I7PNhLA
	 xSgWjxI6WR2IF2Mlu1SRLwqZCcGsrZxD5cuksR8C9PQ3rB0GeLGghAc4+bffUxoNwn
	 QUxfC3qUkd0pQLmE3atT5YNlQa/aUOewNNjU52qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 034/189] NFSv4/flexfiles: Fix layout merge mirror check.
Date: Wed, 17 Sep 2025 14:32:24 +0200
Message-ID: <20250917123352.690637541@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f8ab7b4e09e7e..9edb5f9b0c4e4 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -293,7 +293,7 @@ ff_lseg_match_mirrors(struct pnfs_layout_segment *l1,
 		struct pnfs_layout_segment *l2)
 {
 	const struct nfs4_ff_layout_segment *fl1 = FF_LAYOUT_LSEG(l1);
-	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l1);
+	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l2);
 	u32 i;
 
 	if (fl1->mirror_array_cnt != fl2->mirror_array_cnt)
-- 
2.51.0




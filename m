Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125D54E0B79;
	Thu, 17 Sep 2026 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667683; cv=none; b=nbgbG5pM5Q39AbkHFc0SlXeuEVUcbpuzdSyZKbtIdBKp3DKZw2B+AegdS8egU9Gle3kEpvsLB4H/AEu/kFFLXtHe1XCdRs3+3IwRD4Ml8A3SW16duBKDmIOrKESw3fvFlaTrpIyFLCNbGzB3mWYNtuhyOXwinp67sjqRtiBGt4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667683; c=relaxed/simple;
	bh=GXkPfMyE24Owbce98PUL/f2mPKsvQBwXpdb8AtoIndo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3kXtSENGms2NTQs4bFoUz75GseV283+x5ByGRtnO1jJHuPGL9ZS17275rFZA2RV0vEETrOGpiNf+60fXo7DkTr+/GvhJOGLIxhvE0C5KlVG0gXWBUXywQA0kaj941ZyHS7TE8CAvSCjF7cyvdmH7ZOBVHNcPTXyYaC2iA5mOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nU232aHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nU232aHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F761F00893;
	Thu, 17 Sep 2026 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667682;
	bh=FezAdlGL4PQ/0QwezEdBwk/Roim35DRtH1vgb64QJhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nU232aHU9IfvGFVhX5Dv2vQMXKLGsLzv88j+oG3NRFPyAcrveZOE0O+gJipwyvf5f
	 CUfBp2NvPHYoPtfelZ6+ButxKXOSJtv5TNsajApPO8oz8XhZEEHDESH2L56K437JzF
	 WGZ+3ZUWU8plJdF6eUVPU2tj+2yabVqE6hnPbZx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0126/1102] jfs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 16:01:09 +0100
Message-ID: <20260917151542.676817521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 05107f5602751fcfd3d108c1f579eb45aabead52 ]

jfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-5-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index e1be21ca5d6ef..882917cc3af3b 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -524,7 +524,8 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	/*
 	 * Initialize blocksize to 4K.
 	 */
-	sb_set_blocksize(sb, PSIZE);
+	if (!sb_set_blocksize(sb, PSIZE))
+		goto out_unload;
 
 	/*
 	 * Set method vectors.
-- 
2.53.0




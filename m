Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6230B1F1313;
	Mon, 13 Oct 2025 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369379; cv=none; b=ZxEjdaUDOVnzQ8lrgFoQaArzoOXG5s2PAVaiN10s9JF4RdDTV80BPjEINzXgWPflvoxjNrUoJm8Z2jq3CVuqqdxsZRIviQrWwWtyaLWZpJm/vgswMoG6i3vRIokyED33Qnd17TvrXrrnCj9tWxLYTuf8kBn41KFoQ0Y8jOhZW50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369379; c=relaxed/simple;
	bh=trki4HoO2/2grsRiEiyigVekJTmhCsVP22jms6ynXJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y01RjfLwm6DdAiCUEGgcRolgbRQ7dH3k26Vp9xqs/PbopQZ1+boCCAUn1FLup75623UL9y/e+jVB/AvlamD+poI2mGDErenu0wBVdkw1e+jNpiQmrtqhtf5W6AQYvIiM6pGXAHzk+BAsoJ/hTrQ36B8DUyuJefqClEy+P6JLJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6lhhqKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6lhhqKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E112CC4CEE7;
	Mon, 13 Oct 2025 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369379;
	bh=trki4HoO2/2grsRiEiyigVekJTmhCsVP22jms6ynXJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6lhhqKt6KextZwBGCz284BtRvaixPhb+V+T1du0iHSFVDYic6awX7PK6w2b/u+Io
	 klfolk8d0sLEfau0Pl1eEurXRMb6Pnrlc7pVK/JdTKS6K4ZrfZJnukg1CPVkz/nyOV
	 U1uoo9MONgyIsZGLtFxGkEIZmjPWvTsvfYvUWWAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 225/563] f2fs: fix to avoid overflow while left shift operation
Date: Mon, 13 Oct 2025 16:41:26 +0200
Message-ID: <20251013144419.432543031@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0fe1c6bec54ea68ed8c987b3890f2296364e77bb ]

Should cast type of folio->index from pgoff_t to loff_t to avoid overflow
while left shift operation.

Fixes: 3265d3db1f16 ("f2fs: support partial truncation on compressed inode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 5c1f47e45dab4..6cd8902849cf6 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1245,7 +1245,7 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 
 		for (i = cluster_size - 1; i >= 0; i--) {
 			struct folio *folio = page_folio(rpages[i]);
-			loff_t start = folio->index << PAGE_SHIFT;
+			loff_t start = (loff_t)folio->index << PAGE_SHIFT;
 
 			if (from <= start) {
 				folio_zero_segment(folio, 0, folio_size(folio));
-- 
2.51.0




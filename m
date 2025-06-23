Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16DE19E7F9;
	Mon, 23 Jun 2025 22:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717095; cv=none; b=i//qjIngeWjnUYNR2c3JyqZRlWGx/4hZP1l3oQhYeT306DXWx3wBfKMfav3i/yQfLWOVRac+UqfA4zUdrbvW2Z1x1vGEzBRe005qInCBKMPrLeeVueVLG94DmFztS2j6R7jXGJa8IXDqcPknPq3TNExre9pIt8EDhRyjHR6jmKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717095; c=relaxed/simple;
	bh=kNB2OjORJixXfLkCjQ1S5T+51+mPJN1SaskpeV4ejTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8GozTH2FXNPBErLVsD7eq6SBuue7K7Zwbo3y/j9tx5htDfznVIMyS9Z07VCNmPk1FFo+Ej+SUGrgz7YdFLm2Nxs1ZgGgm3Uv8x0tGgonSdp3GaPpBMDcMRf1GyOUfEkRDjEHReq6AHw+cA+aCwbII5gpUa/BA9XKwhpwFDC1Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtBmID5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtBmID5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020FEC4CEEA;
	Mon, 23 Jun 2025 22:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717094;
	bh=kNB2OjORJixXfLkCjQ1S5T+51+mPJN1SaskpeV4ejTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtBmID5UIKAAKtxNZSCTPG18HdUKAWtzXJmF0ei5nV1/7oIx/whoUEes7nv8+z/p5
	 u9ZVgHJI9jP+Pn1PDQMmibmrbQnQA+B87cRjh9t1KU1dzW07Fj5Q6KPEsunE8CdwPN
	 R6tYZoRj3DHrkacR/yhk2p9qnhwdTxhXOWUBOTo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 592/592] erofs: remove a superfluous check for encoded extents
Date: Mon, 23 Jun 2025 15:09:10 +0200
Message-ID: <20250623130714.514048875@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 417b8af2e30d7f131682a893ad79c506fd39c624 ]

It is possible when an inode is split into segments for multi-threaded
compression, and the tail extent of a segment could also be small.

Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250620153108.1368029-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 6afcb054780d4..0bebc6e3a4d7d 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -639,12 +639,6 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 		}
 	}
 	map->m_llen = lend - map->m_la;
-	if (!last && map->m_llen < sb->s_blocksize) {
-		erofs_err(sb, "extent too small %llu @ offset %llu of nid %llu",
-			  map->m_llen, map->m_la, vi->nid);
-		DBG_BUGON(1);
-		return -EFSCORRUPTED;
-	}
 	return 0;
 }
 
-- 
2.39.5




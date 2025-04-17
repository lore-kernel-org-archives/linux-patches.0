Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6608D1DE3A8;
	Thu, 17 Apr 2025 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912998; cv=none; b=mtKQA2gELVrfq0mbcn2I3TMa/oLIpd5N9Ukmhz+/AkSVYRJEAP3/2DzLww3LdFNaMvhJDm0tjCQEzE8QvajBNWt2IMBJNV67Sx50zrsKqufU3o4i6GMuHtkg7oWJRDQLlkkAnXePAy5Q2onpx1cRmZ7hWtIOC9D4Gexr4v7aSi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912998; c=relaxed/simple;
	bh=l0U5HaVcMbWbgzrO52W6OdsrrqQADDEA/IA/3dJwCPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjVUAYU+ZaU2sK4IO2hXku3w4eHt2ceIegz1OHWTYF6bZnIe9OPIqSKlS0jJOxP50ybFeMtLrvAlOyry3AwdT9/TR4rIbrWv7nqqx2jlhn2SE7ru1oLmegqFjYc5cH/cHQd+O34iQrbUyLAaOvbQwu1q89YEVqllEFOmvnUKdy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCRL1uey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCRL1uey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DA4C4CEE4;
	Thu, 17 Apr 2025 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912998;
	bh=l0U5HaVcMbWbgzrO52W6OdsrrqQADDEA/IA/3dJwCPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCRL1uey1m1Pm0irPoERKRq/DASCK1SPu3Xnu1nLYQgamOiCaX0vfbMM96Bjo+wQh
	 8A7tcjcN0wACNPX2MJm926jucY+5ee6Gf/fykGuPNAZm64I0YpqNH9+Ylr2Ej2CxI0
	 pPvptNNGVf+GgFhcV3/qU4fDMApU6B1PPc3bh4YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 192/449] erofs: set error to bio if file-backed IO fails
Date: Thu, 17 Apr 2025 19:48:00 +0200
Message-ID: <20250417175125.702364389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng Yong <shengyong1@xiaomi.com>

[ Upstream commit 1595f15391b81815e4ef91c339991913d556c1b6 ]

If a file-backed IO fails before submitting the bio to the lower
filesystem, an error is returned, but the bio->bi_status is not
marked as an error. However, the error information should be passed
to the end_io handler. Otherwise, the IO request will be treated as
successful.

Fixes: 283213718f5d ("erofs: support compressed inodes for fileio")
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250408122351.2104507-1-shengyong1@xiaomi.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/fileio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/erofs/fileio.c b/fs/erofs/fileio.c
index 0ffd1c63beeb9..abb9c6d3b1aa2 100644
--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -32,6 +32,8 @@ static void erofs_fileio_ki_complete(struct kiocb *iocb, long ret)
 		ret = 0;
 	}
 	if (rq->bio.bi_end_io) {
+		if (ret < 0 && !rq->bio.bi_status)
+			rq->bio.bi_status = errno_to_blk_status(ret);
 		rq->bio.bi_end_io(&rq->bio);
 	} else {
 		bio_for_each_folio_all(fi, &rq->bio) {
-- 
2.39.5




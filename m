Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C1257AE7;
	Thu, 17 Apr 2025 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914298; cv=none; b=Bf0Iw4Kd+XUv5gqR5IPYKVBcLAJgPPDm+1B2V0Gxg4ooXETMrhp+l63lRagGDqlA+pxksMIFK6c48xPRRN3nkzGt7OLmZfYThmJ82s0twYivgtoTdKMXuNQDwe6j0VYTY19sbMTbU0NDcd37K0RYztdg4Q2KMUiL6w6ZVH/d9O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914298; c=relaxed/simple;
	bh=xoe8twiu3Ai/vhawVZgcQHHK/+dpC19k2/6EJLcmgao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4hGiLEWXXF5cx98Cp3933d7sYGmy0OBLNf65S3ohWTZlVTvDrfnkNiHzuVRjmy5pz8OYUfUAGUwu98TqWu9AJFhAz9D/mwOQhSJARQqva3kxC/xr6zlnUtg97AhAs+ExbUPYCghairYJEJxYWXtu2CnpQ/r2ra/1WqVy+soEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0aUdFi1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0aUdFi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FACC4CEE7;
	Thu, 17 Apr 2025 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914297;
	bh=xoe8twiu3Ai/vhawVZgcQHHK/+dpC19k2/6EJLcmgao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0aUdFi1IrOZ3zMmMknOxzIXIx5XArCI7k1+j8eicp9uvbJUNJjRTDFJNSg9lerB6
	 mwFy3dR+3xeQl81b9qgVnBwWQYbt5y+E1FBXIyuG4IUuZq/ORitMLPxSOdLV7NhMs1
	 +o/gp2LzToQBHdMzUgAY5kCx1V5XoKN0V+uGrrgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 170/414] erofs: set error to bio if file-backed IO fails
Date: Thu, 17 Apr 2025 19:48:48 +0200
Message-ID: <20250417175118.277654833@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 33f8539dda4ae..17aed5f6c5490 100644
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




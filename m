Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8934502F;
	Thu, 17 Apr 2025 18:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915640; cv=none; b=MnrWDBddK6aFiLy8bPimF/ICmTztElr92frhWSqlu2rK3uZYk9vsLBy3TUrzBuWV5RtDRCsQ+mi4zSh+2A95hCAkfv2DMh8JYGXcL+1+LbRejHBOUMaQIEU5ziR2YVMa3snIwl/eFefiT1qH5LNlH0CC6oKCbUmcswLORI0FccY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915640; c=relaxed/simple;
	bh=K0/FNiQOntUaiNQKWh9BxBBv64HlggbfHBnQktECV5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABxQPB8cRcMUk9igdgVqsxUik9QbIRuOBiTcjpJdMNMObsTI5jojpUVFn0HsMEZhLJ8g/h76GXeUJimNF0eHZL3YnWO7bbxsK0m6pJE7ZZdU6OOEBTEIgR/3GIWOKC8LnmpiwLL++Z4nxK4AgaDFZJtTXWCEk49lo1HXoyZnTYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0ct1hkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0ct1hkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC93C4CEE7;
	Thu, 17 Apr 2025 18:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915640;
	bh=K0/FNiQOntUaiNQKWh9BxBBv64HlggbfHBnQktECV5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0ct1hkZAZZj6NE6lNpyr9+KWJoSnA7i2oqX/hmeKn00ZzY+c1DZC5C55cLvrSv6a
	 85ih7kRfQ+mkxKD6lF9UtE78/okkeohCZvEAEtw19p3tBoYGOxhv+UcTcKnXezfv7k
	 xCg0mKZrkIO7yeGXKuWF4ELob+Ln7jCAXVWNuY34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/393] erofs: set error to bio if file-backed IO fails
Date: Thu, 17 Apr 2025 19:49:31 +0200
Message-ID: <20250417175114.095747922@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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




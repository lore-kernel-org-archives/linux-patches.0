Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFAB3DB313;
	Sat, 12 Sep 2026 10:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208752; cv=none; b=OqqZK89aPtUZgXKJpVPz6S+zahLSHozq53lnOP0s394JyA7eFaVtOcYCyiID+Q8twPQEW4pyj/z076A0gY1Z0NZLSh45w/NauCIE9ZbWjHm3cT7De5YswM+9ERNpbmrQ9qtruHOFMK1OS9gfeTd9qSerMKSHfGL+UYaXhRYW0XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208752; c=relaxed/simple;
	bh=irmESnpeKJdCgqQMbZgIqvPQYIfkrjyLE02n+uyEJ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKRsogLoO6BTyc6GVOWUABePzt8WmGbaGKtQYvvWApUd/QuurnKdWV6OiKGDMi5GRDIE6SMt/oW0W5WSKE0qc26+4TwdK4WonLjgfvXjxHk9IX50wPiS2+OkWzQtz17PXpysB5mafMEOV17FgXmXDx0Jdj1WS4ui9jFrDgk4NIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHvmzQ48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHvmzQ48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030261F000FF;
	Sat, 12 Sep 2026 10:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208750;
	bh=xrklh0gXHJ3Vu0NiAdZTlmAo9Huyk/f6Rpn4oXIT3iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHvmzQ48MYiFHx1jy+UwSJqLayAcn8NXPbVfH5TK8kgW/X3oK/5WGe718bi//gS5i
	 dZ5PA4YFJF9falnkcq1sdO06f0yCye9qCHQ79fb0YyBn1NHdM37TKPpXHkb0KLnNs7
	 hs7zM2TynAyClphmj3pZKl9Fq42RrjK9EYIdRRbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0680/1518] block: fix dio leak on metadata mapping error
Date: Sat, 12 Sep 2026 08:47:29 +0200
Message-ID: <20260912065638.816511959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 702a2a9f3dfe066a7481698c858371112f3cb697 ]

A failed integrity mapping holds a dio reference, so we need to go
through the full bio ending in case there were previously submitted
bio's in the sequence.

Fixes: 2729a60bbfb92 ("block: don't silently ignore metadata for sync read/write")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://patch.msgid.link/20260720201057.1862857-3-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 56ade36fb6564..bbc89773e07f8 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -241,8 +241,10 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		}
 		if (iocb->ki_flags & IOCB_HAS_METADATA) {
 			ret = bio_integrity_map_iter(bio, iocb->private);
-			if (unlikely(ret))
-				goto fail;
+			if (unlikely(ret)) {
+				bio_endio_status(bio, errno_to_blk_status(ret));
+				break;
+			}
 		}
 
 		if (is_read) {
-- 
2.53.0




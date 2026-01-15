Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B111C29B200;
	Thu, 15 Jan 2026 17:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497509; cv=none; b=Ad6SHpudspJ+YaMWFxENzevj7o+c+OdK8u20Hban+D54W4i4sJobODd60BQgKGKhvXQVRTIXRKMYqacapFyMYSPXzSGm1lLJH2tzzdgcebMS/8/2vZJ7e6/2rYFNkCa+U5AXQCerTRdLdmjvlkuQlNJJvHAnyosiR0EBqqU3W9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497509; c=relaxed/simple;
	bh=kDK8eO9TjwseFz0buQhaim4IKEEbz+jstV4ItIKzh9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zm7LCQkil2U1Wz7wtGxxIyOTW9dvdudhkRNUvppd/KoRpA4fGSSPd25ey3jWiSsEkauWlicO9zEF0TgjpwUR4L4N8vYOe+JF0tHJWMhWik9DlLYehpTIunREvw4y0tgTXSZMTZ0+mhyk4lKDQ91CNr6NsyO+kKbEXQHAn0hY/7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBxLl0bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBxLl0bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD52C116D0;
	Thu, 15 Jan 2026 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497509;
	bh=kDK8eO9TjwseFz0buQhaim4IKEEbz+jstV4ItIKzh9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBxLl0bcLzQ7VXfG0gBDmLMMjvtJ48Et1Jjm+5MAhPqvYGFsMtY1MG7fE+vgPbYzV
	 GXi1npzOQddT+eqy9oVAi/odSJwukEA/rihfBPAXgSs382DQm7G3z2aoH8vdqE3pf2
	 PaRajkCpbyWEBjtk2oNWaBzvGQMxYAK+/B7KrxJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/554] ps3disk: use memcpy_{from,to}_bvec index
Date: Thu, 15 Jan 2026 17:42:53 +0100
Message-ID: <20260115164250.127515356@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rene Rebe <rene@exactco.de>

[ Upstream commit 79bd8c9814a273fa7ba43399e1c07adec3fc95db ]

With 6e0a48552b8c (ps3disk: use memcpy_{from,to}_bvec) converting
ps3disk to new bvec helpers, incrementing the offset was accidently
lost, corrupting consecutive buffers. Restore index for non-corrupted
data transfers.

Fixes: 6e0a48552b8c (ps3disk: use memcpy_{from,to}_bvec)
Signed-off-by: René Rebe <rene@exactco.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ps3disk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 8d51efbe045dd..8628ee818da96 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -85,10 +85,14 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 	struct bio_vec bvec;
 
 	rq_for_each_segment(bvec, req, iter) {
+		dev_dbg(&dev->sbd.core, "%s:%u: %u sectors from %llu\n",
+			__func__, __LINE__, bio_sectors(iter.bio),
+			iter.bio->bi_iter.bi_sector);
 		if (gather)
 			memcpy_from_bvec(dev->bounce_buf + offset, &bvec);
 		else
 			memcpy_to_bvec(&bvec, dev->bounce_buf + offset);
+		offset += bvec.bv_len;
 	}
 }
 
-- 
2.51.0




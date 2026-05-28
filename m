Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A874335566;
	Thu, 28 May 2026 20:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998725; cv=none; b=REnFpR2vjyE+x4S5zo97wBdJgmp9wkrYAI2JIDNtza4MKZmyNSHx2ABwt1mrRNkQPTI1kSdOh1HOjdEPQfxUvO7o9X7W/oUzmc+/6PIdtUCqscr79vhAkHVkQ4+WvT2U3+g+I60Eh9HajugDSvlOvERd17rTqxR8B0MUuirOuVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998725; c=relaxed/simple;
	bh=NFIJUBc4eedlMiYIl5e1/mezRUrYjkHts4dMkVPPF5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDdWreug9t5y1715i8KC9piiOlQ7hRpIn03bR2SipbtFVFRM7R9fomKwgcj1rCFg/L5PU00ZtGX8zgGzrfEryjC+5gBi8RtCk63uAa2dJZyVXekDGMsYlCkUF8xe/PXs5xAVAViQxAqWwBm08ieoUbSpF8c5l0P+Xo5LWUVFdVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=silzhlsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="silzhlsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F041F000E9;
	Thu, 28 May 2026 20:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998723;
	bh=rZKzpfzk1lA0Zf7xDLM/LrUZqWUewGUjzjDrk7gNllY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=silzhlsaegpB49KCH34KCvfEwogHKNjTaXP+QL2aCbw7k0TXwOgGGHqhlS9aWhmsQ
	 WIZQ2b2KGscogozLrcDbtCM0poUNsW/qOFPJVVl0HTbhwCsGPDVUszMV+cki6AqLIO
	 4A+rtd6c1jG+gBDYlDOwutrqVOd8/FVCaZfSdOp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 239/461] ublk: reject max_sectors smaller than PAGE_SECTORS in parameter validation
Date: Thu, 28 May 2026 21:46:08 +0200
Message-ID: <20260528194654.062260909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit 1860c2f85922917d8a46f16a6f4bd2298ffa0fb5 ]

blk_validate_limits() requires max_hw_sectors >= PAGE_SECTORS and fires
a WARN_ON_ONCE if this invariant is violated. ublk_validate_params()
only checked the upper bound of max_sectors against max_io_buf_bytes,
allowing userspace to pass small values (including zero) that trigger
the warning when blk_mq_alloc_disk() is called from
ublk_ctrl_start_dev().

Before 494ea040bcb5, ublk used blk_queue_max_hw_sectors() which silently
clamped small values up to PAGE_SECTORS. The conversion to passing
queue_limits directly to blk_mq_alloc_disk() lost that clamping and now
hits blk_validate_limits()'s WARN_ON_ONCE instead.

Validate that max_sectors is at least PAGE_SECTORS in
ublk_validate_params() so invalid values are rejected early with
-EINVAL instead of reaching the block layer.

Fixes: 494ea040bcb5 ("ublk: pass queue_limits to blk_mq_alloc_disk")
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260510144843.769031-1-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0bdb804fca839..e5f4942d99113 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -868,6 +868,9 @@ static int ublk_validate_params(const struct ublk_device *ub)
 		if (p->max_sectors > (ub->dev_info.max_io_buf_bytes >> 9))
 			return -EINVAL;
 
+		if (p->max_sectors < PAGE_SECTORS)
+			return -EINVAL;
+
 		if (ublk_dev_is_zoned(ub) && !p->chunk_sectors)
 			return -EINVAL;
 	} else
-- 
2.53.0




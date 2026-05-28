Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539C435202A;
	Thu, 28 May 2026 20:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999882; cv=none; b=MgYeAonoOoAkDiwKk3vWgYKPwBqs5ks2tXvwlqkL/3DJEbvIHeazzIe7AQTpYHNjV8x9YrpvTCM8nUBXsweEUK2LTziENlgGRVOxGbLvll7NENvQaVoHhe/3XQHTDZPo9LKCvnTd/EcYvGt9+ClQKjATskj/aGImPKCtt//c1I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999882; c=relaxed/simple;
	bh=gaZwI6YhgHK3XtA5kPyrrlRSyYb2PyMjVeRrZpff+SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSU2HHtM95aFV5RK0SNj58pAsoePJu3xGpjQtdJYkHiEgDyrCs4r54FuFYdG78lIP0Ohk5fwrEdVl3bHUUHuWE+fBzAFGbYvfqHj4myF7p2+7zL9aLCvE9QUxAh9+y0OwIplLkkj6EJ1z5DxsrTHgsLaxhnxSDQNJRyRvA1ZKos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uYXLW9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uYXLW9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A271F000E9;
	Thu, 28 May 2026 20:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999880;
	bh=4OJ75DmXJDUlLhIuIXip3xKOGGU+qlbKB8H/i3IiIb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uYXLW9kpaJ/dX38xBSfM615uTkbCxpM+LHr3i1C0qBJb4rMu/L12SaWtOMOUvNos
	 qcirSwUzKkSjS4Zc45EOmlSBZG2J9xz9b8FzkCK9TKFqgsja2BfXbHQYdqzF3ZTaUQ
	 5CLoytbmnwd2u5ow6jmFi7pSPDFV//2B+g82gdkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/377] ublk: reject max_sectors smaller than PAGE_SECTORS in parameter validation
Date: Thu, 28 May 2026 21:47:41 +0200
Message-ID: <20260528194644.848695206@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 2729b1556e810..c339222513b03 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -601,6 +601,9 @@ static int ublk_validate_params(const struct ublk_device *ub)
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




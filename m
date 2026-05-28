Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CA72139C9;
	Thu, 28 May 2026 20:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000829; cv=none; b=fTAkUc1RZvP7zQC5RrTDCS+XKrbUXE2hvYh/Z2k/yw4H5AzvjIS8PI6OPCZ7+Kixe0DPavvMQ24CrlGqhgdpSQmxCuZ7w934pISzydVCYZHiMpwvvTzx0Fv5aRSY9D7Oc8rzIiqcwxYSanJvd1X6oV1vbIEVfrxkdBK44RVEMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000829; c=relaxed/simple;
	bh=SvM4YBBbp9s1OyU+eFahcqXiB25WAhm2loY00+bURtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fy8Uiy3PBzP8Qq8yIIJPGJ/pI7cEalE1HXl5h0Bu8SzpJNhFuOzVO18bqGyCCRwPdN1igF0AgV5Ta4x89PhVyJoofXAl91uR8fGi8K0tDPKUvcSsoWDzYkUQBTGzu5bMbju5Zz/IqN/8fbLLUXu7ZL1Tp0btRuPdGf+K5JSzQbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o623QgaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o623QgaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A8A1F000E9;
	Thu, 28 May 2026 20:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000828;
	bh=DEP58uZW6mN+HNciF2K8yVACdlPWciCFLgQWWdLQWN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o623QgaOmYJ1kkYVwsVQOEz/vpd/FwQ6wePfb748bLh6z86BHDTmfgodvj0YARrEq
	 SGGmkk0uFOUWH52F88lZtnMFfpfBzHQvptVEQfAFClYEpTDSIbAiDS5l6gcuA2/EfI
	 Gn2Ol8MxkRwgfKVPUc3dI7jUxBCSsEnyXAJFpHzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/272] ublk: reject max_sectors smaller than PAGE_SECTORS in parameter validation
Date: Thu, 28 May 2026 21:49:18 +0200
Message-ID: <20260528194634.439857289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
index c6a59f02944fc..6854b847bccef 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -540,6 +540,9 @@ static int ublk_validate_params(const struct ublk_device *ub)
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




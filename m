Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A9A196C7C;
	Thu,  6 Jun 2024 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683071; cv=none; b=fZNpakyoO11+uL0Eh2jKIGKWJuTlW822yanlJI52hJ4bkuMhH7rfWtZ74vIMGdomGEduVl5532Q9bJ9VT+YDCKUfW+jZy1m4/8TfFn0stoCz4F43IU7LkMq0K+HfXxowUtZYNED4YQEUeLDwr5PCVM2Dum/4QKxqFKhj38h5xYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683071; c=relaxed/simple;
	bh=JMinxdTLhVAEoT3EVvbMY7NPCxwzvV2NIFfjU54ufgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uL4D20ElF/WNZxj2aHJ/03c8bP1UFnH7IkDm64pQ7/IDZGaxLROzuhBL+c3aU8Ry9sskIHqqu/RwmItB6MbO2Y/N5C31rJXhAv9+0ynErihTdlMC5272IQyahyjC11o+hnI0qc70cyH2uL1udmtgkaFcSN7tMteoV+fSs7+PgQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMBi84SN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMBi84SN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A228C32781;
	Thu,  6 Jun 2024 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683071;
	bh=JMinxdTLhVAEoT3EVvbMY7NPCxwzvV2NIFfjU54ufgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMBi84SN0KYYgXi51JKXLAyINfReH522PAw9N8ABe1cIsFU4bI7LrzepCzFnGn/HM
	 TclnC/sH8rfRlXgvdv7Ba9wPmyUm62PaJlv3+KxnX+UCnEAshWXE5gYp7nA+YvzKs3
	 wmxSWOJkEIxbO3uCRM9yT3sgEpx0tOlTcSELmaF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 316/374] null_blk: Fix return value of nullb_device_power_store()
Date: Thu,  6 Jun 2024 16:04:55 +0200
Message-ID: <20240606131702.460522058@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit d9ff882b54f99f96787fa3df7cd938966843c418 ]

When powering on a null_blk device that is not already on, the return
value ret that is initialized to be count is reused to check the return
value of null_add_dev(), leading to nullb_device_power_store() to return
null_add_dev() return value (0 on success) instead of "count".
So make sure to set ret to be equal to count when there are no errors.

Fixes: a2db328b0839 ("null_blk: fix null-ptr-dereference while configuring 'power' and 'submit_queues'")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Link: https://lore.kernel.org/r/20240527043445.235267-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 3b3fd093b0044..620679a0ac381 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -483,6 +483,7 @@ static ssize_t nullb_device_power_store(struct config_item *item,
 
 		set_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
 		dev->power = newp;
+		ret = count;
 	} else if (dev->power && !newp) {
 		if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
 			dev->power = newp;
-- 
2.43.0




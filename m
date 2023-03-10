Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB6B8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56BAC433EF;
	Fri, 10 Mar 2023 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456840;
	bh=eE/1O82/JK0GqartCbommbN7PP/Y7+YzsQTl9N56zic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMGSpS/Mc/i8LPlkEwPYeCYKVGAyWuvRMeCCDba5tWYy47sT+GZTAivokBOpBQFKP
	 KKaB0zZWIkG94S0csfHJ1gKpcAUX2bqCxhRK55tzN/hq18AC/t3WfLE3QmAs5WPvFO
	 6TG6C/nss7aMQ0xEfZtNuALv53TirKWTY8LO+hWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jinghua <zhongjinghua@huawei.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 112/211] loop: loop_set_status_from_info() check before assignment
Date: Fri, 10 Mar 2023 14:38:12 +0100
Message-Id: <20230310133722.156032076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhong Jinghua <zhongjinghua@huawei.com>

[ Upstream commit 9f6ad5d533d1c71e51bdd06a5712c4fbc8768dfa ]

In loop_set_status_from_info(), lo->lo_offset and lo->lo_sizelimit should
be checked before reassignment, because if an overflow error occurs, the
original correct value will be changed to the wrong value, and it will not
be changed back.

More, the original patch did not solve the problem, the value was set and
ioctl returned an error, but the subsequent io used the value in the loop
driver, which still caused an alarm:

loop_handle_cmd
 do_req_filebacked
  loff_t pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
  lo_rw_aio
   cmd->iocb.ki_pos = pos

Fixes: c490a0b5a4f3 ("loop: Check for overflow while configuring loop")
Signed-off-by: Zhong Jinghua <zhongjinghua@huawei.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20230221095027.3656193-1-zhongjinghua@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1518a6423279b..1b35cbd029c7c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -977,13 +977,13 @@ loop_set_status_from_info(struct loop_device *lo,
 		return -EINVAL;
 	}
 
+	/* Avoid assigning overflow values */
+	if (info->lo_offset > LLONG_MAX || info->lo_sizelimit > LLONG_MAX)
+		return -EOVERFLOW;
+
 	lo->lo_offset = info->lo_offset;
 	lo->lo_sizelimit = info->lo_sizelimit;
 
-	/* loff_t vars have been assigned __u64 */
-	if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
-		return -EOVERFLOW;
-
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
 	lo->lo_flags = info->lo_flags;
-- 
2.39.2




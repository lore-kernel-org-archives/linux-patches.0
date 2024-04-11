Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7091A14430D;
	Thu, 11 Apr 2024 10:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829773; cv=none; b=hpbo+pZVKGZ6GYlyz9hzV5nCk8v0EEX4U6/lIcsufyqESfe/5KtUAOEj5lHUZRshAxZJ6eD/7V0lJXJfYnh1nT9lYTCpLIP+E8V62hjmRxkedjE7vW512U+IqFqkroSoLfoWz/yjsre0d4mIYiOEW8Olom/oJZZQUvPa2waCDgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829773; c=relaxed/simple;
	bh=3VL9t6ZcbetS3FoOqqJmEXwytXpsNAFYynqLMJ3fIAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dASmfE47yQtOgbx0oUaCIYSUqANgTC1lskbF/bnkAU4Ls6HyaPJ04EtspXtq8fNz4AVUzIHKWJgc/jXPGrTUjW5qSksPltrJ3t7jEeu30M1U0oyw75sJrAkUgWLiEPIHqWDJwGy/VmP0peaqva1EM0egK4eRyD7+aE50Xvu2hCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPzhM0/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPzhM0/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A3BC43390;
	Thu, 11 Apr 2024 10:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829773;
	bh=3VL9t6ZcbetS3FoOqqJmEXwytXpsNAFYynqLMJ3fIAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPzhM0/Qy3E16CTqgGAtEQ0RMcVqJauJY7KpRmANG+EZLUlLuyOeGXAUcQ+Jfpb7a
	 kk8UuNAqbBdwBad0Vf/STiOtZv3TnnJaVfRDMM19HEDqALHQULd921cbWBy6ywntSU
	 yxFp0feZYQQpchF5OJhSePEWuhkaBVrg4AG5SVas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jinghua <zhongjinghua@huawei.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 4.19 100/175] loop: loop_set_status_from_info() check before assignment
Date: Thu, 11 Apr 2024 11:55:23 +0200
Message-ID: <20240411095422.580176781@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1269,13 +1269,13 @@ loop_set_status_from_info(struct loop_de
 	if (err)
 		return err;
 
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
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;



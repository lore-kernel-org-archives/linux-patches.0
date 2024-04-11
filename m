Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1866145FF0;
	Thu, 11 Apr 2024 10:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830894; cv=none; b=M/HGBbp/LOuSGkaFFYKdp43SpvRSgLJtmXyw0ONxHxv7dD18PbCtyvajNPtJap+Dau9ZbQO99h1i893dfb6qovrNNF5JwvRpl7Y1Lz5oq7qAlDj9qookkRN1F1g84ZkaHo84R6iiDKA3/cjivWSMvdxkvEFRbRWW1u4LUhPkFAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830894; c=relaxed/simple;
	bh=RfWiLf27DVxH0WA456qgesdsKHyhM1odIIw8tJMGNoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJ+O9kmkyaIHTB58cXByhPoyl4nQsjfGQZxNE/3EeXelpGH1EMnIejEhw/QJxjTR5WKTtXkRssJDo9kTmHOo4P+eZ2R3zELJu87euAM5Kh5+KAjKkKfSf2XtBoISfJ8QGQ53B+n+ha2cA1FyYIKK0wHweJuo+GDCR/W9SVRLDc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0rPCa+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0rPCa+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFBDC433C7;
	Thu, 11 Apr 2024 10:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830894;
	bh=RfWiLf27DVxH0WA456qgesdsKHyhM1odIIw8tJMGNoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0rPCa+ENkKayGXFDgdewXwc5g6dv07Aaw0/3nWLaRwcHKdueAokePB7EMEJ81S2k
	 nuYZgXJ0TrT6CvP1x9iIY4hxlkeneaAxx+uXKwX9DrHw+jKm+0FQYHY20yYxqODXed
	 j/jVRIWCRGyZ229WcWS0AJFw69SoUcgCpjXDed2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jinghua <zhongjinghua@huawei.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 5.4 105/215] loop: loop_set_status_from_info() check before assignment
Date: Thu, 11 Apr 2024 11:55:14 +0200
Message-ID: <20240411095428.067634346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1296,13 +1296,13 @@ loop_set_status_from_info(struct loop_de
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



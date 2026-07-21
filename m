Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBE42F704;
	Tue, 21 Jul 2026 20:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665725; cv=none; b=iIGCmStgeYH1aregPvtYvAi9Qa2SInwWDtH0YuHuNnWHp1+IpW7SCbz7ga4M+D/hsc7kBx2ocvz+xqK87qQN8YQumDjEz9BvpFIUEyOVMiEcptD7s1s13J6ldLhKp5xC58gYCaqokWhN+tUjgJKHUCRHciOXkPNCvOlQSz90M+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665725; c=relaxed/simple;
	bh=/f9Vhy7ZsH0+OJ8GCkfdwWYh/qfsnT0yeJkfrpUpcQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYYMy9i7z93qZef/eljX+rTPDhPZopMd0+XqbCkrBRWf+47Kt3PpY5hlItMI7M8nXIUbtYnmy0FoKb2AONCI7ashKnNcQWmLDBIisOdgXJfDTfMj6jP7fPHoWxjUfVJLAD3xkItvAWLcnfDCf+hzwx2izxEueILw3/qH5G+qrMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUhTTbYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUhTTbYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2221F000E9;
	Tue, 21 Jul 2026 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665724;
	bh=SYYTa/KdoaqFdXF/M/LorPZD+TwxGLWGHH0tjk5YtZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUhTTbYsIu2WhGQiENcfDVX7l2syOspscg4jk6GLei1FL9cIk1ErOyYc/Yvnennqp
	 KM/jFUgk5DRamWxPb2DpCjrnUJ5ugvOfu+7xjq32xhdKXOrfCA4j7jFNheNeRavnts
	 qSH28clnrb2E55p5JMeQmUVTyhA2E8hkJbnu4G/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>,
	Sara Venkatesh <sarajvenkatesh@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0410/1266] RDMA/srpt: fix integer overflow in immediate data length check
Date: Tue, 21 Jul 2026 17:14:07 +0200
Message-ID: <20260721152451.012673840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sara Venkatesh <sarajvenkatesh@gmail.com>

[ Upstream commit eb4ecdf631fe00e8020bf461503cb9b7017ed796 ]

imm_buf->len is a user-controlled uint32_t received from the network.
Adding it to imm_data_offset without overflow checking allows a
malicious initiator to send len=0xFFFFFFFF, causing req_size to wrap
around to a small value, bypassing the bounds check, and subsequently
passing a ~4GB length to sg_init_one().

Use check_add_overflow() to detect wrapping before the comparison.

Fixes: 5dabcd0456d7 ("RDMA/srpt: Add support for immediate data")
Reported-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
Signed-off-by: Sara Venkatesh <sarajvenkatesh@gmail.com>
Link: https://patch.msgid.link/20260504080036.3482415-1-sarajvenkatesh@gmail.com
Reviewed-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 4bebc34a2929b1..13e1fc5e2759ad 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1129,9 +1129,10 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 		struct srp_imm_buf *imm_buf = srpt_get_desc_buf(srp_cmd);
 		void *data = (void *)srp_cmd + imm_data_offset;
 		uint32_t len = be32_to_cpu(imm_buf->len);
-		uint32_t req_size = imm_data_offset + len;
+		uint32_t req_size;
 
-		if (req_size > srp_max_req_size) {
+		if (check_add_overflow((uint32_t)imm_data_offset, len, &req_size) ||
+		    req_size > srp_max_req_size) {
 			pr_err("Immediate data (length %d + %d) exceeds request size %d\n",
 			       imm_data_offset, len, srp_max_req_size);
 			return -EINVAL;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4127B3368B8;
	Tue, 21 Jul 2026 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655830; cv=none; b=sZUU7UBklegW6g9U98m2dKUfGv03afm+/ciCGtuyk+8AtJr2IgAyvePQ3MBMbpZw6bNXEcvzHdbnPB63IrhijqM5s2zEk10anTfSJ/1xp4bs8g830FS1r79jcgbUrNQ8X3YhiFf4+H1VSI8TYYjOXynCcKk2RCqV+VFT1DUkozI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655830; c=relaxed/simple;
	bh=Azm6NVxDDcL6zXyjxhL0IvCAiTarBp1QKz+Z4MTOrtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyI+ztVoU/f4ZIWDwivlAFp6DVuLxPbhRNps7e0HHCbaO9RegNkNVwzBQhz/ObHkcgXlkKcVBlSEfPYoNhK+3/HKBSN8lLCmaKM54GfxcSVVrutQ+L56hDaHVkmSukjaycjNZCUg1KudL3gjFHtuMrzGXySvIE9pfp/BNWB8444=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKJU4YbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKJU4YbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83601F000E9;
	Tue, 21 Jul 2026 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655829;
	bh=CGIsozrvLlBE+wwUbgMAoCK6e/dVW+xiBEaDEFCPXPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKJU4YbOmL01UMoB+jYngVCwlO8/Aa4L2sxxRLnMxeBPHFjpIlEwdQ0eDTAdNHsRj
	 aGjk+WtUL2ynKAIiw/Hw/yDt4xWq6o9W38U7C2tIYu2yPKkEK6zoC+/YSF1wfVLjXL
	 ces2Y8KncMM4NXp4d6qkIq1o7bh8mTb326v5o/Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>,
	Sara Venkatesh <sarajvenkatesh@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0158/1611] RDMA/srpt: fix integer overflow in immediate data length check
Date: Tue, 21 Jul 2026 17:04:34 +0200
Message-ID: <20260721152518.435872658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 71269446353dbc..ba70c64a0aa9ea 100644
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




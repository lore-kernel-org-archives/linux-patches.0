Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E9844AB9E;
	Tue, 21 Jul 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668806; cv=none; b=GDzvmE/vd1OlFDhTLyH5nbLBuDBHLvpYTrSqc0ef7EC0B5onQuHmKa/6u4pyxC+asV0OktFz/a/lafMS8Wf85Fedk5uFV1+IwkZi0+PxPzQ3AmAOO5Gc59AvSq8cGX7kgSQJ9roLEo4SccHwzZ1fWRA6OuT+YyNeD+rXooPrhHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668806; c=relaxed/simple;
	bh=DRCyzx/q/KDKf01r02dxR9PYZ0XDHo6D648IzMG2/+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4WpNO7/6AJFKe4YSHD4fZkVWbHxF8Mpr+SHQ2X2uJYJVJwtll9gKlaLx3LyLB4DhDe6XnRu1LTXcrLfoBIg19aUS3aB5tByuZ5IYdmSpR+fgFZOuh18D+nFW1P4ZFluqoYviCly/OuRdA9Lb4UHxrN/ZettGBexkwvlQXNjr+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBKvrSK+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBKvrSK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC82C1F000E9;
	Tue, 21 Jul 2026 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668805;
	bh=YbYA/LahTmZeQ6chj7Y5V8diL3qiIWaNRQbiS12V4+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBKvrSK+zBPEBfZZazD0kctT94QyigL7UB4nQv5rCQmOCorPqutZ6skwD5fNmiUhk
	 73Ad6U7Vme+u3pboZLy+LjK+f/AXi6thctxmGZsFzjtLhwtl2MRR86ztG9xcj6bl9K
	 stj2fs/twr3jKCOP+PerBp9Q7mDNrZNfwLy6YlaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>,
	Sara Venkatesh <sarajvenkatesh@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0314/1067] RDMA/srpt: fix integer overflow in immediate data length check
Date: Tue, 21 Jul 2026 17:15:15 +0200
Message-ID: <20260721152431.617596889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 33c099e5efc5ec..e9ce57a730c023 100644
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




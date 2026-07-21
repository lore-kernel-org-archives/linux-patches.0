Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C60427A10;
	Tue, 21 Jul 2026 19:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661593; cv=none; b=U0jI1rzU7WD+a6VrCTe1ILGscp3nuEEh7WX5zT0YRsiYrCkcjg5Qu84363gplXApMVsPLqvIRd8eh9parhVjs/qTLvIY4tZTx3OaMLc2lq6wBfkvWe6eMU9wIU9lqqjsjM/VArR4QLg7n/IhY7a0CEt1nP4Im1FnbTrK01Z6DN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661593; c=relaxed/simple;
	bh=VjAb3leMb7QCRFzmQckBprgYkFy/su/cToeIJZNqEtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu6gvF9fzL0FznvKmBsw8ukP+AHUYxPxslgAEks/G74qWPBmEJn897m3V9tICbAcqK0NG9U1/NNTYNeYbmynzZNHLbZluTMvxXjeKK9JRHFSY+R8nlnVDN4nB6SfTh33I3qSir5m9RYWxNZw3e6xCoSg13ea5Yk7/sUx2EFVQBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwMq86fv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwMq86fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A641F000E9;
	Tue, 21 Jul 2026 19:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661592;
	bh=PgYfxnXAZg8AjVhn1sl/JdGnqTqivDoMmUHeS9knZ+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwMq86fv2rohz/fnDTMa8j67WzA7WhZ+EKqsqGVmTUMA5UyeTePxORxpPAhcwEV0e
	 hO32ftt4GXwCQlq+f6YV43J7XA4Up0qY7WhyZ1k8eVPOPLSdD8hjw2FbiT7As4UM3a
	 Bu4KLF57PKw2TgBxziSF9XUoj1Mb0y/jvWA0XRTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Carlos Bilbao (Lambda)" <carlos.bilbao@kernel.org>,
	Sara Venkatesh <sarajvenkatesh@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0124/1276] RDMA/srpt: fix integer overflow in immediate data length check
Date: Tue, 21 Jul 2026 17:09:27 +0200
Message-ID: <20260721152448.880227945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 5dfb4644446ba8..128e4e836470c8 100644
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




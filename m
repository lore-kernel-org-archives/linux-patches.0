Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E8929A9;
	Fri, 15 Nov 2024 06:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653226; cv=none; b=YJPx9SvJ90xwYDlQZJNeQOUNjuIrUhegZPfLYDVsFYNGctAgTQgcomOp+WeJLwiNY3n3N8sMx3vgl2Nl2c7r6DX/4auMOI4DswA56tx+AkEZG0y08qtBZ5WpwbJLqolZwAmMFdssZbsO3+GTx5Xj7wc1AGWCNCsomeLMh1ChDYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653226; c=relaxed/simple;
	bh=20Tn+lnqWg9pEbIa3oNM2/V80qkF8BpWmZHNdn90K60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccvNisXt1RfLsf12S7VYrDPg5AGOBoVoqZmmw3TepI0F7ZoCXDcpwL2S5xJxqaqEUqvbWb8vAWoZPcE14pmd0R/G64FwcpQ15zHB90l/EdhQMqHitxV0+72QAaL/OinvKeU7H7M+8yb+eBLwMsjtXvPsAxnUGjIhanCkQqayB80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNcevkGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNcevkGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F45BC4CECF;
	Fri, 15 Nov 2024 06:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653226;
	bh=20Tn+lnqWg9pEbIa3oNM2/V80qkF8BpWmZHNdn90K60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNcevkGVUMwvEzacbvTmRrxSUsMpYeG5RpZ47VeMLE4PvAnaT8ApmE8FSva6nKNvL
	 OqJfBJGTt0vGzjt7zaKb/oSud9D0tChIyfU8RZuBFDVntEYcvDCVhh7w/PR3KJzAz8
	 Wc827ACKY7ZLNsdEu8ir0/RqFDbLceWJDkxUbIz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Showrya M N <showrya@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 23/63] RDMA/siw: Add sendpage_ok() check to disable MSG_SPLICE_PAGES
Date: Fri, 15 Nov 2024 07:37:46 +0100
Message-ID: <20241115063726.757605433@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Showrya M N <showrya@chelsio.com>

[ Upstream commit 4e1e3dd88a4cedd5ccc1a3fc3d71e03b70a7a791 ]

While running ISER over SIW, the initiator machine encounters a warning
from skb_splice_from_iter() indicating that a slab page is being used in
send_page. To address this, it is better to add a sendpage_ok() check
within the driver itself, and if it returns 0, then MSG_SPLICE_PAGES flag
should be disabled before entering the network stack.

A similar issue has been discussed for NVMe in this thread:
https://lore.kernel.org/all/20240530142417.146696-1-ofir.gal@volumez.com/

  WARNING: CPU: 0 PID: 5342 at net/core/skbuff.c:7140 skb_splice_from_iter+0x173/0x320
  Call Trace:
   tcp_sendmsg_locked+0x368/0xe40
   siw_tx_hdt+0x695/0xa40 [siw]
   siw_qp_sq_process+0x102/0xb00 [siw]
   siw_sq_resume+0x39/0x110 [siw]
   siw_run_sq+0x74/0x160 [siw]
   kthread+0xd2/0x100
   ret_from_fork+0x34/0x40
   ret_from_fork_asm+0x1a/0x30

Link: https://patch.msgid.link/r/20241007125835.89942-1-showrya@chelsio.com
Signed-off-by: Showrya M N <showrya@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 64ad9e0895bd0..a034264c56698 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -331,6 +331,8 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
 			msg.msg_flags &= ~MSG_MORE;
 
 		tcp_rate_check_app_limited(sk);
+		if (!sendpage_ok(page[i]))
+			msg.msg_flags &= ~MSG_SPLICE_PAGES;
 		bvec_set_page(&bvec, page[i], bytes, offset);
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80EAEAD0;
	Fri, 15 Nov 2024 06:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653414; cv=none; b=bfrX1w50ayOFbMKqO79po2Rac1+jZiRFYPioKKg07u8vhiEsQtWmMfbD5d58GRY1apUq9Mj9gM6P6lfQoglGY40iYPDq5U5AN+WOi6532IpnMWo/9YnIzHnUna8wVkb+yXhZG7OE2gumFd8WlZLlRH9Dh3zLK/9Xi0rStKRIFMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653414; c=relaxed/simple;
	bh=JDeEe+bsXO+Gg22a4Z6eJnVSwTSMAKaDjrJTbqzlcJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RN0F6UmDGup14vJd37zMgZyzjmTwI08I9c026qfgGE8dYqA93Zg11MQ7PpNsugosu4hytDOvNaZWxoK0jqjr7T/1q66QheOREjVaeLtX8azVnNk8ZoCqIQU8+VDwnuU5uxzwMSXUIFndeu9l3xeZB8oiZvmelBpbPQPeyrmsEC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpnP5Vwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpnP5Vwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169C5C4CECF;
	Fri, 15 Nov 2024 06:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653414;
	bh=JDeEe+bsXO+Gg22a4Z6eJnVSwTSMAKaDjrJTbqzlcJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpnP5Vwtg3up6upC6GK7ydqeYQc+BTsVR/salD+1bWLPokpGdGikPbBpgpDO79IxW
	 Jy8lbY0KDCKJgiE2pGmZZ4oFvu8jeXnlp0Q42Wno05USrthqzQKY8j6WeAJy32CpCR
	 CNCltkbW9bTkMo2epejeulNBuHqs6xPOO9N6Vxp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Showrya M N <showrya@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/48] RDMA/siw: Add sendpage_ok() check to disable MSG_SPLICE_PAGES
Date: Fri, 15 Nov 2024 07:38:05 +0100
Message-ID: <20241115063723.551147146@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60b6a41359611..feae920784be8 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -337,6 +337,8 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
 			msg.msg_flags &= ~MSG_MORE;
 
 		tcp_rate_check_app_limited(sk);
+		if (!sendpage_ok(page[i]))
+			msg.msg_flags &= ~MSG_SPLICE_PAGES;
 		bvec_set_page(&bvec, page[i], bytes, offset);
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
 
-- 
2.43.0




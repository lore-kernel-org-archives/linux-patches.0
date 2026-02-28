Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491AF383C77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302031; cv=none; b=P8xCKIXr5z348kheNV3fjXP7HtZTW9hg/pF4PJDa7krWhQAsIwMSiAYGIKyqmLCnhNLxhyzO3EW0hU/cbp0sJjrN24D1UXhMTYSLIYmlvEZpkNmqnxS9ELDd1eefk4iGRkN/ofevkzMUyngpf+5nqiycjXcJZdfyb1N6Pnz/GKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302031; c=relaxed/simple;
	bh=3hfLnEJzEREaJbxBdBQsZntbEO3u0SPzZVUIUc5zr4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ouQdwPdiWpxUrF9770aS5NaJ6J4RJEsy0AD2ZefnDQDI1xnZ7ytLWyqEeTF0QJ37h9Ul3fcQqwG8zt3HvtMbH3Chezn5tZwAra1q35GgxJ2a57kohE8bJkAzwQ8xfrTcZvMGlC8za4x2CyfedXIFlR0MoqNinKgGfBZVw+QPSmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4oz3Hiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4oz3Hiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76701C116D0;
	Sat, 28 Feb 2026 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302031;
	bh=3hfLnEJzEREaJbxBdBQsZntbEO3u0SPzZVUIUc5zr4Y=;
	h=From:To:Cc:Subject:Date:From;
	b=Y4oz3HivQaa83MsgpQUSA44Dp79Cmj8//YKpItrP/vflKxsw5SyxdJH2cubE7aOqL
	 jPoNa19WBkBPjyfSV24w9d3puZypM90mEyd26t7k9P5ptpu/UYPzf48I6ezT1anS6M
	 LLcPeA40DWFaVL+5K3fWs4XgVCS1tOnYfJsrGu177s2WQOXqxmfb75xVNJJJzAsEip
	 z8q8SCVyk0VqjsxS44oG5ePh7PMte+KSx7ktfF6/AYlOWhJCqUMIcHjGjCsJjv5Gds
	 G/FHGTMTNTdotY661btGdkMbqvvArsxx5ZU3rM+q/eV8UTr2qSH03dujngBgfDJDDw
	 ElTJ/P5ehRyMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: YunJe Shin <yjshin0438@gmail.com>,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.6 001/283] RDMA/siw: Fix potential NULL pointer dereference in header processing
Date: Sat, 28 Feb 2026 13:02:23 -0500
Message-ID: <20260228180709.1583486-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: YunJe Shin <yjshin0438@gmail.com>

commit 14ab3da122bd18920ad57428f6cf4fade8385142 upstream.

If siw_get_hdr() returns -EINVAL before set_rx_fpdu_context(),
qp->rx_fpdu can be NULL. The error path in siw_tcp_rx_data()
dereferences qp->rx_fpdu->more_ddp_segs without checking, which
may lead to a NULL pointer deref. Only check more_ddp_segs when
rx_fpdu is present.

KASAN splat:
[  101.384271] KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
[  101.385869] RIP: 0010:siw_tcp_rx_data+0x13ad/0x1e50

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Signed-off-by: YunJe Shin <ioerts@kookmin.ac.kr>
Link: https://patch.msgid.link/20260204092546.489842-1-ioerts@kookmin.ac.kr
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index 58bbf738e4e59..e2ad2425d57da 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1456,7 +1456,8 @@ int siw_tcp_rx_data(read_descriptor_t *rd_desc, struct sk_buff *skb,
 		}
 		if (unlikely(rv != 0 && rv != -EAGAIN)) {
 			if ((srx->state > SIW_GET_HDR ||
-			     qp->rx_fpdu->more_ddp_segs) && run_completion)
+			     (qp->rx_fpdu && qp->rx_fpdu->more_ddp_segs)) &&
+			    run_completion)
 				siw_rdmap_complete(qp, rv);
 
 			siw_dbg_qp(qp, "rx error %d, rx state %d\n", rv,
-- 
2.51.0


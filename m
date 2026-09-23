Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC259526ABD;
	Wed, 23 Sep 2026 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172876; cv=none; b=dNIlE8m9Ddvwqbnp4jXyfSUrIXOGXggCtDE96uDFCxRI6n/Vy5Wbj5SIGX9Wt+nf6DDfTY8UIChGJVe2NDWtiOZm/JDpk92xR+Fo9NycnsS4w+fJxPKZV3oP2D4yeI5016hEqjB3Z22+M9vMc6KahvWWIRBd9f6bZ46iGM/F/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172876; c=relaxed/simple;
	bh=xh/8k0MVelm/Ce7z+pKZrfTlRbfko2UJSloLIaDFYBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvi55Hd2di/tQd5z2bQIn57XMRwTnGs6F45L8mg1HjopYLHP+N5Ki4s8mKZcASp3d1+Z3gv+IDc7OtKCq+xeIH93W1hQgTUUPUaxudTPus7wkJea+nMjW93wJWhSV2F+Qw+cYDJaJM1ZCKivYvBzkQ6kMOhJbbUtZDcxmMGmfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcmYuJHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcmYuJHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB7B1F000FF;
	Wed, 23 Sep 2026 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172874;
	bh=QdNoOaxRyAzFoay7EO5aimNp6H3HkMOnX8ghwylQras=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcmYuJHULZjbeOWt1zJ7sZakrytUEt3SFgCoTj3GFgkKSJfcL5S+5wQfowSXKQ2P5
	 FMRfvfqpJgEsnJu5HswpoN1jgqOQvPZK3Z/SWNwBsT2kDTOSMuTbCawxvsHOGCyPZK
	 y2rc0NgqEFyF/PT1VTesZNk00YGoQvfblS7/fgtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 041/438] RDMA/mad: Fix receive buffer leak when PKey enforcement fails
Date: Wed, 23 Sep 2026 16:01:02 +0200
Message-ID: <20260923140645.848501167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 3476c28c9addfa253f505e6bd87f1f5598b961d0 ]

ib_mad_complete_recv() initializes mad_recv_wc->rmpp_list and then runs
ib_mad_enforce_security() before linking recv_buf onto that list.  On
failure it calls ib_free_recv_mad(), which only walks rmpp_list and frees
the ib_mad_private of every buffer found there.  As the list is still
empty at that point, nothing is freed at all.

The caller cannot clean up either: ib_mad_recv_done() sets recv to NULL
right after ib_mad_complete_recv() returns, assuming the MAD layer took
ownership of the buffer.  Every MAD that fails the PKey check therefore
leaks one ib_mad_private (about 300 bytes per IB port MAD, ~2K for OPA),
and a remote node can trigger this repeatedly by sending MADs with a
wrong PKey.

Link recv_buf onto rmpp_list right after the list is initialized, so the
error path has something to free.

Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagrams")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260826073216.2367-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index e0b3b36b8b149..3c91f00d09c6b 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2059,6 +2059,8 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	int ret;
 
 	INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
+	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
+
 	ret = ib_mad_enforce_security(mad_agent_priv,
 				      mad_recv_wc->wc->pkey_index);
 	if (ret) {
@@ -2067,7 +2069,6 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 		return;
 	}
 
-	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
 	if (is_kernel_rmpp_data_response(mad_agent_priv, mad_recv_wc)) {
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
-- 
2.53.0




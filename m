Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB3B509F0D;
	Wed, 30 Sep 2026 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783351; cv=none; b=rylCAw19N9qmNhAc+geEXKUKLdqufA4I7W4o/z2zs10dJtWePJGHptKGAUxlidDLWTXmMzbQR2bhYER8eh8Cy/lyl7L1X/TGSmttSNXq0VlEpHKXD8XKtcNfW43EpyZ5YpmdDwuUFtjpaD3gfF3E4NxsUub8A/Difnn7E4y2ri4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783351; c=relaxed/simple;
	bh=xQyfo+I9xX9DL+dPNiktO57Shphip5tdGd8BEG4ih+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IISaKoECsQuGJ1cQTq4E2WuSTYg5nTtAgkcqQ3PpfOgEDd/DpOzyB0+51wV7qRHorX8fV16IDZmr8jUyqNhdFNOJ37m2ySoq6lzOWu98y7nRgmPjSOgl6EwEf+wAzLwkBevci6qOGt3R2FL90Iy7778ZUqKRIumWRHOkZJrFprw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3EV+rru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3EV+rru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBD1F00893;
	Wed, 30 Sep 2026 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783342;
	bh=2gmdqG/CsRVhJFTNpj9A39IvSyUYzeDukGRjgVIHxso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3EV+rrumMFflpTPfzMiujp9iQZR3w5eB8xcKFwk/9t+viV5GFh/WzsG9i6TfaWyz
	 abKzJHhnOTxHHXMsT84F9I7KV4WqV6KH68mZ4ciUH8bQ7ctIoBrZ1Gedr+5scsw4OX
	 bP2M3b5ZmwNuS9hy3XpYGOQ97qGh4y/xfPupbmKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/595] RDMA/mad: Fix receive buffer leak when PKey enforcement fails
Date: Wed, 30 Sep 2026 17:24:19 +0200
Message-ID: <20260930152355.549598703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 10d29167b585c..1be9513b8966b 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1810,6 +1810,8 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 	int ret;
 
 	INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
+	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
+
 	ret = ib_mad_enforce_security(mad_agent_priv,
 				      mad_recv_wc->wc->pkey_index);
 	if (ret) {
@@ -1818,7 +1820,6 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 		return;
 	}
 
-	list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);
 	if (is_kernel_rmpp_data_response(mad_agent_priv, mad_recv_wc)) {
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr = ib_find_send_mad(mad_agent_priv, mad_recv_wc);
-- 
2.53.0




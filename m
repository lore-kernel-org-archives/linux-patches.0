Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE90A41735B;
	Tue, 21 Jul 2026 19:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662991; cv=none; b=aeo5WMVyZ+2qBrxtcI8TEdSyh9uHT0zyWNJc3QXSw4mGuRfGvjHvch/HTLrrjMRM5BfHcg2MMWf2nrP8PklWVBgNYRgVz7+ROD9m7170tK0kC6vCcpotI17WqI4jidwtVmppzfaQss1nLFNVKvvIu2eZnSke0qnzO3OrCDqVCls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662991; c=relaxed/simple;
	bh=J2knhyYThQNwuibiHV4WGWZ4bNFTpPOi9pFuV6a5+VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0+C1ybm3qGxX+K94ISNgwgrLVp/NOAtINB/2ISfB9pWSvd1dGWrvbF29dqajMpQdCQJE3sNi187j2Wc1IbfAnDnlN84/pZixL4zo2I/98pccMIygb44NAEuB1rm7j5nmdYRsei9t2lxKk+bxqR3CCLxKWdHkzNXe2F+I6QZDNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qB3B5dje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qB3B5dje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250061F000E9;
	Tue, 21 Jul 2026 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662990;
	bh=DwoiSd/Ry353DI/BqEeKpQpIz8/FW4LBd6SexeX+ovI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qB3B5djeBbJHmZFIwKzGThvCoUDPdcGWphjbqEuuEY6srjXfxcqLkjmLu04JR+FaO
	 utAi6fPE0gwbG6oulJmu+lZPE84KRO1h06Ng0Gu3zbKWwCZcwx1BZ0BX9uk/dO6m1u
	 igJsjmjYsP5/WX+0JXuR1BByb0aKA55KVe0AzF3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@google.com>,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0655/1276] veth: fix NAPI leak in XDP enable error path
Date: Tue, 21 Jul 2026 17:18:18 +0200
Message-ID: <20260721152500.766976044@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6739027cb72da26890edd424c77080d187b2a92e ]

During XDP enablement in veth, if xdp_rxq_info_reg() or
xdp_rxq_info_reg_mem_model() fails, the driver rolls back the changes.

However, the rollback loop:
	for (i--; i >= start; i--) {

decrements the loop index 'i' before the first iteration. This
correctly skips unregistering the rxq for the failed index 'i' (as
registration failed or was already cleaned up), but it also
erroneously skips calling netif_napi_deli() for rq[i].xdp_napi.

Since netif_napi_add() was already called for index 'i', this leaves
a dangling napi_struct in the device's napi_list. When the veth
device is later destroyed, the freed queue memory (which contains the
leaked NAPI structure) can be reused.

The subsequent device teardown iterates the NAPI list and
corrupts the reallocated memory, leading to UAF.

Fix this by explicitly deleting the NAPI association for the failed
index 'i' before rolling back the successfully configured queues.

Fixes: b02e5a0ebb17 ("xsk: Propagate napi_id to XDP socket Rx path")
Reported-by: Guenter Roeck <groeck@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Björn Töpel <bjorn.topel@intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260622111825.88337-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 77e4b0d1ca557f..eb7ce1211784c9 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1136,6 +1136,8 @@ static int veth_enable_xdp_range(struct net_device *dev, int start, int end,
 err_reg_mem:
 	xdp_rxq_info_unreg(&priv->rq[i].xdp_rxq);
 err_rxq_reg:
+	if (!napi_already_on)
+		netif_napi_del(&priv->rq[i].xdp_napi);
 	for (i--; i >= start; i--) {
 		struct veth_rq *rq = &priv->rq[i];
 
-- 
2.53.0




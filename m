Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC1D471253;
	Tue, 21 Jul 2026 18:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657837; cv=none; b=gE6H1Fw+0Roq6LP0qktPlV3xI7WroVWCqVhfuWLMZ9R/SQd2oUZI3bbvkdIYFxvlqvjSBH/RKHJqALXr/2MVZdUawNQ/67iMnTJyLPRitOGGc2sZhRczCf4A6rg43c6hXaypjfEqPjemiVTg/MnpfYUNdWESD7Xkb/0IFBdE4Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657837; c=relaxed/simple;
	bh=7uhClQYR0Ql2tbREY7BE4XTGDdeTm+zKyODpcKhgu/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ENRAan4KnrJ92EB8sc8xk+cIPxRP9onlbRaiBPKIuCKj6l3EUaTmeNfWhAigPCH9g/wvbmXhOo5LXf0vSeAmaO2hM5cuiY7Q6bYhcP7LLimYsQBxZZnQUCCsCjCFBRNZ1g97kWv5rUSsO8iBXi7QI2MYPyXReGToap9jrGXMl+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSNx7pQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSNx7pQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4521F000E9;
	Tue, 21 Jul 2026 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657836;
	bh=MZR61aV2y3LzCZUUNYUwsKPjHDv39ae8Hwcmh5hRwdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSNx7pQSI9A1jbmp+lzsd0WOBEeAusSrwLoCxoq7CRtzZ3CtRPbK56KlBM5QEJvb1
	 zgAnOjMkJ99bkuKDrfK8VeaMyqaRWhVs0gNFzzMUjMDMks6TSLf2+YtmrfL6d/XZvo
	 Bs1SiYlTL6VpGkUquhQZt/PqmbHZB4krc8ExKP9w=
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
Subject: [PATCH 6.18 0915/1611] veth: fix NAPI leak in XDP enable error path
Date: Tue, 21 Jul 2026 17:17:11 +0200
Message-ID: <20260721152535.965707523@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b00613cb07cf07..4595c61c0790bd 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC2D1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F88CC433C8;
	Tue,  1 Aug 2023 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883079;
	bh=DVRq9JzMiTX+edFuq5y5a1+M41FagFy1S0ymQxAGsSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KssIfUCqVH9bxcR4CsVvB3DxtxDcXgT7iyszL7UZW9+MK5WMLdjp4yZ4f8XVAGPYl
	 Kt3naugK6w3XDYPcsnGnAXsCnlGzRJADRFiD4K8dCzb9GXg7At3rhsh6AjKd45IXfJ
	 K/1+NI4yrUttIXjdpTdx6F+keKHkWg+EwKdkajn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 108/239] RDMA/core: Update CMA destination address on rdma_resolve_addr
Date: Tue,  1 Aug 2023 11:19:32 +0200
Message-ID: <20230801091929.625664579@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit 0e15863015d97c1ee2cc29d599abcc7fa2dc3e95 ]

8d037973d48c ("RDMA/core: Refactor rdma_bind_addr") intoduces as regression
on irdma devices on certain tests which uses rdma CM, such as cmtime.

No connections can be established with the MAD QP experiences a fatal
error on the active side.

The cma destination address is not updated with the dst_addr when ULP
on active side calls rdma_bind_addr followed by rdma_resolve_addr.
The id_priv state is 'bound' in resolve_prepare_src and update is skipped.

This leaves the dgid passed into irdma driver to create an Address Handle
(AH) for the MAD QP at 0. The create AH descriptor as well as the ARP cache
entry is invalid and HW throws an asynchronous events as result.

[ 1207.656888] resolve_prepare_src caller: ucma_resolve_addr+0xff/0x170 [rdma_ucm] daddr=200.0.4.28 id_priv->state=7
[....]
[ 1207.680362] ice 0000:07:00.1 rocep7s0f1: caller: irdma_create_ah+0x3e/0x70 [irdma] ah_id=0 arp_idx=0 dest_ip=0.0.0.0
destMAC=00:00:64:ca:b7:52 ipvalid=1 raw=0000:0000:0000:0000:0000:ffff:0000:0000
[ 1207.682077] ice 0000:07:00.1 rocep7s0f1: abnormal ae_id = 0x401 bool qp=1 qp_id = 1, ae_src=5
[ 1207.691657] infiniband rocep7s0f1: Fatal error (1) on MAD QP (1)

Fix this by updating the CMA destination address when the ULP calls
a resolve address with the CM state already bound.

Fixes: 8d037973d48c ("RDMA/core: Refactor rdma_bind_addr")
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230712234133.1343-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6b3f4384e46ac..a60e587aea817 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4062,6 +4062,8 @@ static int resolve_prepare_src(struct rdma_id_private *id_priv,
 					   RDMA_CM_ADDR_QUERY)))
 			return -EINVAL;
 
+	} else {
+		memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	}
 
 	if (cma_family(id_priv) != dst_addr->sa_family) {
-- 
2.40.1




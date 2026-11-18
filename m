Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055559;
	b=YAA28q5JYFcx3ZKUhshN8FEZ9d/IOyeF2LrXhUOKD6xT+rnaxiv/nubX3goUoXJk5x9f
	 ZvKawpRsqNBdNZU48nZ9/sQcOWr7cr3QTSmMdFsK21pRDtJC6asGDX/VwLt+jaUiktQlh
	 0VHasU/k/l7XSbfxxoMc91Y4bziOpCLIoaKAZ7J1X4X7E1VMIzz5DFvmT6zVcruvUshqh
	 NTtjm257Mfd1sz2Njly08sGQDBDB0XpnELC2JWRKXuUfu2P956P2RS9yynGCUIpJYQEyZ
	 74HYIZC9rCnKwYhCKw7V3p13SZYjmnCBNf7ASVhYNq9Zo/6iQs2X80nS1c6X2zQrtNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qt9mkDL2aAvMVWaRMxJ88Gy387cilCkypiawL2unFGE=;
	b=WN9CngQ2be/dukIWgoE331IgRLyUxezJCN0KGhKQzePjEDnd+leKNCMM0rKNsflGUraS
	 DyBOOPPL5ZQFA0bHBWfK0qTcqOGDCw/++aCuNBUB53WYQJNX/TZRtL3RhcJw3rntpQ9/a
	 FLagaxnDdtRR1fudbgAUmH/izIl7kq37d8D45UG+mkpanmLcY+iMzmr2QVFA1EhgnRm3O
	 AJIvNiJ3TixLHXeO9DYAKdPr7W3y7XDgUzDhF7M7HTnMSnydQ7ZWo6ECGkpuYUGeUs1Zn
	 mi+F64jC1/d8/7PzkoZE6xJPcehAPkrk1kt11khmAP38yKs2KBG1e7xwuvEdFe4Kgrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mW9Kz3rh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C77606A331;
	Thu, 19 Nov 2026 02:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mW9Kz3rh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CD91F000C6;
	Thu, 19 Nov 2026 02:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055559;
	bh=qt9mkDL2aAvMVWaRMxJ88Gy387cilCkypiawL2unFGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mW9Kz3rh7PbHf5QQRfb/faKRvbwALfBQngE7mQdtPOY124KWAazwlSnK+22hcN8YJ
	 immeg4jfDOo5p2NwdrNilRh9Xk54Rxtg9DXg7A3JAbprJEFYTN76ax10B0c2ld1ZFl
	 UCLi0MtWJLvMnroVbCCcFJcROgS8GPxRTGxECCpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1674/2214] RDMA/mad: Reject receive completions shorter than GRH
Date: Wed, 18 Nov 2026 15:55:50 +0100
Message-ID: <20261118150118.804732072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 2dc2126e690203d6adbddc7675927a242d810e43 ]

ib_mad_recv_done() derives the OPA MAD length by subtracting the GRH
size from wc->byte_len without ensuring the receive completion covers
the GRH. If it is shorter, the subtraction wraps before the result is
stored in mad_len and an invalid length can be passed downstream.

Reject receive completions shorter than the GRH before inspecting the
MAD header or deriving the MAD length.

Fixes: 8e4349d13f33 ("IB/mad: Add final OPA MAD processing")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926105927.3183294-1-yaojiale02@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 4347b3af13119..d5a6bdf9b9d9c 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2084,6 +2084,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			    recv->header.mapping,
 			    mad_priv_dma_size(recv),
 			    DMA_FROM_DEVICE);
+	if (unlikely(wc->byte_len < sizeof(struct ib_grh)))
+		goto out;
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
-- 
2.53.0




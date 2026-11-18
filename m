Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040436;
	b=b8vQgVoySdUjfJYgULFbjVq2VW8zKdFtRMg4MP/Kfs2HaysyrKRTDepixD1ws8UoruUo
	 iR554hFc+2J4fvcpna30Vre3QZnPyx3vxQGIPIZLiVuHQpiVUKFfHWbEh6BJloXwqlNUO
	 Wpp2Dev25tR20SVe35Ql2dPySdUH2S8UFLigsjhmPyCKbK6I5jw5d/vETvNJiT11Aan+X
	 LC4BTwuPjoLR81loqce0czcqJnV9fpEQ5F+s3u6GmMZCWGrqUCQrTwUpVOE5bZyEP7EYh
	 gTIg2EPi5Y3LPkw/IUmW3eDRzYpWt5BKIVHkKSTxa5mqWFgsla7yYKggIieBBaWPbLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Wk6BW3MvJtTJkixqNcadzVF7/Qfeekfl7UUtCMnmpM=;
	b=VaScbumtIId7VPRUDj7DtdIj65Z8F5cRD1pWIOoOA+Ks8pugIMcMDS6XJZIu+IJuPn2S
	 V1cPWy8AVIKETw5saULNkUQvGorfCJuv7vWi5W0umQM1KBXoGf7e45ktpgyjkGvKwkINH
	 LEJZZxxzo9DphfwD4wHDD3bR41bg9yavXshBmkz0JGs1Vh5RHukq9iN2s8rG5e4NhZIUg
	 JeCq9eXfyGwngx8NDcJ4eGIceUF2IC4Ws+g7O8sPsClG1qeGPCL2FOUnr+W8vAY/uMyZI
	 VCkyHFxo/kAalggxrRyQNBeti2nu23TlLcUIQxgTQh3uxOJEtMC00wklPZ8g48Wh6Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kL5kmoRw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFF9606A320;
	Wed, 18 Nov 2026 22:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kL5kmoRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193181F000C4;
	Wed, 18 Nov 2026 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040435;
	bh=2Wk6BW3MvJtTJkixqNcadzVF7/Qfeekfl7UUtCMnmpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kL5kmoRwhbGt5jXVnoF4IYfzSCd4jCnqRYYfoEMcYkqkXd3KxzBEgAIoS+n09RFBr
	 61xL9Fjp7HGtQm1ILEuRdpMx0l4boNZBFrcq0xBkkmetzkNjlBk8R64l12mJJ0kFdq
	 8vG3FIgUrICBYV4ugrTJnpQXEfHC4JyOh+u+grDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2457/3318] RDMA/mad: Reject receive completions shorter than GRH
Date: Wed, 18 Nov 2026 15:51:19 +0100
Message-ID: <20261118150435.143384845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




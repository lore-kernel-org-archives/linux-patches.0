Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048827;
	b=hkaGsT9yEXbs25MorGiuhIXBKmrq9DV29ud9dZI8Y9ggERHp2/L1q54exN2mv75JxJ1h
	 /fAhS5H22dkbosEwnt4nl8eHHLn02fKQAIZ/CR+XAPeZwwLYbd+D2JY0ESU7NrIgCJhk5
	 1YRwzFyRo/+quVY+zSI+ols2XE3EwqM8TjGU7VW9AkF+HbCvDqO0yM2whyOL65vp3klBS
	 VFC03z7gQiVYEeiarZc4zHad8EykR9ho6O5ZKZ9YVB7vMVm91ugD2Sby6x98h7rGGs81s
	 zdmBo8WrR3GKApGB0G84Lz4KsjGY7cbJVR/iBqHDRyXdrqDL3a+Ai6NRqi+plQNXG8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=12O1LzUjjwAjZEuprUDMiZQDcEQt7VkNjdNIXcGQ6vg=;
	b=u6YwdQfnQ6Sb2ztdBAaTkS2M+dvlcp7tbfBIP/aoll0nqrg5z2xAZlkc7XJKQE+iOhTz
	 cGjip1BKp4ROPZUci7cYwQmqNMwu3TXDMCVT0WvTfZfAgJxnXVqylBGpdCdcRU5nZ2mOe
	 DOLkYPY9o6dZAzzW01jNyurVfUuYQL8B/3cbRImHbz4uSpOY/+wreSvk79w5E6bbb9fEG
	 U1KmBJoK0tJC/VHGSRjYtsqV0XkA82GZ+e4FNfuurqnB0GNT6qOBsT+m2mymL2BgFOxqO
	 FQ/x/uZIFcDKW4o0nYWZqpOg0/DD/PFcyKUSyHAXaoBsfQh6aQH1e5asajcFo1cun0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lf6Qxmty;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD7A606A32A;
	Thu, 19 Nov 2026 00:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lf6Qxmty
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D291F000C4;
	Thu, 19 Nov 2026 00:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048827;
	bh=12O1LzUjjwAjZEuprUDMiZQDcEQt7VkNjdNIXcGQ6vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lf6QxmtyWIbukiqCDP79eLR282f/nzdwpDT8SHckHHjWvGcWg4wLpPCDH94efTBER
	 mpicdz3zc5gmCDALTwE+3ag816+10pBkuvZJpEkEBVbdEfr00XwHlTGQ0jdWEkvceo
	 AXgxhto7tOpk2j/pGd/Kr9+gsxEwSpAajT5b1Mls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2135/2857] RDMA/mad: Reject receive completions shorter than GRH
Date: Wed, 18 Nov 2026 15:52:49 +0100
Message-ID: <20261118150318.275419435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




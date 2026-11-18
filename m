Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061026;
	b=4wW5xWDxK3MIXr3ArZEUlrLG51zU+LWM8Bzc21yLKAjfBv3kTntlDskXo3KFCK+7Q/sr
	 GiPBzAwC2w0wTBOHl5G2KISedcDklRTkqyt9MlmB14kW+v4VtHUDbx2tgTnKH7I59ulUi
	 p95Umiyedlx+0T5X6sXcScVOm1f52A9qMJPcX7GMiZxyn6FY1RO3tTjlk1p7l10/Q9sNS
	 6ClhX7Hb9rGj2ht+lhB9Rvu2ThxgLzG/ZbffUvHbBJOwLlQxfeNOv/rSKTaWhQgiE7kRC
	 NsyVwCvaCZugfRetbX6GgsF9Wl617lx5t1vVrylHfXCcer6QuKtpOBOtSarn1Wi/mIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WY3GiFnRADCfRuQbPdLznUrb5FUvQHbGa5iiHCfgVR4=;
	b=oyGK/njQUo2fzLtk9D+hpX/QIgpVgvxRaFYI0tz9C2S3rmaGtroGDEt+6il7RGI/Eonr
	 qrqX5r097FqcXMK9ys0oigAjbAtr1vPj6VLR+BWemTOtm7M4X4rnh16+YWT2WJhk/Iitb
	 JWr4fs6nSF4tfNUFfpZkXZiikppRZM17Tjy3JoeyrDNwAP0KdrA3BVwvrWpS+xNj3xMRf
	 c2vCM+SUMW9Oxg+2Uym/GOYrcY1oVx8slmaj6C6Eb64umBgjtK17fVAsxgNfC55/r39mq
	 wUlMsrWkttOE3HCicGSGwciLNh5ZGrJnkqqOtndqOsQP4K+94atkJIUXjuY0jCGf38A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxjWjTbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA1C606A326;
	Thu, 19 Nov 2026 04:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxjWjTbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AED41F000C4;
	Thu, 19 Nov 2026 04:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061026;
	bh=WY3GiFnRADCfRuQbPdLznUrb5FUvQHbGa5iiHCfgVR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxjWjTbrCUMselXpAZ2fQCd6hkJzTgWF4SWysdMjvKeI9rzexI6Ri16ffzAEFBvXC
	 ox70e+hBB9VMmZLKRcpFTKl6JEedEylXrMPa13KseqG5qd5FdF2ZNdvKat2j+Z/m+e
	 Loh+tltGU558VV4rd1EDwazQfxKHdWc/7NtHelZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1406/1848] RDMA/mad: Reject receive completions shorter than GRH
Date: Wed, 18 Nov 2026 15:57:24 +0100
Message-ID: <20261118150018.364899531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1be9513b8966b..edb045c08494b 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2090,6 +2090,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			    recv->header.mapping,
 			    mad_priv_dma_size(recv),
 			    DMA_FROM_DEVICE);
+	if (unlikely(wc->byte_len < sizeof(struct ib_grh)))
+		goto out;
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
-- 
2.53.0




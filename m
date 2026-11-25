Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625566;
	b=F4AUnZqRr4RMUPAhav2goh1cqyBsvrYb69Vw56OTPnDd7QDu7AF/gTZm92EFJDlgDMf7
	 Y5qm/4wjHhi6XIE30RgdK2fgawULPKHzaMT5EBPyVmeYLdFK/AkIsOoku6B/Qlf6nvuFL
	 CDmwf+bqmEzEvp4TXxlU5IJRnYrb9n4Cp6Rz8tRquZAelPMAapcmPei86VKXC6B6GICSc
	 Cc5PVSvsdM5VRo1l6D95Ld+xVA16F7FZ5DUWgLrV2kurDPvM5gtky42dzGURGkB60jZ0n
	 hy+Vz0mmOrkB07LioefazMfbYOyEZAnWruNaq//bn/gstsev/7UF7zVs50llmZskbsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UTCBr5HPAapEyp8kkwkHlKuDy081WuMaQ8DFOKK6UYk=;
	b=GH8xEwYFYJq2eqpcX9D7Nlb1LiZUtgXji5m4i17w7zOAixvnLy+JKw1+aIFzEiyWJ+V4
	 +meGyCdGC6QWwEpLa3ZkeA4dPO1rn/bdlYVDvshTmtHP0qu8BHqZcmDx/qTpFqDAiQtUI
	 zJ3cLPWCJf6A5PAQoakGIlwIEpPehSLl4YJhxcvqwv4HApFk8Mm7S8ht8BRGx9a2AQtvg
	 /JY2KUYKIujijr4zvD3We12kuyQPdYEDCguiQKwFTLqGbMucsBrsCL8Gt42Gf/OEnGrJ8
	 bGR7pfG3TgNhzvJU4sNZVy7Ar/iri4ijCjWDE2ArAQFY8WO/hZw43UeFhwcVCVHzQdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BYf6/wsm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4173D606A32D;
	Wed, 25 Nov 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BYf6/wsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF4A1F000D8;
	Wed, 25 Nov 2026 16:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625565;
	bh=UTCBr5HPAapEyp8kkwkHlKuDy081WuMaQ8DFOKK6UYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYf6/wsmuMDcvOus3z/PrngkXuM9OX97/sLxEt4hZnPKzdGb2ke72N2Nz8sdGB1/z
	 jn9DBnQqykFu/3S6Z1HhtWk4FQNnwtP0V/v4yh38kqGK6dE89LV/9CyJgM7JhHYwgK
	 Xqd+HywWEMRhICUvKnLpgBz7VuJ7NrhZf20UCiDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anfernee Cao <anferneemelokc5@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 557/816] mmc: mmci: fix DMA channel leak when mmc_add_host() fails
Date: Wed, 25 Nov 2026 15:35:05 +0100
Message-ID: <20261125143902.078952817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anfernee Cao <anferneemelokc5@gmail.com>

commit 2d8927fadbf95e2d2dfa95bcc73882d6e19c2ce4 upstream.

mmci_probe() calls mmci_dma_setup(), which acquires the RX and TX DMA
channels via dma_request_chan(). These channels are not managed by
devres, and are released only by mmci_dma_release().

If the following mmc_add_host() fails, probe jumps to the clk_disable
label, which only disables the clock. As probe then fails,
mmci_remove() is never called, so both DMA channels are leaked.

Release them by adding a dedicated unwind label, reached only after
mmci_dma_setup().

This issue was found by manual code inspection.

Fixes: b38a20f29a49 ("mmc: mmci: fix return value check of mmc_add_host()")
Cc: stable@vger.kernel.org
Signed-off-by: Anfernee Cao <anferneemelokc5@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -2484,11 +2484,13 @@ static int mmci_probe(struct amba_device
 
 	ret = mmc_add_host(mmc);
 	if (ret)
-		goto clk_disable;
+		goto dma_release;
 
 	pm_runtime_put(&dev->dev);
 	return 0;
 
+dma_release:
+	mmci_dma_release(host);
  clk_disable:
 	clk_disable_unprepare(host->clk);
  host_free:



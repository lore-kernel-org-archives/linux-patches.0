Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705476;
	b=Ob2+9ihcUOlimXfpGEaACYq4k9dFSaIoG5qDbZpbQ+cNljXPtgYzCbIEtBECw+Y0rTQH
	 3uf2sPXxnVMqsx7RurpS5iyrdVcHKmQQp77mF6JgC53TFZhqbWWqK9b5W52VHLk9NSoXY
	 iTK0GBAcPfTg09irMDVJbShw42wo28/NjXGJnOMeJLmETKB2XunPY2QvVn5ZC/kZAFRSD
	 GN6Nz+sOKdUxKRcLeq3zsloiWgKeQfwGDIDN08W2DYaWsW1B+ZeoMXIvWudHTnUpK52Og
	 cYQOHrts0Szceia02R9V2iinJj3rIpBhKIr5egLrmLhy54AqfxC00yPqnmUgRyHVAyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WF5ayepRMMp6vPorBsJooguvE0hJoipLIs8TSJ4irvY=;
	b=PI8mb25+4QMyS7TOZAEEMRGem7BQ2bvDThbiNo7bhwBZk3XEF9LWs8yK0PPoHS2cdYwS
	 jiUlTIZyznuLDpli+f9vVV3Jvz3BwB80/u0nmoFh0WybA6RDELLRY5MjUPUnKo+bMYcCB
	 n/7kgzLr2jk6d64iWG8RF8RedwyYbeoBn6rWG1opD0FrtTA/d5RXZQfbEwy8YgopEMK2e
	 HaVTOnGxSX8mlR+6S7pWlqSuI1CP7yHQl9s7UZYVXX8kXBvKO05RLiy3vAYJvymW0PLvT
	 RdlnvfGeo4KhqJzhBv3CZcd8nmumg9bCXP66/0UhxgLUTidbu5LQuJrwlfJE+EN4l3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXuz+0aL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADA3606A31E;
	Thu, 26 Nov 2026 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UXuz+0aL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0FB1F000ED;
	Thu, 26 Nov 2026 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705476;
	bh=WF5ayepRMMp6vPorBsJooguvE0hJoipLIs8TSJ4irvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXuz+0aLonMnFMMHYA7qgX8AwLmY4NDCeKCvXROZuqOPFt+b2jDy1lBDmzIXertq0
	 1dTsSspV872ZVuVlLw5SlkCP2NZYgjnWb81gy+Ae8AknYIQY63KSVelAR8u0BXViW2
	 LQo4Of+gtXQJAoBF732t9gX12ufvXngScYcpkGU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anfernee Cao <anferneemelokc5@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 174/319] mmc: mmci: fix DMA channel leak when mmc_add_host() fails
Date: Thu, 26 Nov 2026 15:39:02 +0100
Message-ID: <20261126144010.673303472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -2257,11 +2257,13 @@ static int mmci_probe(struct amba_device
 
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



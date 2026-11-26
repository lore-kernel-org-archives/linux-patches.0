Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704634;
	b=YBzx23egwKV8f6mKNErFlRDuxAzRHaMDXY/qJ4h08iQ8ZADEbvBiLgCI2Vh/QPFEGYUR
	 42djuyZmdTBawMZINQSSakv0dqXGsc8VQ8PvMrsv/aiC5ha7c/fvQxVt7LGgD/fKw/5Z3
	 WiYJz4m8L8hUG9NI9HHNDTNU/I6EpeNun6lyxm4b+jJI2naJnYxlCkObuT3qsicFf6Myj
	 vUzn2nA0SbBrsRWVptqxXSNHgYS1eq78B63xhbEWk/qlLng2Ob6IzBHDhiSEGQDkVXh9i
	 a72DfLaVtNeqhvpCcdAKYXanO3ry8HSCMfrmFiMNpfeTqzYp/7QhCBrbLOG5HC6ZIGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3b55i0hAZST4XahsxqGcrgCWZxRBXWR+oN1d5R4jIno=;
	b=RVT/FTTKa+//SI2O3J5+i22om0o3ApgSaJJAIO3ChjirZbksXqwPQ38Yc48cswzU98Th
	 2ju8eKFoqvdzAkqyjHe0WSK914pb7VdMn/FYkeWCb4mxlz7tJftqRKNYD1clXthC7GMrb
	 2AtdtYarf1i4x/FOFjPb+GWICnp83GX7I+Bgxkg8Rc6o99D5zM0K6RZe/egWekf8BLwXa
	 S1cCfd0E5rWpeByVZMEwVTj8zYruqZxcnGW34h4WJl5HAt0Zz/5XfRQuSf+4mT/1+gY4e
	 fredhm2loyo/pN7jLQOjCKJBkxwNE3QHSEjfnoIQVrhz1MXRbSOM2IvrEhx/1dwJ9wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLQZoEKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95F0606A32D;
	Thu, 26 Nov 2026 14:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tLQZoEKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32E91F000C0;
	Thu, 26 Nov 2026 14:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704634;
	bh=3b55i0hAZST4XahsxqGcrgCWZxRBXWR+oN1d5R4jIno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLQZoEKKW86flKOoicJspZZ4U1DcyQaXG/zAFNAL8aQYZKal6CelRsUIL7ZeYM5OE
	 3d5nIItu78HZ7bL+7wYOQzJ8MZiPSpoOen5Huy4oIqgcFA3hfDBMqgodNbcp2FQQ4F
	 +NRpruKdSJsjXJbrQjP4AhI4JsZe2pZGpw4ss064=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anfernee Cao <anferneemelokc5@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 146/265] mmc: mmci: fix DMA channel leak when mmc_add_host() fails
Date: Thu, 26 Nov 2026 15:37:56 +0100
Message-ID: <20261126143615.259210070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -2194,11 +2194,13 @@ static int mmci_probe(struct amba_device
 
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



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622827;
	b=byexi9J6ffdU2XBSmvU+nbBVysb1cOBIzHWbHyoq6ZPaCXKuPVjdNp+3vPbBCUTfAmsV
	 D5XkpvSxj1IMvbC4W1MtFtOYy2albPepodjMlxjeRfpUOwRqJBAzg1hEuu6lTZJAu/oMQ
	 Nm8Gvk+H7pWcfqZ75x9GQOWQU+VnaX3pWVKmk1OMRb8xLB8wPGumP7mYbmdDsYM47F6Ln
	 NWAy6NSpriPHWK9mgNQLM7EUccDim00KfgXr0/Jp2fCr8khnJiDN9TmMj+jy2khntQCi4
	 keuP3RJc/aq3d1z6iILCYtGwTMQ2MGem80GX8lxfjf2dFWfD4oV9gJk9BHEHtSI7/EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hR5FCWkJm4OWBdnDi2SdIrqdTHeKASl0DGw2F8J4pag=;
	b=NHZQXTuTBf0VFAtOSZxGTG0vlBBmFHzogntYG+ghW5e3aKL0qqm7EOJmJaNwfgSZ7B79
	 TwGiXTpUUJ7IdFCLQSvYq4PdlkrikQEC74MCEjNmtavOKjeeWh9BhqFueExXsmSjDM8se
	 fpYFghfpeXxdrfjmtTF01ef61IQQr9oxRDFJhRm9Bykc+yZEXXO7Nc1Df+nxD7dGvbr3L
	 5qQG4Aw2tpROJgZErd8RsSWJl9Wh2qnX7TXtgREn1KH9ycmx1N7ZeRmXfpFKThVdswTVq
	 RMx9/Dvlm9K5X9v7ou0zZ4cfZdLzyueG4qbS1UHg4IYSBf060r3Y/dPDJnR2Ge+PzIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNgVSJrY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8D9606A681;
	Wed, 25 Nov 2026 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNgVSJrY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF18D1F000D2;
	Wed, 25 Nov 2026 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622827;
	bh=hR5FCWkJm4OWBdnDi2SdIrqdTHeKASl0DGw2F8J4pag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNgVSJrYWxyhSxxi1X2SPgHSEn+KiQgKcVXjidH4eDIcrEwPvExvKRFJ5FP3x7xfr
	 Ao/aXaoJxzuagjamgVoupRNO/ifYn6cKQYaEmXWt9oWBlCUkn01zLB+/mIB8NouiQ5
	 mmYE/tWvJ17/m7NKT8VntzUZGy4MyKwoL84k7WAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anfernee Cao <anferneemelokc5@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 662/990] mmc: mmci: fix DMA channel leak when mmc_add_host() fails
Date: Wed, 25 Nov 2026 15:33:49 +0100
Message-ID: <20261125143837.597252371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2477,11 +2477,13 @@ static int mmci_probe(struct amba_device
 
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
 	return ret;



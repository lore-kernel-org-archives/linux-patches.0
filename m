Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619388;
	b=sP/IqqRqDcfd/M5WmlsZ+xg/4YzeGRF3vEwWhW1qLBjxuAiqqkKv1it1T1szVWJDNTHZ
	 foylL7sNxezg+gjThs/KwDPPCsMZw8UcuIvzLKD8Q4OgBh5SMKTBPmyN0rzgc5V90NuvO
	 nxPIUZV6Og2ImaLF4zHigs5y5i5VJEyZn1X08miLEbWSGxmujEsy+GuFJuRtIDy+bJVJu
	 ijsC8cOz5XHlJUu8gETX2nCg6ThS+9Ld0ubJWL+GWZ8nLYndacOa2VSwD7CQ4PkJ5ZLW6
	 kBpyfFq4kiUxM1kjqJZQrt6n2nq9ESpzqZVkKXotm0JO00o6BNDcqFRE5hd44I4flQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FhCU0481ncXoCs93cZvgktHgSQcwBSoPncaeWnxkOcU=;
	b=Dewjx1D6ojb6/B6nmN1EA7DoRixubC45I2uv9uMBlEc9yKkHzhuA+L9ACvaL5ZAHnhJ/
	 NtDkeC/z606Wbj5jFkWQgk8Bkm5RAkkOvlHpdIRHI8tO1odiq210H52RksNrAVZnbiILG
	 n+mW+/g77HTwurj1lnK8h8JDxd7dG1IfK97/v1ouSEuO8gwcYgPSZ7jUV8sC5ElRpa6mH
	 O6YT0X1oejca1XH1jpDRhSg0/Y+XQtun9x19EOcg6xvohOInL74WR0wX2NcosLP6Jj3xM
	 zEiag0d8sjdzme69e+ovCwYWMej/z2Ay+mH4yJUs5m8po9cehR9KSLxGzSSAX3+C1Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQ50E0yf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC40F606A31E;
	Wed, 25 Nov 2026 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQ50E0yf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63741F000C4;
	Wed, 25 Nov 2026 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619388;
	bh=FhCU0481ncXoCs93cZvgktHgSQcwBSoPncaeWnxkOcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQ50E0yfyjuY13rYtPIcwrQZMHx2Lv9xtQbi7Y4TP1cZorhqRM9XK5J45YM/A2RVH
	 Dj135QKwCs3ZWjgN4Kvo1aMP6MoG1Pxd2R+jUTbzGJK0gkSCrBRK/u1R4BUIFmdmbH
	 o/VIFBWQ+hBuFkIeGPG9sO/dDr39BWeDHPSLgbCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anfernee Cao <anferneemelokc5@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0579/1005] mmc: mmci: fix DMA channel leak when mmc_add_host() fails
Date: Wed, 25 Nov 2026 15:31:57 +0100
Message-ID: <20261125143835.312436615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



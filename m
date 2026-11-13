Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590642;
	b=Asbt2cqWZJZkJXt7YiDuN9a6MFaLoDFTHh9VAzietnE1mTJRLRdTVKJVAOzK2I8ygwtQ
	 9mv570VtTtxndhIdJOXOdP0NrQaTZqo88hXi9dNAcSexeq0dNLLLuwexBkg483jGc912i
	 kxpV9+Mi8sACrVxTQu5htJCB+jKbaCbNiw5Xql2wwDuAD3qrkbtKeYeq9wX6YLq+nFjEX
	 5crb3XWiYcn6sUBoxMLDc5vV/CJKzWMDEQFtpaPJpn67W3MuSpRqtLGobC+djFrFUNZsQ
	 Hc1oUjapHhWAgrrDtkWTWtzKs3UNqclEl+DbWW/uODcjEi01vjnpNFmOWBRKyGWhiFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jHqR/CzwHraIMkYvx8MTzNxaQJaWYxz4k5j0EByj1lc=;
	b=F0Kjk0k9nFVM9RKYxOKVglKJ7b716vqZwY/O44x3K7NBxapg7PwihOtDptjXsAAY4Pbw
	 dWyxB9DwQ5pPUQACCJqvVHZNKqBpDjOXg0FYRvjlgjyGUT4qJrvsx86rIW4dM1LNYBpGJ
	 P7x5vFEutq0y3ceCo73IkOot8Xqluu5iflKpeSTTaCw14J/FOWl7epUmM+1sPDi/pd7pH
	 /R1PYbtFl/4C8FprBWzna/h08mB6cuL1865DenGV3NZy9TWvL/EbBjwut+VF4E1wGP/RJ
	 dDsPZjlLQECzLMBy1R6PxRvwuH2QHI3OQTMxPXGHA88JoOL6fnPegcTieINBggewcxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0R9hD911;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8566077D5A;
	Fri, 13 Nov 2026 17:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0R9hD911
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4521F000C5;
	Fri, 13 Nov 2026 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590642;
	bh=jHqR/CzwHraIMkYvx8MTzNxaQJaWYxz4k5j0EByj1lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0R9hD911qMgJZM4FSYr/W5SlC+xESbKojJrhddozNRAfWWWtWTTx6LYP2B7FA3QRP
	 fiEKKh+9oNmC4akxr5dLlYrmx4o3/AaxFpAd/z/s47WQpsLLT/e9VwZj+I6xEgci54
	 O0tdqcCeZP0RGfZg+a7/p2D+B6whPOl8+h5luk/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/686] spi: atmel-quadspi: balance runtime PM and pclk across system sleep
Date: Fri, 13 Nov 2026 10:51:37 -0500
Message-ID: <20261113153840.767108119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 717e45f97246d1070cdf86ccd7a0fb872b45933a ]

On the controllers with a generic clock (SAMA7G5, SAMA7D65, SAM9X7 and
LAN969x), atmel_qspi_suspend() takes a runtime PM reference and returns
without dropping it or suspending the device. It disables the peripheral
clock directly. atmel_qspi_resume() only prepares the peripheral clock
and then reinitializes the controller with that clock still off.

On a SAM9X75 Curiosity board, the tested standby and mem resumes
failed:

  atmel_qspi f0014000.spi: PM: failed to resume: error -110
  spi-nor spi0.0: resume() failed

Reading the flash afterwards returned no data. The runtime usage count
grew by one with each cycle, and the second suspend disabled the
peripheral clock again:

  WARNING: drivers/clk/clk.c:1257 at clk_core_disable+0x6c/0xcc
  qspi_clk already disabled

Use the same runtime PM sequence as the other variants. Suspend disables
the controller and forces a runtime suspend. Resume forces a runtime
resume, which enables the peripheral clock, before it runs the init
callback, and drops the reference afterwards. With this change the
tested resumes succeed on the board in both modes, the controller
returns to runtime suspend, and the flash reads back.

Fixes: 5af42209a4d2 ("spi: atmel-quadspi: Add support for sama7g5 QSPI")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260709112006.390742-1-robert.marko%40sartura.hr?part=3
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260923012950.15651-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index a917530f81741..d3c14e2ec8c86 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -1543,12 +1543,14 @@ static int __maybe_unused atmel_qspi_suspend(struct device *dev)
 
 	if (aq->caps->has_gclk) {
 		ret = atmel_qspi_sama7g5_suspend(aq);
-		clk_disable_unprepare(aq->pclk);
-		return ret;
+		if (ret) {
+			pm_runtime_put_autosuspend(dev);
+			return ret;
+		}
+	} else {
+		atmel_qspi_write(QSPI_CR_QSPIDIS, aq, QSPI_CR);
 	}
 
-	atmel_qspi_write(QSPI_CR_QSPIDIS, aq, QSPI_CR);
-
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_force_suspend(dev);
 
@@ -1574,20 +1576,20 @@ static int __maybe_unused atmel_qspi_resume(struct device *dev)
 		return ret;
 	}
 
-	if (aq->caps->has_gclk)
-		return aq->caps->init(aq);
-
 	ret = pm_runtime_force_resume(dev);
 	if (ret < 0)
 		return ret;
 
-	atmel_qspi_init(aq);
-
-	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
+	if (aq->caps->has_gclk) {
+		ret = aq->caps->init(aq);
+	} else {
+		atmel_qspi_init(aq);
+		atmel_qspi_write(aq->scr, aq, QSPI_SCR);
+	}
 
 	pm_runtime_put_autosuspend(dev);
 
-	return 0;
+	return ret;
 }
 
 static int __maybe_unused atmel_qspi_runtime_suspend(struct device *dev)
-- 
2.53.0




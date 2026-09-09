Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECFE4B5CBD;
	Wed,  9 Sep 2026 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961782; cv=none; b=f60PY9Mqy3gBBmpNfNGVAJJfPXgZjxgiS5fqjXU/+W3EUMJgv60C3GfYKqpE72zNy/45oUKYd3hDb/YQEqc/es3OvJrhkRKCNXae3lu1AbSjgYLRVijZfDuI6io2iPBK2Sg7FH8ekryWdf/SFjDkDkRbbRrkNkKm+cc1e0IVARg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961782; c=relaxed/simple;
	bh=9s5a55Zbbas+cUqnbz8KqL/1ma/eWqMZLVoRXvSK45w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYgxoHQayqL2mOKhlc2QsnZuBDnEjLODtzKEPLFD4PhqjZYupJOLL20EV3XK9Jxuj65bNDtRnC96DPhlpySIqQJkmTM0uS34br7nxsqZ7z7wOoxZv1VPfQvb85jLV5HybvV3ehQ8ogwGiOlTAIvd1KyhSzzw0p6Vshr4tQVaD50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIW3ViJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIW3ViJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0ED1F00A3A;
	Wed,  9 Sep 2026 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961781;
	bh=g+RmFo67VyFVchAsl1T5skTaYn7uq0d6YJhICSM81OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIW3ViJ1VTpP28Fs7g+BBp7EGNMbkdrfkJZo8rv/wlXBV+CQT/zq9QaoooKE+9uGk
	 FLZhl/Vg8LfBL9/uW7mE2lUs/u6PNtHMAaB3/GfYfQA6lJ6myG1A+1EDzh4x1CQIgg
	 ULlQveTHEIDvtYpZ6Bp56+C0oHs7DymEm2QW8U3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 064/556] spi: bcm63xx: disable clock on resume failure
Date: Wed,  9 Sep 2026 15:35:44 +0200
Message-ID: <20260909134232.717447249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit 2b62c2c134fa32d9d3a9e7323c8ac74518eeb4ac upstream.

bcm63xx_spi_resume() enables the controller clock before restarting the
SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves the clock enabled. Propagate the error and disable the clock
before returning.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Link: https://patch.msgid.link/20260804071831.860784-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -650,7 +650,11 @@ static int bcm63xx_spi_resume(struct dev
 	if (ret)
 		return ret;
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }



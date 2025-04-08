Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7C4227EBD;
	Tue,  8 Apr 2025 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112522; cv=none; b=qNP6rSz1LeflgbwyKwrscaUYO6NFNadhX8emPWEWYp+rltvVYaPLbsXpbvT1sTYAvQkkST7jCI6/maydrAf4UUS/Rg5YWktDn6M2syr2wCFupG6CYZ7MSgUX62wGxKBE5Pm82KyDKi4YOmMap9Jfq9xK7lxt/rLLSA4pWqYozjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112522; c=relaxed/simple;
	bh=tC9o6cX0nO0ZUc5hKOeRpXJR7UiuLgBCetzv9XoPqVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psru0fiEyg6JEXO96sVNjLVorui8Plf6feO4b/SUp7zHSTRNE45i292IB5ak0TSsX/9Z64gLAYGTbWMeujYhze78yQU71Tg4QN7hXISE4G+1fA7AOtXMjkOSf/mu1HMCmV7aK6hvk/7K0/Zdx8OIFHyV2xwD2Vrf5sWXX5ftmG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdkzPCf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdkzPCf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A12C4CEE5;
	Tue,  8 Apr 2025 11:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112522;
	bh=tC9o6cX0nO0ZUc5hKOeRpXJR7UiuLgBCetzv9XoPqVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdkzPCf0ZvqJ6mjWE5t50Nrydgh2I4qHexaeQI3gesyrCHnCd1pgQRJqbKZ5FmEmH
	 d0SiYEenBUFBuIC4B/3c+eY5p1NAgt7WKTLragn4eIDYvt1/ks3F4zapeZdl8vRPJu
	 AmuJaf7dXjnkuOdmeGxfz8LnLo/VNzu8rh5y6XVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gu Bowen <gubowen5@huawei.com>,
	Aubin Constans <aubin.constans@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 099/279] mmc: atmel-mci: Add missing clk_disable_unprepare()
Date: Tue,  8 Apr 2025 12:48:02 +0200
Message-ID: <20250408104829.024105604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gu Bowen <gubowen5@huawei.com>

commit e51a349d2dcf1df8422dabb90b2f691dc7df6f92 upstream.

The error path when atmci_configure_dma() set dma fails in atmci driver
does not correctly disable the clock.
Add the missing clk_disable_unprepare() to the error path for pair with
clk_prepare_enable().

Fixes: 467e081d23e6 ("mmc: atmel-mci: use probe deferring if dma controller is not ready yet")
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
Acked-by: Aubin Constans <aubin.constans@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250225022856.3452240-1-gubowen5@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/atmel-mci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2507,8 +2507,10 @@ static int atmci_probe(struct platform_d
 	/* Get MCI capabilities and set operations according to it */
 	atmci_get_cap(host);
 	ret = atmci_configure_dma(host);
-	if (ret == -EPROBE_DEFER)
+	if (ret == -EPROBE_DEFER) {
+		clk_disable_unprepare(host->mck);
 		goto err_dma_probe_defer;
+	}
 	if (ret == 0) {
 		host->prepare_data = &atmci_prepare_data_dma;
 		host->submit_data = &atmci_submit_data_dma;



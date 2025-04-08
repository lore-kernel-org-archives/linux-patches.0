Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A2326AA85;
	Tue,  8 Apr 2025 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113903; cv=none; b=T8joO3u9BXevwzeeHTogjnH4OkEqcoiHSu6Jlhhde6JZ3fQuuKz4ajVdzfUzf+dPutvcxr1ALYflIa33JmFu85yHR7duRyou2h/K1AVKCG9adoXiqcpEoS+WCgunH828RqnZanjQxdUl1XTxAW+sxi6pH/T/5bCBtuYXlyUaa9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113903; c=relaxed/simple;
	bh=5jHgiu7eqOxHSAyHGRjgP7xALi5YAi1Gltd1/C4+wec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6Mcitb63GrmzQl/fCK2yNeRen10IRtQ8ZlJ5rzxSawBF0EUhbSisaNGcmNCeM8Fbm5huYSZxnX4/nfwItbDHouT6H82VnJGA76jZ4qSGlPlBS5WCI8yN8ZlR7Bh5/5U5sOXxIt0gznKRfn2W9wqb08si53gAGu+XFBCB+PxVQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQdN+0y6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQdN+0y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F10C4CEE5;
	Tue,  8 Apr 2025 12:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113903;
	bh=5jHgiu7eqOxHSAyHGRjgP7xALi5YAi1Gltd1/C4+wec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQdN+0y6FECObWusrdQ4zsjgBJEN18KKu91jvOkOGii/LZs2pfASQo80Jf7ITN935
	 n/izJ3S/3F1kqBp+gresNd52IWACIaFbhMzB7e77xNycPGGkttlXsWhp1EhHdPNcxi
	 yJ+Q9aJNuhFNApGxdagnnxZbbmo8iutfISr6JwEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gu Bowen <gubowen5@huawei.com>,
	Aubin Constans <aubin.constans@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 062/154] mmc: atmel-mci: Add missing clk_disable_unprepare()
Date: Tue,  8 Apr 2025 12:50:03 +0200
Message-ID: <20250408104817.278854240@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2502,8 +2502,10 @@ static int atmci_probe(struct platform_d
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



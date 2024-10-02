Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC34E1D0E1A;
	Wed,  2 Oct 2024 14:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878803; cv=none; b=swIGePcZLO5uSoAcqzo6HxAA9VFA0K1UIRPjwQhutRSjRO0d9pDLktFb3FA7QbI3Mv0tAiI5Qdpa3ryFG39IkXeZvLlOpy+Zcw2JUvvJBLe96S9+Cuqh7X9ZbutKHrVD+FTxtnds7FJK+0u5+JaiUdXBtHUsYJvCd448wJ7ixI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878803; c=relaxed/simple;
	bh=0lY4y5+3boCg4QWH14f3OgnBHUHpwfZTWURwXRdNpUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NMTsBp92LRhE6JeXClRnHjRcY0EmcjcDs1AaoMfOYIQvPwrfWpa4Lzfih+UV7y4WlQhfY0Oi1eG/FUc239JYLnr/1XRieIaLeOQSAeDo0Co9rI4jivP8PNLxeBAN8MsAWjuxMDIRzUq73bleUPYUp3jogZS7PlBj2XOTcjGcqOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q78jvqtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q78jvqtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B426C4CEC2;
	Wed,  2 Oct 2024 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878802;
	bh=0lY4y5+3boCg4QWH14f3OgnBHUHpwfZTWURwXRdNpUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q78jvqtbbsn0Sf7AnoWsAOz067qKZACT/nLM9YErcyMtutRYU9MjkdLYoCUNmwTJT
	 LH7MhFwWDzAr4qhrsEmpmR4uacgUnGxU3I/eV7LLnQym2/HV5Og01mI8qFOtZ7ZfQt
	 6cWQA0OzRT3vRAlItlZtUt04nVdx5X53ahSf0M+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ernesto=20A . =20Fern=C3=A1ndez?=" <ernesto.mnd.fernandez@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.10 536/634] crypto: qcom-rng - fix support for ACPI-based systems
Date: Wed,  2 Oct 2024 15:00:36 +0200
Message-ID: <20241002125832.265869611@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

commit 3e87031a6ce68f13722155497cd511a00b56a2ae upstream.

The qcom-rng driver supports both ACPI and device tree-based systems.
ACPI support was broken when the hw_random interface support was added.
Let's go ahead and fix this by adding the appropriate driver data to the
ACPI match table, and change the of_device_get_match_data() call to
device_get_match_data() so that it will also work on ACPI-based systems.

This fix was boot tested on a Qualcomm Amberwing server (ACPI based) and
on a Qualcomm SA8775p Automotive Development Board (DT based). I also
verified that qcom-rng shows up in /proc/crypto on both systems.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Reported-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Closes: https://lore.kernel.org/linux-arm-msm/20240828184019.GA21181@eaf/
Cc: stable@vger.kernel.org
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qcom-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index c670d7d0c11e..6496b075a48d 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -196,7 +196,7 @@ static int qcom_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->clk))
 		return PTR_ERR(rng->clk);
 
-	rng->of_data = (struct qcom_rng_of_data *)of_device_get_match_data(&pdev->dev);
+	rng->of_data = (struct qcom_rng_of_data *)device_get_match_data(&pdev->dev);
 
 	qcom_rng_dev = rng;
 	ret = crypto_register_rng(&qcom_rng_alg);
@@ -247,7 +247,7 @@ static struct qcom_rng_of_data qcom_trng_of_data = {
 };
 
 static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
-	{ .id = "QCOM8160", .driver_data = 1 },
+	{ .id = "QCOM8160", .driver_data = (kernel_ulong_t)&qcom_prng_ee_of_data },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, qcom_rng_acpi_match);
-- 
2.46.2




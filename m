Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19E64570D4;
	Mon, 31 Aug 2026 13:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183834; cv=none; b=kzgSV1++9MOxROMoI2GHUdp+TtIiUToY3fFLl9HT5m30Urq4oBMXsOA1AIqPPhgPXl18je6I4e136B6gC9ERweSV5Coh2j51TlsosqHkgiXA5D6ITUVFmehoLKz4gg7TAm+bdyeoC4sAXrK3lTy3Ogrv3PNwpY4VgzeTrd9B5HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183834; c=relaxed/simple;
	bh=dwuclEBxUMqllUW2F2Gk2VlrrrPMnoB/eIuvLtoXP/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGhXspk5qywqnJNNWPi0TD7LUWMsPzqpRR5wPxTmp+OIs4wY0HyNc+HbkSnpSwlQl2wyI7u2AzgetTnarnkNG/tu6AlW4P5Py/BJHuwICUxrQ8GAcWi5Zrs8vyu54tVRW+5zCvj0Dhc8KY606GH0n4yLk5TJFcjjvin6G+W8e9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQHYgSl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQHYgSl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006601F000E9;
	Mon, 31 Aug 2026 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183833;
	bh=okCM7ixOL62lAgxiLTvWPrK+VxVnBcUpbdUQE2K8BPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQHYgSl9QgXn6pZiTFdoGWp1XwTBfrA3MLGdDeiYtoIBAZlikVMU2hpIJoUHWmCS9
	 HduPqFd3/0KxoySDaS0dxvsA1fpCFScfYqas1GSoEncPqrqcFCFSx9hw7CwGOyDHNd
	 JzWxHomaSAU63PRip/TFl3vw2aWHirc2XefkyTdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 57/76] crypto: qcom-rng - Enable clock in hwrng case
Date: Mon, 31 Aug 2026 15:34:29 +0200
Message-ID: <20260831133402.403870972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 0fd97bbda2842d7dcccee599ac2c0e9554bdddbc upstream.

Fix qcom-rng.c to enable the clock before accessing the hardware.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qcom-rng.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -113,6 +113,13 @@ static int qcom_rng_seed(struct crypto_r
 	return 0;
 }
 
+static int qcom_hwrng_init(struct hwrng *hwrng)
+{
+	struct qcom_rng *qrng = container_of(hwrng, struct qcom_rng, hwrng);
+
+	return clk_prepare_enable(qrng->clk);
+}
+
 static int qcom_hwrng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
 {
 	struct qcom_rng *qrng = container_of(hwrng, struct qcom_rng, hwrng);
@@ -120,6 +127,13 @@ static int qcom_hwrng_read(struct hwrng
 	return qcom_rng_read(qrng, data, max);
 }
 
+static void qcom_hwrng_cleanup(struct hwrng *hwrng)
+{
+	struct qcom_rng *qrng = container_of(hwrng, struct qcom_rng, hwrng);
+
+	clk_disable_unprepare(qrng->clk);
+}
+
 static int qcom_rng_enable(struct qcom_rng *rng)
 {
 	u32 val;
@@ -208,7 +222,9 @@ static int qcom_rng_probe(struct platfor
 
 	if (rng->match_data->hwrng_support) {
 		rng->hwrng.name = "qcom_hwrng";
+		rng->hwrng.init = qcom_hwrng_init;
 		rng->hwrng.read = qcom_hwrng_read;
+		rng->hwrng.cleanup = qcom_hwrng_cleanup;
 		rng->hwrng.quality = QCOM_TRNG_QUALITY;
 		ret = devm_hwrng_register(&pdev->dev, &rng->hwrng);
 		if (ret) {



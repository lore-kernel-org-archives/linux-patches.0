Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6713F566C61;
	Mon, 31 Aug 2026 13:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184084; cv=none; b=FHDbVuG/AmyYXPSBIiosDHjzIN0x56/O2W7Wvirpg5HydwcY96TYFBFAVZtENNCvlkTjcLxWxAmSTeziYoZ7irEf887e8xLWwEd1gY1kuo3RRoy3exHFKlwG8o8M7zp/Xew/4bGnFJfAw3QqNJ9r4sLVVf5+dv7Ab14Rp3FK0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184084; c=relaxed/simple;
	bh=4g0OtLUl7BGDW26kJda6IAfzr/kL90IR8TS34d95Dn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyuNOLs6fhssn/4CaQksrDHdy0c/mVGHg+Qd5C5u4uF5wTgghbdWNefX5kvAO/oSXWSeBekSE6LZ6SldcJL7HWZ7/tCXdWhUO8JQVHrLMDsL63+D4YpKzszaVczUON45lMS1Ry9Y8O34wXqc3vmWOxxgUCJi9iuK8LHaK26ZPX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veebU02T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veebU02T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EFB1F00A3D;
	Mon, 31 Aug 2026 13:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184082;
	bh=cjIiSApkexAiC2wBt9vUE+jZXuGQ69KRse6oYTABJE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veebU02TJ8Z8slw6JD0K9dJGrO/gOnxwHDdzofDWknxW32SDmBWu0E+VuuIxe0fJO
	 rXv86c3ip8E9cvBM4DoItY6b8nvDz5Cy6AEeSk8CgU7nz8hf/17Jx9H/MYv3YDNRSZ
	 gpmNm/0lBgpDsXW0QzkAJ8ZcNSFcyQgc78MhXDdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 66/83] crypto: qcom-rng - Enable clock in hwrng case
Date: Mon, 31 Aug 2026 15:34:42 +0200
Message-ID: <20260831133402.864997641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



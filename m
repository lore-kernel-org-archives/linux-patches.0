Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D102135B8;
	Tue, 26 Aug 2025 11:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207862; cv=none; b=aRyTe1NYqgbDPsY58pp5H+lbcH2I3XZ2oNOzMVktnhkWy/5+Y/88OWt76ANLbDsUqYYCBMP0jc+A4LSCnf1mQCoNtv15s0I88Yiu9Khqg/Z0zRyjUdKrYznssUgqHn9Bml+juiFim2K2wcVYF33nk7CANo6qhVHAR05Zmyqt0gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207862; c=relaxed/simple;
	bh=t5TFbTPYgklvHCOiuMNOH/izDsn3H1vxB4RzZL9gPJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn7m9+gSehBi/QP4IBSIb/cVI3vssSKj+RKw8dVJDecbY55JEAcF1uroLjEvIiSUSOw/aHx8nH4bR9xwJh1ghumJYgBuClREVYNIagZGLExYcJxmalqEPqXagYOVvxmjZ/pXUaFkUBbAe9inCQ0P1ciA3JWfRwXKuj5QE9+JwYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LXnq9h6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LXnq9h6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B874DC4CEF1;
	Tue, 26 Aug 2025 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207862;
	bh=t5TFbTPYgklvHCOiuMNOH/izDsn3H1vxB4RzZL9gPJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LXnq9h6cNLT3LFlXt8UqjA9mzW9an3NKRN9IK4WpGzs8Gvp5dS5Yhwckd4eBAXOM
	 /AOnNamfI3X1Pl0YBk0H05keCmzvNWoVi4fcBX0i0y/B2RVfqqiqjvn4A52i5we1b3
	 u0ITnJXve3GFQxwBdkasi4H9w1HqnC7rKXmuoC1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 344/457] spi: spi-qpic-snand: fix calculating of ECC OOB regions properties
Date: Tue, 26 Aug 2025 13:10:28 +0200
Message-ID: <20250826110945.830828023@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 13d0fe84a214658254a7412b2b46ec1507dc51f0 ]

The OOB layout used by the driver has two distinct regions which contains
hardware specific ECC data, yet the qcom_spi_ooblayout_ecc() function sets
the same offset and length values for both regions which is clearly wrong.

Change the code to calculate the correct values for both regions.

For reference, the following table shows the computed offset and length
values for various OOB size/ECC strength configurations:

                              +-----------------+-----------------+
                              |before the change| after the change|
  +-------+----------+--------+--------+--------+--------+--------+
  |  OOB  |   ECC    | region | region | region | region | region |
  |  size | strength | index  | offset | length | offset | length |
  +-------+----------+--------+--------+--------+--------+--------+
  |  128  |     8    |    0   |   113  |   15   |    0   |   49   |
  |       |          |    1   |   113  |   15   |   65   |   63   |
  +-------+----------+--------+--------+--------+--------+--------+
  |  128  |     4    |    0   |   117  |   11   |    0   |   37   |
  |       |          |    1   |   117  |   11   |   53   |   75   |
  +-------+----------+--------+--------+--------+--------+--------+
  |   64  |     4    |    0   |    53  |   11   |    0   |   37   |
  |       |          |    1   |    53  |   11   |   53   |   11   |
  +-------+----------+--------+--------+--------+--------+--------+

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20250805-qpic-snand-oob-ecc-fix-v2-1-e6f811c70d6f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 722ab60d616f..e98e997680c7 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -216,13 +216,21 @@ static int qcom_spi_ooblayout_ecc(struct mtd_info *mtd, int section,
 	struct qcom_nand_controller *snandc = nand_to_qcom_snand(nand);
 	struct qpic_ecc *qecc = snandc->qspi->ecc;
 
-	if (section > 1)
-		return -ERANGE;
-
-	oobregion->length = qecc->ecc_bytes_hw + qecc->spare_bytes;
-	oobregion->offset = mtd->oobsize - oobregion->length;
+	switch (section) {
+	case 0:
+		oobregion->offset = 0;
+		oobregion->length = qecc->bytes * (qecc->steps - 1) +
+				    qecc->bbm_size;
+		return 0;
+	case 1:
+		oobregion->offset = qecc->bytes * (qecc->steps - 1) +
+				    qecc->bbm_size +
+				    qecc->steps * 4;
+		oobregion->length = mtd->oobsize - oobregion->offset;
+		return 0;
+	}
 
-	return 0;
+	return -ERANGE;
 }
 
 static int qcom_spi_ooblayout_free(struct mtd_info *mtd, int section,
-- 
2.50.1




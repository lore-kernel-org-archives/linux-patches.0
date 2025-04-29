Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC7024633C;
	Tue, 29 Apr 2025 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950348; cv=none; b=HaSYHalY1K2gStFu9W7xSnq81MRui//7hJhmE279rtBgucWIyu4xMu3Wea7o+HbMKuVt4S3utxl/HBOhQjRcc2Wyig1kP0na2H+3zDmW3gNKyT57uFVLmrqX7uuVhAJ7b53W4axkdBaKT1CIyflzkWgZDjE8O+QMXRXj/Lmzzn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950348; c=relaxed/simple;
	bh=TpdUWbBmNEX5XD+11hJJ3tW4SlpLNrflHRpj/ARYMXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsiDwsTt4Z2F/8HQvE8vWX0hxdOPtXBSGmWpKHNiFTrMh9N7weTpMaWQZbFTiXYDAertYQhUrOKhIkcWF8U/tJD4hvqkSY7jmY96yTREqG7ywNbwGNfIzbEsJE9fdrTdVtHYp6TpdH2LDST924y1Fy48a0PuuG+xn5RVSoYQOo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kY8P1ouk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kY8P1ouk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ED8C4CEE3;
	Tue, 29 Apr 2025 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950348;
	bh=TpdUWbBmNEX5XD+11hJJ3tW4SlpLNrflHRpj/ARYMXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kY8P1oukE5yyxqIwBIAI7273BnYGCiWNQx7vpyC1ZAUzSZ4POIpXtKg1/gPbA4biH
	 Mqc0bVaEng8R2Ei7H0tHoufWTb1IPr6zDo/CY1Eh8lQTsW2VOtuGncwxW4S0J99azY
	 1BblZNCgUN67YZH4LxcufLNaW7ASICgGioETzhVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 038/204] scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get
Date: Tue, 29 Apr 2025 18:42:06 +0200
Message-ID: <20250429161100.967447108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit ded40f32b55f7f2f4ed9627dd3c37a1fe89ed8c6 ]

The driver leaks the device reference taken with
of_find_device_by_node(). Fix the leak by using devm_of_qcom_ice_get().

Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com> # SCSI
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250117-qcom-ice-fix-dev-leak-v2-3-1ffa5b6884cb@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 51ed40529f9a7..c6417ef074a47 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -121,7 +121,7 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	struct device *dev = hba->dev;
 	struct qcom_ice *ice;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;
-- 
2.39.5




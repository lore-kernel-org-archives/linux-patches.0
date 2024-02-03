Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8043F53E00;
	Sat,  3 Feb 2024 04:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933934; cv=none; b=rIJU6yhyU/ZVq0EeA8hM+WbQ2NFaJT97KhSKWDZJMjRqPX8p3BGMnsFfAVXsUkkAVEWMxtRsa5HNSioBbijDTsfwhxCNLwsTmdz6NGXG7F+f6+X8YqXKDkAH2hLQtSWdzRKmtTZ68jAvb+t3vW9ZLKEr8Xdz1HevbUZtOZsaScI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933934; c=relaxed/simple;
	bh=XRvQAm9njXt/lmsEFmuGJXYOV9IJ0TfqdjRx3yi61C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvukP2X+e4eUba/GAt4bbSvdE6knJ7mI/SUVImhtYLQc535dcox9nEodtTQlTEfiDKyYeDjPs1m0MyXmQndfrTGk/BqaJ1Jeyeu4bRmCrzpjX9jx6uH+ylN/SyjYxhvge4Ok3+8tjOdEWFSIGbVcKX6FMLdfS+el1aNS3Q9ih28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU65paQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU65paQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F149C43394;
	Sat,  3 Feb 2024 04:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933934;
	bh=XRvQAm9njXt/lmsEFmuGJXYOV9IJ0TfqdjRx3yi61C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CU65paQJ7BcczqJmIhwA54ZvIUt1qHqWCP7asWZ1DgbUfMVLw5EybYikbTI05Di8H
	 DoDznCSfYG6OwSuF+daFu4rBuxat0GL+jC3AOgC5ylPCc0auzS8IyLvJDYMaDOyve7
	 96iZ6vE5B1dom9Vj6EWp3lbz3hMgZfmXYH568TZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Naour <romain.naour@skf.com>,
	Yoann Congal <yoann.congal@smile.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 295/353] regulator: ti-abb: dont use devm_platform_ioremap_resource_byname for shared interrupt register
Date: Fri,  2 Feb 2024 20:06:53 -0800
Message-ID: <20240203035413.147106587@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Naour <romain.naour@skf.com>

[ Upstream commit a67e1f0bd4564b485e0f0c3ed7f6bf17688be268 ]

We can't use devm_platform_ioremap_resource_byname() to remap the
interrupt register that can be shared between
regulator-abb-{ivahd,dspeve,gpu} drivers instances.

The combined helper introduce a call to devm_request_mem_region() that
creates a new busy resource region on PRM_IRQSTATUS_MPU register
(0x4ae06010). The first devm_request_mem_region() call succeeds for
regulator-abb-ivahd but fails for the two other regulator-abb-dspeve
and regulator-abb-gpu.

  # cat /proc/iomem | grep -i 4ae06
  4ae06010-4ae06013 : 4ae07e34.regulator-abb-ivahd int-address
  4ae06014-4ae06017 : 4ae07ddc.regulator-abb-mpu int-address

regulator-abb-dspeve and regulator-abb-gpu are missing due to
devm_request_mem_region() failure (EBUSY):

  [    1.326660] ti_abb 4ae07e30.regulator-abb-dspeve: can't request region for resource [mem 0x4ae06010-0x4ae06013]
  [    1.326660] ti_abb: probe of 4ae07e30.regulator-abb-dspeve failed with error -16
  [    1.327239] ti_abb 4ae07de4.regulator-abb-gpu: can't request region for resource [mem 0x4ae06010-0x4ae06013]
  [    1.327270] ti_abb: probe of 4ae07de4.regulator-abb-gpu failed with error -16

>From arm/boot/dts/dra7.dtsi:

The abb_mpu is the only instance using its own interrupt register:
  (0x4ae06014) PRM_IRQSTATUS_MPU_2, ABB_MPU_DONE_ST (bit 7)

The other tree instances (abb_ivahd, abb_dspeve, abb_gpu) share
PRM_IRQSTATUS_MPU register (0x4ae06010) but use different bits
ABB_IVA_DONE_ST (bit 30), ABB_DSPEVE_DONE_ST( bit 29) and
ABB_GPU_DONE_ST (but 28).

The commit b36c6b1887ff ("regulator: ti-abb: Make use of the helper
function devm_ioremap related") overlooked the following comment
implicitly explaining why devm_ioremap() is used in this case:

  /*
   * We may have shared interrupt register offsets which are
   * write-1-to-clear between domains ensuring exclusivity.
   */

Fixes and partially reverts commit b36c6b1887ff ("regulator: ti-abb:
Make use of the helper function devm_ioremap related").

Improve the existing comment to avoid further conversion to
devm_platform_ioremap_resource_byname().

Fixes: b36c6b1887ff ("regulator: ti-abb: Make use of the helper function devm_ioremap related")
Signed-off-by: Romain Naour <romain.naour@skf.com>
Reviewed-by: Yoann Congal <yoann.congal@smile.fr>
Link: https://msgid.link/r/20240123111456.739381-1-romain.naour@smile.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ti-abb-regulator.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index f48214e2c3b4..04133510e5af 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -726,9 +726,25 @@ static int ti_abb_probe(struct platform_device *pdev)
 			return PTR_ERR(abb->setup_reg);
 	}
 
-	abb->int_base = devm_platform_ioremap_resource_byname(pdev, "int-address");
-	if (IS_ERR(abb->int_base))
-		return PTR_ERR(abb->int_base);
+	pname = "int-address";
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
+	if (!res) {
+		dev_err(dev, "Missing '%s' IO resource\n", pname);
+		return -ENODEV;
+	}
+	/*
+	 * The MPU interrupt status register (PRM_IRQSTATUS_MPU) is
+	 * shared between regulator-abb-{ivahd,dspeve,gpu} driver
+	 * instances. Therefore use devm_ioremap() rather than
+	 * devm_platform_ioremap_resource_byname() to avoid busy
+	 * resource region conflicts.
+	 */
+	abb->int_base = devm_ioremap(dev, res->start,
+					     resource_size(res));
+	if (!abb->int_base) {
+		dev_err(dev, "Unable to map '%s'\n", pname);
+		return -ENOMEM;
+	}
 
 	/* Map Optional resources */
 	pname = "efuse-address";
-- 
2.43.0




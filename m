Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE647124F;
	Sat, 12 Sep 2026 13:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219729; cv=none; b=HpgzRGTqvzKRO0LmWxHUYds6XSG+yb32/L53h0WugQXnwdI1UhytjeMnUwrwOmz0jWy4PyfHFpGe69M+DNVm+H5gZEwtpNFlDZb2IUbbUZ8bmXleyJFO8qMoT/M+S0/xcfpf88EvxWz3EVE/AkkaWRpL67NUXkzi90sAkcRRtHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219729; c=relaxed/simple;
	bh=XH0IIeQC7dlJjXXzhFuvyM8HeP5HVkKdanJ9irXznQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InWPQCtide1s3jgbsOJa+0WDFF9U8rKTE5egOFqAiTy1amHiux4ce02lJGsl1Sk1pdITEZLTS2Wqy/KwSyaZvheJt4StCR0A/me/cF9jr9OVUIwA7t5WnW+w6iM8ogdmJt4/+BpTuFWe980p4wVTSgqs3rnJm/dDTP7lwAxuylY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnjC1fJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnjC1fJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507E41F000FF;
	Sat, 12 Sep 2026 13:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219727;
	bh=fgxwibAKBih95+4V41kNdJnxYVzxFUSj5zOkn1jL/dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnjC1fJgghzfuq58qJZ0Me/daPC7VFo7yzSscDbK8aSm5ThRNry6GNefeztpuL7KN
	 He5hl48dhJBavzsEfwyax3VdT+I59CuaN4eHgIXt32xymEOVxKJsPyq4UDHbbL4VjH
	 SHnRR9/lTdxK1SdT1GSOdYyUFsvh0lJtlO1bC35E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.6 0033/1424] usb: gadget: snps_udc_plat: clean up PHY on probe deferral
Date: Sat, 12 Sep 2026 08:41:05 +0200
Message-ID: <20260912065608.047312412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 886338ea7d40e4ba5123c58204d7f7e53d825825 upstream.

When the referenced extcon device has not registered yet,
extcon_get_edev_by_phandle() returns -EPROBE_DEFER after the driver has
initialized and powered on the PHY. The direct return bypasses the common
cleanup path and leaves both operations unbalanced.

Store the lookup error first and route deferred probing through exit_phy,
while retaining the existing behavior of suppressing the error message for
deferral.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 1b9f35adb0ff ("usb: gadget: udc: Add Synopsys UDC Platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260804140510.37639-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/snps_udc_plat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/snps_udc_plat.c
+++ b/drivers/usb/gadget/udc/snps_udc_plat.c
@@ -160,10 +160,9 @@ static int udc_plat_probe(struct platfor
 	if (of_property_present(dev->of_node, "extcon")) {
 		udc->edev = extcon_get_edev_by_phandle(dev, 0);
 		if (IS_ERR(udc->edev)) {
-			if (PTR_ERR(udc->edev) == -EPROBE_DEFER)
-				return -EPROBE_DEFER;
-			dev_err(dev, "Invalid or missing extcon\n");
 			ret = PTR_ERR(udc->edev);
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "Invalid or missing extcon\n");
 			goto exit_phy;
 		}
 



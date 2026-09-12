Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C20035C68D;
	Sat, 12 Sep 2026 17:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232478; cv=none; b=kOnrBz1FaQuUhGjG0BRuMT3pNgzhQrRRAMxeqypNELs3fw4ELAbNmsu66cFfPZdLkDBuTvRK72kjc61I1HF+8/uRR9QPuNRi20jpfUxqwl7ERuAH1qxClGn6NVb9Fq3NwVevoBk5ecfgA7LmN/T4ubwizE4MANT9Uc6TQNtdEQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232478; c=relaxed/simple;
	bh=LrYMogX6iulKZG3W4YJVWs2EYRdsWr7RJuXIfK8P9yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4iNmLzbDxE7n8XyC7x6EJHI6LdTjLWYaib+uO23HgaAioyeUG/qetGVWw5VGxlKb69DaCFD9LpomUJuPABRAgaIVLqcdFqsvvI7xNV6/b2nDSK/Ytr97Fw+SgzyPdMcZOrslUKmTDRUh1gYqFirPiHRlvalmrxXgwUJqtKkcoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGuChP90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGuChP90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0673B1F000FF;
	Sat, 12 Sep 2026 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232477;
	bh=wQ8G17g04EfZM7+dBMcTdk+6oPgTgKox62qTL1poMKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGuChP90hEAuuZfU3koqEVLhX58XTnUX+kp0wp7rNjUvdZAuqzFBey3qT/vVdUjRE
	 CWzUCBHa0cWWK3Aw0vUwsziaUYYOoUszZ4II0KJgYcOFR7OlCHliT2i7tjIgmzgyxa
	 VMpelakB8TJpu/3l1nPV3kr7m3DXVAeVy8fP6Ma0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 5.15 019/935] usb: gadget: snps_udc_plat: clean up PHY on probe deferral
Date: Sat, 12 Sep 2026 08:50:49 +0200
Message-ID: <20260912065527.278082789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,10 +161,9 @@ static int udc_plat_probe(struct platfor
 	if (of_get_property(dev->of_node, "extcon", NULL)) {
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
 



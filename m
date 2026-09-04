Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DD6412294;
	Fri,  4 Sep 2026 05:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500624; cv=none; b=cUoxEDTHXVbcU+VOPXZDzML/TuENoW4+PBFoRvhyYcvaN4gOppOTJKGjZ5rZbZhsIAb5ZI9qru9M2MTl7FEISRI/2WJeinjwnyL+77/5s9EjT87gZIc78QM41G6Smf4DGwYDVPpTDstbKZvXTMzeOWaPzj4Yduh0T685nSL8GoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500624; c=relaxed/simple;
	bh=sPEr125l9fZOg8NHWEOUzqKYzYyXH2cybQRQ8tJ3yqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5VRQ/PdxXxMVcGKU9OVxjFeanPMHukGhDYSeDySEp1hQwVbW7QKKoe0nHf9im8MbkLL/lMQoz+2r9rRm43pq0vd+0EHVRnn7PVLf9Y/AVv0BYcZtlrMELfJJCczzXlJWbJSfHb+u+MvXuNxUDxAbytGXZTGOxTkvUR+VTZ9+Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4tJeyVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4tJeyVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7011F00ADB;
	Fri,  4 Sep 2026 05:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500623;
	bh=DLQqfXmqxbN2AI5e2OyRWJcufMPHgUtt8YcEei8LdaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4tJeyVIuwbXQZoNlYaInB1kF3D1zvNMj9UPcTdofdMs1kInPBXv0CYAmwC4UPjDY
	 IfbqYVC50i4Pnp7P2kRpwUr9NpeOf4Cupb87y1EG1HOqTls+/6rEDxxihKbtf9gIPU
	 5f6pOei29KPijSqUbS3VBCMeAj/wPK8/PQJW6aMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.18 079/552] usb: gadget: snps_udc_plat: clean up PHY on probe deferral
Date: Fri,  4 Sep 2026 06:53:56 +0200
Message-ID: <20260904045749.653246212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -159,10 +159,9 @@ static int udc_plat_probe(struct platfor
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
 



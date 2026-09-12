Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F0381E88;
	Sat, 12 Sep 2026 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241065; cv=none; b=ORJNJyWpWPZl6XYjVfj1gne75xdZaLYuaMt7MPHLIHOUyw2ZEmKfXKDq0mAfDVCEN2CyY3eILgbb8i93tgZ/qoG1YNN4pn83hKSGpQFBosvc+euvEqShgo/H0QBjq4s8ntFgBB1CkGfMp35niXnKmm+yNfms42rOAPF2kJeQTzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241065; c=relaxed/simple;
	bh=3Amn4vWc7WglFp0mq/yn6uEu/ahxf1EWOqQL9n0sB5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4W/CJ4yFnRZ+HE4X1tG/y0lIcPUoDppN/5Zd2qqItMsLxfhjpLxztOnJl2v8ZZso9LZtytl1Xx2putB6MTEVScWOdJ7ydg8uKt3y3K443nDZmEu46QYFDvVRAW0oENRY9ASyWYJqZfLBOuSIdmyH6LAimqndBzS19CAcB3YhTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQCBkYDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQCBkYDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37B71F000FF;
	Sat, 12 Sep 2026 19:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241063;
	bh=8qZjR8VhnX6DrrCMDHYkiz858ZXuJ0j29M4q1SeiFCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQCBkYDOzsDY1M/cGsPwisjqURn3P+xY/Cj8kGFnPGYfBBHTrufWmKZOFjpNlYstY
	 3YWib1xzoLq6fN53IJEKLnO5Jf05S+uCtVR3hox0b9g2nB6IOmutMCY2Ww/SADyDXc
	 nu/lFFrsLGGO0b3u/KTVnyv2sVjhkrQawdsC7Oh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 5.10 016/798] usb: gadget: snps_udc_plat: clean up PHY on probe deferral
Date: Sat, 12 Sep 2026 08:54:04 +0200
Message-ID: <20260912065517.333726426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 



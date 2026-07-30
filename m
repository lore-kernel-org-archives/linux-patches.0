Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17FE36A03A;
	Thu, 30 Jul 2026 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426316; cv=none; b=W01p7wwOBizXEc4hGILhXTWswirPwku8ObWqb9ZSYA3VGYz7L1IaX5/c0Iu3o0/hXez5u746iVkWmo2oQqSzzUj9hDXeGVC8pXXwbA/zMi8WDl4/6mJCBPW958nX5yND2n2CgGs2EPkTU8kwJs/UqeKw5Rnqh93PSyNaT2788uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426316; c=relaxed/simple;
	bh=W3PllEuJ0Z8rTWN3yMxo3SoWaH19f8ut0rJrslHaDPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6QJOHy2T6jGMJ4orTkXije2XIEw/gfbvGfnuL4bpp3pVt/SZbMMhQmZjcXh9Fxn9+6OtqTrCEhv1qeV6Z0V1cLAGMqgaLQ7VUouzH4LwfwHLBW5d5aEp+16oPPjubTMrTn0Tr3CymzR/i26Hxz26U+fp7AkfIlLVhMcBvO/7bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5DNmNNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5DNmNNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61F11F000E9;
	Thu, 30 Jul 2026 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426315;
	bh=td7jeobxEE47lcYKX0CPNBZUvyS2svlaADOYDZeP9CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5DNmNNTQQEhbnBOH/Y/XWUDczMlSkpwbXpIMDTn6+Xh9Vp5VHcSXE7ygHSDS/vyl
	 BujYEyzaX5bh2KmH8CJ6l1UALXnB7ZYBmy/RSF8Y3UQSVvM/2pi9ZbZIvpP8GE0nCS
	 WzrmpVJ7brqrRSbymFfQxaUjEMkqDdqDkb99WZmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 331/602] media: ti: vpe: unwind v4l2 device registration on probe error
Date: Thu, 30 Jul 2026 16:12:03 +0200
Message-ID: <20260730141442.918340744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit e0f1c9a90ef665f2587c274a8fed59f2dfc575a6 upstream.

If the vpe_top resource is missing, vpe_probe() returns -ENODEV after
v4l2_device_register() has succeeded. Probe failures do not call the
driver's remove callback, so the v4l2 device remains registered on that
error path.

Route that failure through the existing v4l2_device_unregister() unwind
label, matching the other errors after v4l2_device_register().

Fixes: 4d59c7d45585 ("media: ti-vpe: vpe: Add missing null pointer checks")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/vpe/vpe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/ti/vpe/vpe.c
+++ b/drivers/media/platform/ti/vpe/vpe.c
@@ -2545,7 +2545,8 @@ static int vpe_probe(struct platform_dev
 						"vpe_top");
 	if (!dev->res) {
 		dev_err(&pdev->dev, "missing 'vpe_top' resources data\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto v4l2_dev_unreg;
 	}
 
 	/*



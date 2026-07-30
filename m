Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBAB32B116;
	Thu, 30 Jul 2026 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424553; cv=none; b=qubkm+XRroVcsBz7zgc+zDnfHahBkc5uDIxz3FV6Ap8rfR3Eh9yM29ZufejBUE+2/oMMttxmDiG4Dl/8bOuuTjHHnmysAN3XeEnXWASmV8Cu6wP+yDTgl8qpgpQJzRvUQsdkhiQB1J6PpuPIUwV6Tar0acCUNSThMJThf6YSATQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424553; c=relaxed/simple;
	bh=S3c/qVnduMifeOvxvrrBjzK4sngtQrkxxTXHIr5NIrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2rfNUdqGwcDBj34JuCyCD8fxAx4czBWNi2GxHgRG4OM8/UMZ8VClSI8dMJ90iI3Q/+vI2MbjCGumBi0iM4r4j4fIvwUvEiczkBD8Az3e9p8iTeiVxWMvXCDkWBwcXNk/QpXEEzxamvs25NeBLlAKOiHuo3PSIIQBfrZSgN2nNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD6aIG3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD6aIG3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A331F000E9;
	Thu, 30 Jul 2026 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424552;
	bh=WBd5vGbeBK481Pen7FGodkgY6D7bAFT3f0CQgQ/hPGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MD6aIG3lswo9pXhTlNBJ1t1t9e21Dihto4yYF8RZCGAjRFQG5B9TwnroJV4N3theR
	 TPilHfh7UZ+t/9u3XtHGz0gEgH5c+qDQgZOjWLpNVQwW+XTwZhwfQ5tLA5fNCcBGpX
	 OQqi2zUtzbWcQNxDEMBIZDfoIGQKa1iYhIyE4B1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 434/675] media: ti: vpe: unwind v4l2 device registration on probe error
Date: Thu, 30 Jul 2026 16:12:44 +0200
Message-ID: <20260730141454.364649816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -2546,7 +2546,8 @@ static int vpe_probe(struct platform_dev
 						"vpe_top");
 	if (!dev->res) {
 		dev_err(&pdev->dev, "missing 'vpe_top' resources data\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto v4l2_dev_unreg;
 	}
 
 	/*



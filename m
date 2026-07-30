Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC12E9EC7;
	Thu, 30 Jul 2026 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427698; cv=none; b=cHY4ZI3QPXR3FRCb2TUh6cH7ywskIjfTPVrglJ4IV8s8+PKrIzbzp5VkZ6NE4hf94MfQ3xsnB7wt9uTjAR1ErFpskGOQ5EmuJR4hzlq5ixc+/2WXBNZV3Q5MIc6raOO+rVB64tzaMcOiP1crNgv/qKJxz0V/cxE1KLY4ohZZc8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427698; c=relaxed/simple;
	bh=nFQhuyN0GBhWNxI9q9FBgIjLA1w8wmMElQcxWgPKG0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyigPdVfJKaB9kBuUG3N5suSdpVrwuYIYaX8uFfQ7r/kiZKWTSptZMJcK/h6eMmrvJ/evpYxiQ0a9n3vIagMPRUNjjZXFnUMltFuOXBhoZpqPzhPjq91X+SJtyXv/xkA81Y32VyL44vKmUbQLBt0LA4DlnSNZ//chFXNkMtdTaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5yUDkRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5yUDkRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595F51F00A3A;
	Thu, 30 Jul 2026 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427695;
	bh=6aEVzsq7VEB05ZMWUP8Fk02hDIV3e0aCYz6VwKnIOWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5yUDkRX5fdQN3v1lfqO/TmdRRfA39PM2st1VPOHLkVinR+94Tj1pwV/5IMDsbd10
	 qD9DVuEf4hVEp++8JR9Yod2G2MIoOpm9mwTxYJDPHTLWVGYDxeVgkymvS0c/ZScBn8
	 iQXKxnfUmOfutO6fNf2E8jgUiCdZUgWN3utbYwtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 260/484] media: ti: vpe: unwind v4l2 device registration on probe error
Date: Thu, 30 Jul 2026 16:12:37 +0200
Message-ID: <20260730141429.138646895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB323914ED;
	Thu, 30 Jul 2026 14:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422689; cv=none; b=BDQ2j6irrxetfxWoUvlK3YfERUk69+PpzEHtvptjcWFe7snIgDNqGBEtys8aj4k98/RMkYMGKe6fxQUi+Rn/NuZ8q9dMaL6uc1AWv8A+G/k9jky5O2sNUpK8LeQxLYlyN+XsXDyxgCfYVzG9Ip63jNthGd4Lagogatd9VTUkIHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422689; c=relaxed/simple;
	bh=PE+l2+ZiBOq7nt3q08znl8lEZLMjmLEMN1o76CyacGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgzl51DyFIW6+OYqjGXddMkC+KNhPErQOwrsSSRcHtvdEhZEkgQZwOlsmVOMXG+YgraU4HSFCZ5f0K3N1w6DytZDexGrRlilP59bKhC23iXckaPtht1nkAtkObI850HH0oP4e/Q4hmBmnj7ltBYOltkk7wFGdI8czlvPVQ5aGqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDDosuTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDDosuTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E751F000E9;
	Thu, 30 Jul 2026 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422688;
	bh=WBgkk80HMBG2Ry1VgOHxxLABA9LEVHpBvTHO5AnELAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDDosuTYcXvRhGwGAI0MZnhyS4olaNk/etruKadpKsAzuVnsY0nRRNR/zfxBtVFM/
	 SBwVPHvVxe4loCfV0YbZlotYVuQuB61sW6P9flYHjjkOxI+uxPQ6XtRCtmjDCra5Ra
	 PcqL5gg+23hrUJdX+aIbAawKiGa4qGAjOtUAKWu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 524/744] media: ti: vpe: unwind v4l2 device registration on probe error
Date: Thu, 30 Jul 2026 16:13:17 +0200
Message-ID: <20260730141455.412628267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2539,7 +2539,8 @@ static int vpe_probe(struct platform_dev
 						"vpe_top");
 	if (!dev->res) {
 		dev_err(&pdev->dev, "missing 'vpe_top' resources data\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto v4l2_dev_unreg;
 	}
 
 	/*



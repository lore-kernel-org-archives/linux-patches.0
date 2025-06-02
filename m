Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA4C1FF61E;
	Mon,  2 Jun 2025 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875419; cv=none; b=dRGQCTPcVC8uBa0HTPkdi2Y8YF13r2C77wTKXideRtwNA9c230adblKIdmcsN5DQpMebuLpMQ4n6lIHXZ3jHogxSy6ssHkIzKjJrk33AeV9r+QfeeDbQW8eNdchODvZc3LRoJSfG522bvNC6kmIKzB+i73m1JQw08roxNltpMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875419; c=relaxed/simple;
	bh=HVt/vzxDyTVm6ucTVrt1INjG7chVr4QR2qwg/I7/GlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw3KegCwNrGZ/d0We0zpcSt2K5By7FpYVe8QUXKZLwiumWMKIDDUB266KuPdDf1w+WdhB+RmEIw2bn99UDlUH1/+fsw9WtwsucCEEiuQJtj9tbt73FV55bY2YEfHVMxBAQInsWzHXG2sIJxUaZnIeTbjIv4QsaEkFNO70n0Onjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvdj51UZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvdj51UZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FAFC4CEF0;
	Mon,  2 Jun 2025 14:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875418;
	bh=HVt/vzxDyTVm6ucTVrt1INjG7chVr4QR2qwg/I7/GlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvdj51UZbeWQyn4rlkk3M6w8z4CophuGFgMJEiNpKKSTDGZm3YEXL2684KuOePcUQ
	 4rAH2CLXNaWb2VcPT1tDktKEM/EsK95pNx4bcyZadbYTl6cLFM8kth0HSX9Mz2Slhx
	 INN3+MMQOBRzgL3nAyxvgT7Kg2s9DuuygJMis3Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 099/270] phy: Fix error handling in tegra_xusb_port_init
Date: Mon,  2 Jun 2025 15:46:24 +0200
Message-ID: <20250602134311.217075010@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit b2ea5f49580c0762d17d80d8083cb89bc3acf74f upstream.

If device_add() fails, do not use device_unregister() for error
handling. device_unregister() consists two functions: device_del() and
put_device(). device_unregister() should only be called after
device_add() succeeded because device_del() undoes what device_add()
does if successful. Change device_unregister() to put_device() call
before returning from the function.

As comment of device_add() says, 'if device_add() succeeds, you should
call device_del() when you want to get rid of it. If device_add() has
not succeeded, use only put_device() to drop the reference count'.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 53d2a715c240 ("phy: Add Tegra XUSB pad controller support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250303072739.3874987-1-make24@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -536,16 +536,16 @@ static int tegra_xusb_port_init(struct t
 
 	err = dev_set_name(&port->dev, "%s-%u", name, index);
 	if (err < 0)
-		goto unregister;
+		goto put_device;
 
 	err = device_add(&port->dev);
 	if (err < 0)
-		goto unregister;
+		goto put_device;
 
 	return 0;
 
-unregister:
-	device_unregister(&port->dev);
+put_device:
+	put_device(&port->dev);
 	return err;
 }
 



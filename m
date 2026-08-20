Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2220377A89;
	Thu, 20 Aug 2026 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239283; cv=none; b=PFnvyhNYigBhwMXRZeDCsm6+5c6MlhIRGoVhEWsVlAst3/VzST5vfVvRbSxvZqC/wYQSxrRlan9jx+mj3+7+VdEwPPnquL+Y15Ng7VxWIlKhbm+wiw/44uHl2MWNu5yfuPuLV2c1/SkGEK6TpSSioXwiN+VzMXPCpp241LLfSfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239283; c=relaxed/simple;
	bh=Je0erMraaosccYZo5CPUMkdZZ2ZyD81vb0/vJ36L5gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWZxNp43JNvKXbpxN0A/UKr5ZtjdV0xy5mq/t0q5l0wVCx7Jl4IAd0HuHs/elB+ZIDwy3iT6KzdPHIy8TXmTwcYkrjQ6lfudvs4kdQQm26mf5JsC8SJGoepYYvR3CoxndaLn0FvRziE2Dkj1h8kdpdHz0lbqnbEvdiksZsgIetQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxkGNpoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxkGNpoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B631F000E9;
	Thu, 20 Aug 2026 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239282;
	bh=wbjOb2tli1SyZVJUb9qPdEScHLs8HhVmyNn91vOHos8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxkGNpoSIFBliVwG8W5639Jd1hJLjezjmalyTTyqxLrjpzRt+/Y/+OV3ltTNH8Dgu
	 4T/SInTuTxJegV3kJ4XQTiKhBVAiXsfQbdFLGYXo0G3s94MFgrPZ0TCU8MXPRQ42VV
	 Hl9uzMNJlX0ml24ErNZH88smzBU7M8c8ePxCQflA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Wise <jaspwise@amazon.co.uk>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/217] spi: virtio: mark device ready before registering the controller
Date: Thu, 20 Aug 2026 16:56:22 +0200
Message-ID: <20260820145244.125653610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Jasper Wise <jaspwise@amazon.co.uk>

[ Upstream commit 11058bd3d47d57eb3473935feae53868d6d168b7 ]

virtio_spi_probe() registers the SPI controller with
devm_spi_register_controller(). spi_register_controller() binds a child
inline unless its driver has asked for asynchronous probing, so a
peripheral that performs a transfer during its own probe reaches
virtio_spi_transfer_one(), which kicks the virtqueue before probe has
returned.

The driver never calls virtio_device_ready(), so DRIVER_OK is set on its
behalf by virtio_dev_probe(), only once probe has returned. The virtio
spec is explicit about that ordering in 3.1 Device Initialization:
  |  The driver MUST NOT send any buffer available notifications to the
  |  device before setting DRIVER_OK.

A device that waits for DRIVER_OK before servicing the queue therefore
leaves the transfer unanswered, and virtio_spi_transfer_one() waits for its
completion with no timeout, so probe never returns.

Mark the device ready before registering the controller, as done for the
same reason in commit f5866db64f34 ("virtio_console: enable VQs early") and
commit 1d774589f924 ("i2c: virtio: mark device ready before registering the
adapter").

Fixes: f98cabe3f6cf ("SPI: Add virtio SPI driver")
Signed-off-by: Jasper Wise <jaspwise@amazon.co.uk>
Link: https://patch.msgid.link/20260813084618.613172-1-jaspwise@amazon.co.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-virtio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-virtio.c b/drivers/spi/spi-virtio.c
index 2acb929b2c690..fb30c9207a4b0 100644
--- a/drivers/spi/spi-virtio.c
+++ b/drivers/spi/spi-virtio.c
@@ -361,6 +361,8 @@ static int virtio_spi_probe(struct virtio_device *vdev)
 	if (ret)
 		return dev_err_probe(&vdev->dev, ret, "Cannot register virtqueue cleanup\n");
 
+	virtio_device_ready(vdev);
+
 	/* Use devm version to register controller */
 	ret = devm_spi_register_controller(&vdev->dev, ctrl);
 	if (ret)
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDA63C07A;
	Thu, 20 Aug 2026 15:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238686; cv=none; b=IYf24qHBWcU36s42On0GQrvOmoVSyqoJAWphNzJwkHLYi0R72PnIIeCZTwPFkPeA0b7mrINEtJWEpIeihMjgVkIUu/nstUEdkDALDAS0Z14EHxKE0qmlKxWpaTn3GGLvF3HMBjg10EQXp0ysyXLoySMhaZufeF4Z7jwx71w2FAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238686; c=relaxed/simple;
	bh=yl2N0IB4kX/CZTPO/S0UuDXfO4d5/ggi/iaCa5v9aOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNUHp/3SVQlm61WeFhRNp15RPLGoSWWPaFkz8O+/Gya7ZK7Ga6rPv1VOXs4vTOhFFXBLf3sS6MO+tufNyzr3S+pBuWkU4SrWIakdgh1TnDpxHAYn/U5Wegg+wJRfjncmeFt1axXzzl7wJb5BYDKhvOnrOnjyDirwGGVWzxXgi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRp1a7Ps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRp1a7Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1505F1F000E9;
	Thu, 20 Aug 2026 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238685;
	bh=M4HJTE+1THe/qtQ/00rhiQqRgpxLSUa3MKwBe7WsIS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRp1a7Ps9kvIfdDilL9rQ92eYBVBZCNrDuo3vQJTvmYWyAfjltr6x+hqUYivNU6WC
	 gEEWdph53n19x3NOJZvd7bsGT+9cpNRVtA74bxZBktt3//CHl9B270YlvFqbBpMlOr
	 hXlBrtjpHPD0ERVvInJ2TIuH+B9S2YCA1oTgSFEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jasper Wise <jaspwise@amazon.co.uk>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 227/228] spi: virtio: mark device ready before registering the controller
Date: Thu, 20 Aug 2026 16:56:09 +0200
Message-ID: <20260820145251.987967057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
index fa4c68049eca4..2256dfec5407d 100644
--- a/drivers/spi/spi-virtio.c
+++ b/drivers/spi/spi-virtio.c
@@ -358,6 +358,8 @@ static int virtio_spi_probe(struct virtio_device *vdev)
 	if (ret)
 		return dev_err_probe(&vdev->dev, ret, "Cannot register virtqueue cleanup\n");
 
+	virtio_device_ready(vdev);
+
 	/* Use devm version to register controller */
 	ret = devm_spi_register_controller(&vdev->dev, ctrl);
 	if (ret)
-- 
2.53.0




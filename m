Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828EC2135DD;
	Tue, 29 Apr 2025 17:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948789; cv=none; b=XYOuUW724HR4x1Bp4kCvfIrJ7LT4/+9uU/INunmXOONt0LyZE83n84yAhE7Nn0+8W8i2RdjxfcrZGdHBhstYmzXDcLN/DNHICGqEh4feBE8b4idcXLo+LG3MbESF663GLTHgl9VbQdo8BESgdJ4WiNv4oLKsEBuH0SEAE+EXPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948789; c=relaxed/simple;
	bh=rVIGTWxAknfXtS+ioOJHWlV/XiIi01uR42aTfQ0qMjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZGF4MyZj0URt6Nl+PhkQqda4KUcTHAc6kClDcEFwmqNodZ9A4w3r2IWwhHbj/8KHliqd4zn16HnuwdH2SIATtCGBBfY+npwFf/FSJu8iSIo1L0ulldQufAUt1T2SovlNcFULftyYxutfr3MGDSo5YGvf8o6sOu80dCqxOHiCdbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wC+7pw9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wC+7pw9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F53CC4CEE3;
	Tue, 29 Apr 2025 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948789;
	bh=rVIGTWxAknfXtS+ioOJHWlV/XiIi01uR42aTfQ0qMjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wC+7pw9QjAldxDALVI4fCRrUxVstfJ0JRdQp8crRZ0mdUd4JUalTB2YQ2YA0AO1Av
	 yvN8CNpg0KzbHq1aAZ9uNM7MIWN/TuRTepAevtxGMZdK3OgTU/ZDlc29u7DHTdcI2M
	 gXodqCfqJdRVxTncfof5FweB+SMr2iGN6xPcOiE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 113/373] PCI: Fix reference leak in pci_alloc_child_bus()
Date: Tue, 29 Apr 2025 18:39:50 +0200
Message-ID: <20250429161127.824683027@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 1f2768b6a3ee77a295106e3a5d68458064923ede upstream.

If device_register(&child->dev) fails, call put_device() to explicitly
release child->dev, per the comment at device_register().

Found by code review.

Link: https://lore.kernel.org/r/20250202062357.872971-1-make24@iscas.ac.cn
Fixes: 4f535093cf8f ("PCI: Put pci_dev in device tree as early as possible")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1115,7 +1115,10 @@ static struct pci_bus *pci_alloc_child_b
 add_dev:
 	pci_set_bus_msi_domain(child);
 	ret = device_register(&child->dev);
-	WARN_ON(ret < 0);
+	if (WARN_ON(ret < 0)) {
+		put_device(&child->dev);
+		return NULL;
+	}
 
 	pcibios_add_bus(child);
 



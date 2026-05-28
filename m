Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5EB318EE1;
	Thu, 28 May 2026 19:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998033; cv=none; b=XxpjzFuWpFwAcNkRx0s+6/O+8+2quMREVIxB+c3S+CyLD4+aKKE388CsF3Fmbjur4b6fuekCpccC550kwPXJLE9wzXSs7l91cyHd0MzLjkwqdTcC/Zq/BaqgDPLcT6WdTFSiJ53vG0HiyOAcP99R8j41mDWS6fkdzPWgFJCaVec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998033; c=relaxed/simple;
	bh=/USOrHHsQa9YJsIet1nTxfrQ2mqkjFLnG4rc1MYnCVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/caYXK3z+mshjHZvX468RtMRu8hB+x2h3kRfGXOSc+lDJfRoSSCx0XgVByxjTMZbZJ5l87yIaIJqBAogNRE2Wo2Z/Wcq4uVXG3IclKvT6dCdMyWKaTFlfRSVr5uOvBGeeZ04Ffj+/mzdqMmOFq2ZtUMGsMTIGfn/i2VZ4lFGtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRC/96fi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRC/96fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28741F000E9;
	Thu, 28 May 2026 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998032;
	bh=HeMO5/3gbpDofnlxgWMJNpHXqxnYJJbGLdK7dDAPpFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRC/96figvzLnJHVJI9GhdqXd3xj1EuJZV/E/KxT/HJBjbuBWStIt+eMWPIXIMjev
	 tz7UfgnJOofhBIYSSS56Nr08GGfdgsP8kKYkRHU2hzfn3uouqfpo7okLFNxpC6CN6Y
	 HCZLZz9a64lo+8HcNAglpci0CVtl/1MpyAT5BB8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishnamoorthi M <krishnamoorthi.m@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 029/461] spi: amd: Set correct bus number in ACPI probe path
Date: Thu, 28 May 2026 21:42:38 +0200
Message-ID: <20260528194647.742771976@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishnamoorthi M <krishnamoorthi.m@amd.com>

commit 422bd00b71ab42163aa3b8f8370276fe4c1581e7 upstream.

On platforms where the HID2 SPI controller (AMDI0063) is enumerated via
ACPI instead of PCI, amd_spi_probe() unconditionally sets bus_num to 0,
while the PCI probe path assigns bus_num 2 for HID2 controller.

Align the ACPI probe path to use the same bus number so that userspace
and SPI client drivers see a consistent bus assignment regardless of the
enumeration method.

Fixes: b644c2776652 ("spi: spi_amd: Add PCI-based driver for AMD HID2 SPI controller")
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Krishnamoorthi M <krishnamoorthi.m@amd.com>
Link: https://patch.msgid.link/20260507180051.4158674-1-krishnamoorthi.m@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -868,7 +868,7 @@ static int amd_spi_probe(struct platform
 	dev_dbg(dev, "io_remap_address: %p\n", amd_spi->io_remap_addr);
 
 	amd_spi->version = (uintptr_t)device_get_match_data(dev);
-	host->bus_num = 0;
+	host->bus_num = (amd_spi->version == AMD_HID2_SPI) ? 2 : 0;
 
 	return amd_spi_probe_common(dev, host);
 }



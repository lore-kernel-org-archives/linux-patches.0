Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431051714D0;
	Thu, 15 Aug 2024 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728808; cv=none; b=Hr8V7xdLtpW1zCyJGuXKK/o+leelLC3uw/Te1OCJa8aZwBFSc+Eznaj9dhJLRG2YeJzkoBfMDk9ZjyI8wI+RX0mRIymULR6ubDgdfE3+IBC12DzYsq+/V6UdlDf6XBkwcCHJL2YJOGQdoyVp88LDijg1FpFr2wUkN8mHlD2vnRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728808; c=relaxed/simple;
	bh=U4C3eLcLCxrrPoJ+5WaYAxGyiNRDwIFOUkZCoGN53JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWPA0pkqULgORsn0KVk59wdzah62rkfxDJe7Ghfne/cNoXCUBMpFRm6ruLWnmJAsTi61ECoFvCw0NmzAmX3c2Rp2AEst1S7obaNiwYVCoAaeaj+LJvfSTNiHXC7TJao585QoiWKYv5yxRNWV1B1B9R8uWulQ1WsVx5p5VUCsoHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9gap4+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9gap4+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F88C4AF0A;
	Thu, 15 Aug 2024 13:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728808;
	bh=U4C3eLcLCxrrPoJ+5WaYAxGyiNRDwIFOUkZCoGN53JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9gap4+M/7sWzDlLO1ozuYTEDb9I8MQKBAfzfIxm2CS96EylirNIXG95FQlwN0xkb
	 +RwNyDvXbySHHpFr3eCKaBMqkY/TJluIl83rC+3djB78atkacHDu6weSaYu00EHKaH
	 FlYwPGYFP8anGOTwuAeVWLtSUJZZhEFAlAEdDF/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 4.19 075/196] leds: ss4200: Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:23:12 +0200
Message-ID: <20240815131854.947920317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit ce068e83976140badb19c7f1307926b4b562fac4 upstream.

ich7_lpc_probe() uses pci_read_config_dword() that returns PCIBIOS_*
codes. The error handling code assumes incorrectly it's a normal errno
and checks for < 0. The return code is returned from the probe function
as is but probe functions should return normal errnos.

Remove < 0 from the check and convert PCIBIOS_* returns code using
pcibios_err_to_errno() into normal errno before returning it.

Fixes: a328e95b82c1 ("leds: LED driver for Intel NAS SS4200 series (v5)")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240527132700.14260-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-ss4200.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -368,8 +368,10 @@ static int ich7_lpc_probe(struct pci_dev
 
 	nas_gpio_pci_dev = dev;
 	status = pci_read_config_dword(dev, PMBASE, &g_pm_io_base);
-	if (status)
+	if (status) {
+		status = pcibios_err_to_errno(status);
 		goto out;
+	}
 	g_pm_io_base &= 0x00000ff80;
 
 	status = pci_read_config_dword(dev, GPIO_CTRL, &gc);
@@ -381,8 +383,9 @@ static int ich7_lpc_probe(struct pci_dev
 	}
 
 	status = pci_read_config_dword(dev, GPIO_BASE, &nas_gpio_io_base);
-	if (0 > status) {
+	if (status) {
 		dev_info(&dev->dev, "Unable to read GPIOBASE.\n");
+		status = pcibios_err_to_errno(status);
 		goto out;
 	}
 	dev_dbg(&dev->dev, ": GPIOBASE = 0x%08x\n", nas_gpio_io_base);



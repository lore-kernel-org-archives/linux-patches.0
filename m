Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3987419FA90;
	Thu, 15 Aug 2024 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729779; cv=none; b=HcBnJwisrNIRcrM+Mu6pzFW/TmGbEMGlHVuRwygsJghuu0g3j+xUbYC4VVktCphK7rxFWVFG0F8Sja5+ic69sm2bWE3MECvyndddcX1eKYNhTSeJgsh/TUX7qkHAwtu0SXx3rXjLzMQqHWvogZxFU0TPpir4hGldsSrW+qv+uP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729779; c=relaxed/simple;
	bh=mmfvWGD7TvdwTtitYl0x4cZfIyNvu+IH0pbba0wygq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/bXZdJtM992ua/m2q96OyDYgDUW1kHynM5jRSXzd6wz1147GnRWtBHAen72Igi18xXkGRuhgmCmnbMvuph24JiJWBYqsK664V1z5xCFitIspdRJEeN9sPMsD1YxhjZqpI/heqUX5v1wVhPtNDkPGewD2muaD2WsN0ZtqIr/F9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4hPWykq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4hPWykq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560F4C32786;
	Thu, 15 Aug 2024 13:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729778;
	bh=mmfvWGD7TvdwTtitYl0x4cZfIyNvu+IH0pbba0wygq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4hPWykqSzxVDRgZEGnO0xKy4B4vzokmyIktvN2MGgsLBtji4LGp7xI9d6DvyOh1c
	 +DadqwOV6kVq7sLVVgBYU/LCpMX5LqGKBQ0bKJGu8fRWp3JbsJ+kzE+14mjtlPcrkB
	 9fglrjweVrpf8vdGT4lMLeT0ftHJelgescPhGUXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 197/484] leds: ss4200: Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:20:55 +0200
Message-ID: <20240815131949.021951012@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -356,8 +356,10 @@ static int ich7_lpc_probe(struct pci_dev
 
 	nas_gpio_pci_dev = dev;
 	status = pci_read_config_dword(dev, PMBASE, &g_pm_io_base);
-	if (status)
+	if (status) {
+		status = pcibios_err_to_errno(status);
 		goto out;
+	}
 	g_pm_io_base &= 0x00000ff80;
 
 	status = pci_read_config_dword(dev, GPIO_CTRL, &gc);
@@ -369,8 +371,9 @@ static int ich7_lpc_probe(struct pci_dev
 	}
 
 	status = pci_read_config_dword(dev, GPIO_BASE, &nas_gpio_io_base);
-	if (0 > status) {
+	if (status) {
 		dev_info(&dev->dev, "Unable to read GPIOBASE.\n");
+		status = pcibios_err_to_errno(status);
 		goto out;
 	}
 	dev_dbg(&dev->dev, ": GPIOBASE = 0x%08x\n", nas_gpio_io_base);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5284C19DF6A;
	Thu, 15 Aug 2024 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731357; cv=none; b=mUhy+qnVSZ8q8tSYO3gV812UzmS5d8m0oZ9t3bdlnhyGtpvfla+ekzLqcm7pf78S4r67y4YCoTONi/sBAqQRO9rhpzpFf8NbfX20qPpeRbG7iOUmJuGzqSdCHZ4gyFgR9shO7lQ4h5tv4UOwlvfHmcwosXCaBszGxzzpsh94tzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731357; c=relaxed/simple;
	bh=dt+gR9YjIPsMiuldVai7WCxp/mKQbHJK3R6g+ikx4Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYUIUfezSxQKYXY70ktC3bcInV+5MGzJCEXxRLfmAXHw63tQqm2PbqcDIr9aepkkwIb5fAMQIEF6b9QYRN3ku/lLapwISzzSm6YALaZSfMlBAq7+Bs9QZCvk3uA3izCUBSTrmy1eplrQ+vDHfJzNy+qnAF1wI/ci001OHvohxmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wS+y7axQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wS+y7axQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A428EC32786;
	Thu, 15 Aug 2024 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731357;
	bh=dt+gR9YjIPsMiuldVai7WCxp/mKQbHJK3R6g+ikx4Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wS+y7axQXeZtQy3JSpJfg1y4I97g98aoHd6RG1QIysc9dTnzh8AadLi+6da31xbGx
	 Wmoc4cpQnZOUNJqzyxs5HLEUbfhnni3D/DehvQe9lOzQM20wV69pT4C+z4oizkNW1A
	 jp1V+8T2q38GUApC6Ezb2pKFU/USedhNhs9VLNmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.4 104/259] leds: ss4200: Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:23:57 +0200
Message-ID: <20240815131906.820967043@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



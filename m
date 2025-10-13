Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F6B31619B;
	Mon, 13 Oct 2025 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370309; cv=none; b=fEtRIh2MYlr0f5Q+ZIoy21+TQU1YzJ3OMRLoQoZyqIcmIliLuuP8shLggL6ZAU9l8oP/ENJGmgX0Y+DkRTjAtW0MzyUvS1Mtg1eBGOBf+lzSE8h6GsZnD6gVBH33E+XIMMNhkjKviT+2V8d7JQRHobkz4S1+5L9CAamjdA907SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370309; c=relaxed/simple;
	bh=Pbi9q4JaNkfHr5QqJyX3TOt0nKftWGatkZslecdA3f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0Hr+u4+bMv8/Zd70ctGj/tRGENlkZa0US7kt3LPIDkiJgBRvEpBkk/ENrHv0hWo6J6j/bp0CtXPSGVuHwj4jruBZ5BoNvuWpCEZFabjJSARfibfnVFgzThIbjXQSqKnQkclQdFqm6F2wzD4gA/df9xKwF95HwRuhs7iIfCup4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USjJlsEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USjJlsEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10C2C4CEFE;
	Mon, 13 Oct 2025 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370309;
	bh=Pbi9q4JaNkfHr5QqJyX3TOt0nKftWGatkZslecdA3f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USjJlsEEjnU7FGBDhcIF96oRb8XUHt/uE64gxhWEuuPHrdYM4Zd5hdHQd8OU24SZi
	 y3xHB7gKdjuzAeOsOuD8D1fHTCtjj0V0vpBswJsfPXKK8/4T3t4q5PvwH8q1nrPTG3
	 JxXVa0+DMTH2ByrskLsueqwaTvpKz+tl8Xp2a+A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.17 550/563] PCI/AER: Avoid NULL pointer dereference in aer_ratelimit()
Date: Mon, 13 Oct 2025 16:46:51 +0200
Message-ID: <20251013144431.229130156@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit deb2f228388ff3a9d0623e3b59a053e9235c341d upstream.

When platform firmware supplies error information to the OS, e.g., via the
ACPI APEI GHES mechanism, it may identify an error source device that
doesn't advertise an AER Capability and therefore dev->aer_info, which
contains AER stats and ratelimiting data, is NULL.

pci_dev_aer_stats_incr() already checks dev->aer_info for NULL, but
aer_ratelimit() did not, leading to NULL pointer dereferences like this one
from the URL below:

  {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
  {1}[Hardware Error]: event severity: corrected
  {1}[Hardware Error]:   device_id: 0000:00:00.0
  {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x2020
  {1}[Hardware Error]:   aer_cor_status: 0x00001000, aer_cor_mask: 0x00002000
  BUG: kernel NULL pointer dereference, address: 0000000000000264
  RIP: 0010:___ratelimit+0xc/0x1b0
  pci_print_aer+0x141/0x360
  aer_recover_work_func+0xb5/0x130

[8086:2020] is an Intel "Sky Lake-E DMI3 Registers" device that claims to
be a Root Port but does not advertise an AER Capability.

Add a NULL check in aer_ratelimit() to avoid the NULL pointer dereference.
Note that this also prevents ratelimiting these events from GHES.

Fixes: a57f2bfb4a5863 ("PCI/AER: Ratelimit correctable and non-fatal error logging")
Link: https://lore.kernel.org/r/buduna6darbvwfg3aogl5kimyxkggu3n4romnmq6sozut6axeu@clnx7sfsy457/
Signed-off-by: Breno Leitao <leitao@debian.org>
[bhelgaas: add crash details to commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250929-aer_crash_2-v1-1-68ec4f81c356@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -786,6 +786,9 @@ static void pci_rootport_aer_stats_incr(
 
 static int aer_ratelimit(struct pci_dev *dev, unsigned int severity)
 {
+	if (!dev->aer_info)
+		return 1;
+
 	switch (severity) {
 	case AER_NONFATAL:
 		return __ratelimit(&dev->aer_info->nonfatal_ratelimit);



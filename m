Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C279018454A;
	Tue, 30 Jul 2024 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357627; cv=none; b=Z9HXRt8Mx+v6SbQMWSBgZggmSjshrPNJVbiGtVLO3kPRwdYK2fLGMFbjdvHCEciDPSrbqyQQmdfk8/ks/v7CTmmMpnCS+/drJmaWdIUwk3fHEPvqxXwAeS/slQ2jUKQJKaYDbP+mDvpWksKuPC27e1EtS6wmC0h6MoOtTYrDDX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357627; c=relaxed/simple;
	bh=oC7IvS2t224kdFjYWLdCmmLDvS4nJLOftejm4CKA9xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FaYw39prk+KQ357Q9O25ZfqBPhfrQzmczhT5gWt6bsyBlfwe3CQOeoKMoTMbhfNimm5qy/0ieaKFW4N1+aGmh3VJMiYjGYh1o0I9FcVlGzIB6XIKXFXhJHWoUpe14un0lsLp5S+Z8D8IHrx9SnWLHamL2dR57Nc7J3zjiMOMZzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+gK0eeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+gK0eeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B50C32782;
	Tue, 30 Jul 2024 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357627;
	bh=oC7IvS2t224kdFjYWLdCmmLDvS4nJLOftejm4CKA9xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+gK0eeC6xSGpsqtJuWhgbdQW7CSniGCra2o+3SgN2qIdMxS5d3dvBY2dMRc/5zJv
	 di6O8LWzg6sQCEOOmkYXxFr0SjrpjyWVrdDhek4x+GuNnS4OiFRizyaSwJnCEZwA7d
	 a12+bpR063F5I8gqaUYe2gK5M58kfaSyVuKyDQ1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 310/440] leds: ss4200: Convert PCIBIOS_* return codes to errnos
Date: Tue, 30 Jul 2024 17:49:03 +0200
Message-ID: <20240730151627.933706787@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



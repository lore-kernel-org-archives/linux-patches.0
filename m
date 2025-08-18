Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A825135A297;
	Mon, 18 Aug 2025 14:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526476; cv=none; b=Au40dRk5YFZ7ZLAKPuVM95vlFZ6sK57OfGRNStzaUjAAdQ6xEu+Jw9La7R/Okv6t7s4194WJaKVSodFDcPG8Ie66yiDm1qHtKLLEteZwo0y15XhRxmAApWNCC9QMuxUWcDKzwWprLauaFzy3DtqPOeaqjZzWJpTBtH6eyerCpDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526476; c=relaxed/simple;
	bh=GvJXSVr+Af9vUcmfSIEd6SfSnH4IJMwCuxUX2AVCwfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8wTrZcRvrlvQlgMGN5fO5zA+31dri+vYFfI4bFLeDaiZeXLs58ct1U5oh3HrCaXigSlUtbO+LPlAzxUh1Ma6yFy3fseleL1sjE/k9+cjqIJc/rujKLPwDrH8U60mxeBx5NBYNAyYEGdMU+jP5NJxWB2VVnimhIbLHCB8Is5ZhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0PI4OQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0PI4OQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2393C4CEF1;
	Mon, 18 Aug 2025 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526476;
	bh=GvJXSVr+Af9vUcmfSIEd6SfSnH4IJMwCuxUX2AVCwfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0PI4OQJjos4Gwz488fBnkKDZ0Ms+fGATN1Dv1ljDjKV5tnzPVRGVcx2Z7Uhx+ofM
	 B6ENaWobc49PBD5jV12GY4cROPMkKyOOlZesRAJWRVhZAzfT1VuHdRaGeDPmRWGemc
	 X3OglQX9xtUGasbjZSvI/XC24+dRS34D8f6ZUct0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.16 567/570] irqchip/mvebu-gicp: Use resource_size() for ioremap()
Date: Mon, 18 Aug 2025 14:49:14 +0200
Message-ID: <20250818124527.719120566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 9f7488f24c7571d349d938061e0ede7a39b65d6b upstream.

0-day reported an off by one in the ioremap() sizing:

  drivers/irqchip/irq-mvebu-gicp.c:240:45-48: WARNING:
  Suspicious code. resource_size is maybe missing with gicp -> res

Convert it to resource_size(), which does the right thing.

Fixes: 3c3d7dbab2c7 ("irqchip/mvebu-gicp: Clear pending interrupts on init")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Closes: https://lore.kernel.org/oe-kbuild-all/202508062150.mtFQMTXc-lkp@intel.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-mvebu-gicp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -237,7 +237,7 @@ static int mvebu_gicp_probe(struct platf
 		return -ENODEV;
 	}
 
-	base = ioremap(gicp->res->start, gicp->res->end - gicp->res->start);
+	base = ioremap(gicp->res->start, resource_size(gicp->res));
 	if (IS_ERR(base)) {
 		dev_err(&pdev->dev, "ioremap() failed. Unable to clear pending interrupts.\n");
 	} else {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC231A9B46;
	Mon, 13 Oct 2025 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368726; cv=none; b=ZqA9UqtNHtUJV+OYWHqDPIP96lBhOx0JZA4RydAZyA0Goi5gDHkp9W5E2dt8pi2bADBaOyBs0fR63OEHIRiUk7FgSt0bzg21u1kEhRfpphQYKV26387eyi6iPJQ6JjkZMfghmteh9U12LFR4onOZqwNo//Qvnr0RC5hmg0o7aoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368726; c=relaxed/simple;
	bh=9+48S6rTdat7QWbgRZHQ5U9WKwtaCHVlr9cXSk26b30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlnpZwsB/IahoLXj9sBxyJFkAQaVEN6DJIlr13YiFMcCCCcc27tc20oRFm03bFtoNgll4dgNqfGlk/AnzV1Tn7sdvSQx+i+ioEECRaD4X4V3jlJKmhICX3RSYWq7tITmIIl4K1Me95TiMvXCdNJUYCRdA8unGVHXjmeCCt9mxZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVaxGejz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVaxGejz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0267DC4CEE7;
	Mon, 13 Oct 2025 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368726;
	bh=9+48S6rTdat7QWbgRZHQ5U9WKwtaCHVlr9cXSk26b30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVaxGejzcFM9GPahpP+AmollIzuaLE7Fb6AJrMTCYNqGK7d5t+1jlt+U1sCFirESk
	 KuY4mU7DUbT+qDKmC1ZCsfqjIonVaejBVrpJ+im1n9xEE4czC9Kab94H7w3dG/Ge+7
	 HSs81SI8BQCqhHet9ce3xkrF6qjyVcFplqRoya+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 6.12 262/262] usb: cdns3: cdnsp-pci: remove redundant pci_disable_device() call
Date: Mon, 13 Oct 2025 16:46:44 +0200
Message-ID: <20251013144335.668164670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit e9c206324eeb213957a567a9d066bdeb355c7491 upstream.

The cdnsp-pci driver uses pcim_enable_device() to enable a PCI device,
which means the device will be automatically disabled on driver detach
through the managed device framework. The manual pci_disable_device()
call in the error path is therefore redundant.

Found via static anlaysis and this is similar to commit 99ca0b57e49f
("thermal: intel: int340x: processor: Fix warning during module unload").

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20250903141613.2535472-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-pci.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-pci.c
+++ b/drivers/usb/cdns3/cdnsp-pci.c
@@ -91,7 +91,7 @@ static int cdnsp_pci_probe(struct pci_de
 		cdnsp = kzalloc(sizeof(*cdnsp), GFP_KERNEL);
 		if (!cdnsp) {
 			ret = -ENOMEM;
-			goto disable_pci;
+			goto put_pci;
 		}
 	}
 
@@ -174,9 +174,6 @@ free_cdnsp:
 	if (!pci_is_enabled(func))
 		kfree(cdnsp);
 
-disable_pci:
-	pci_disable_device(pdev);
-
 put_pci:
 	pci_dev_put(func);
 



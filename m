Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE38F3AA1BA;
	Wed,  3 Dec 2025 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780783; cv=none; b=rI84VloNW/Yj397uMpfFEhlpcQYC9ha4WxBFNLF4Mvn/L2o/loWLh5EhWQv8sa1FMs/xSkruQdUwX9ETO50Mbn9TEATCnCtZT9yLcX8Pdc0gHmXQIL+k771RzFvC/x4BVOJLqQ6cwfmlOjumSeGFxtvTISjs9Qnz6LGBIWz8xnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780783; c=relaxed/simple;
	bh=w7V9YtJ6QgLMoytHOouy/cBpZNBLugNYVG8G1MhsUJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZkGA3oudHIP6MVyJ86APyMhut7wjUaE2xBQPUuE7EJXfdadQ2LdHTz/tlwJwjNRLGqvUUikvcJzd3PdpKtamNhq06Y/Npmc+Lo1vb2SSYg8wR2IRaJH6xi0XnPXP5oaLvT+VyZdowLFRGvTM7TiKVFhjhoViKQ9KSwAD1Bnfyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehhEG1Ft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehhEG1Ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1E4C116B1;
	Wed,  3 Dec 2025 16:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780782;
	bh=w7V9YtJ6QgLMoytHOouy/cBpZNBLugNYVG8G1MhsUJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehhEG1Ft2hQbYF9Tfosd/hKL1/L4B1IwXZtiXBKTON2oaOrZ6EKxJ+dagAk8RCfhi
	 qyfWxvg121jGVkrze06cM5ZN9PCAS+Jjto6DHUkeRWlX5Lyb3mWK91YNmsYz5EaU/C
	 9JGT+Euoxi2tHeEQdY6OlctTLpAAJkHIegfN8h/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.12 088/132] usb: cdns3: Fix double resource release in cdns3_pci_probe
Date: Wed,  3 Dec 2025 16:29:27 +0100
Message-ID: <20251203152346.551261571@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

commit 1ec39d2cd88dac2e7cdbac248762f1f057971c5d upstream.

The driver uses pcim_enable_device() to enable the PCI device,
the device will be automatically disabled on driver detach through
the managed device framework. The manual pci_disable_device() calls
in the error paths are therefore redundant and should be removed.

Found via static anlaysis and this is similar to commit 99ca0b57e49f
("thermal: intel: int340x: processor: Fix warning during module unload").

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20251026090859.33107-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-pci-wrap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -100,10 +100,8 @@ static int cdns3_pci_probe(struct pci_de
 		wrap = pci_get_drvdata(func);
 	} else {
 		wrap = kzalloc(sizeof(*wrap), GFP_KERNEL);
-		if (!wrap) {
-			pci_disable_device(pdev);
+		if (!wrap)
 			return -ENOMEM;
-		}
 	}
 
 	res = wrap->dev_res;
@@ -162,7 +160,6 @@ static int cdns3_pci_probe(struct pci_de
 		/* register platform device */
 		wrap->plat_dev = platform_device_register_full(&plat_info);
 		if (IS_ERR(wrap->plat_dev)) {
-			pci_disable_device(pdev);
 			err = PTR_ERR(wrap->plat_dev);
 			kfree(wrap);
 			return err;



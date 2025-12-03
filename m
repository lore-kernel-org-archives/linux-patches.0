Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29E822579E;
	Wed,  3 Dec 2025 15:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776837; cv=none; b=D9M1lKvBgS0UQh61qDd2tQahjp19OENSrFgJgItzyfyTlRHb23KKBR0sYOx0Mv1+qubkQs8JaDDtcSjq2pltSNGK+873BnkXOGwMYX9cFDUc0EAWOIMbGHtke+GR6i6OLye3Oui2hSlWe25OfYp0UcBPKfgUfQsaJdJrkx0s9X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776837; c=relaxed/simple;
	bh=AMXO62TGd6imtaguW372UiAC7/mp9QKGVDCUHUYGYKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iq7eH+MTwN5Y/ws9fdmcE3yz/89+zC9I16QU/9GaYDtR4F2BxG3MDM7ndyGgj73P361nYaq/1DgyrCpeDBflQIHBExiKohqgogF/dq7oLZtrPdet82pcXRNJD2elFa8fa5le6zd6leNdUkIYXqyY+/5Jk1ihRTauZm6a5euFpGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJ1xy/rT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJ1xy/rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12619C4CEF5;
	Wed,  3 Dec 2025 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776837;
	bh=AMXO62TGd6imtaguW372UiAC7/mp9QKGVDCUHUYGYKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJ1xy/rTNwhBwrYI5aViScb14hT+B4Om+JThcMeVRj+/XB7QpE148dzZE2l7R8HuE
	 QwAbseiHp8ytWpipiPLrLJWR7js6TWiAod9gBm8TFRcGvJ20lsui8bk7uTZJZ8v7LF
	 sBpJV+8Um0E7/mkTrXoJE8vMLyn2cwJK6tXH94cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.10 278/300] usb: cdns3: Fix double resource release in cdns3_pci_probe
Date: Wed,  3 Dec 2025 16:28:02 +0100
Message-ID: <20251203152410.927627302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -101,10 +101,8 @@ static int cdns3_pci_probe(struct pci_de
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
@@ -163,7 +161,6 @@ static int cdns3_pci_probe(struct pci_de
 		/* register platform device */
 		wrap->plat_dev = platform_device_register_full(&plat_info);
 		if (IS_ERR(wrap->plat_dev)) {
-			pci_disable_device(pdev);
 			err = PTR_ERR(wrap->plat_dev);
 			kfree(wrap);
 			return err;



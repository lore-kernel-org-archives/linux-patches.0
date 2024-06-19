Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2014389C;
	Wed, 19 Jun 2024 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802128; cv=none; b=AGWLUp0nNsLLT092Scc0pf+TJcD9eugxlq4UFeq+YrNZCoJuUhyaGIhs8WDeSSKFbJK8hDFcf20p0928n9nWy2QRya+H40TdvLQVOzQH78DK/hDxYMGo193/puqLti0rmV7VBTtL1gSiYUjQ+hZu7JB+3s2/8R0eyJWKFL+h1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802128; c=relaxed/simple;
	bh=KNeA4R4x12CckLbxRrykSixDPpXQMCxHCysG5c1U2C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmSYk0zcSYTWWfpHqfLXbTN7G0Mmmsd8rKZucl7YLwxotsrBsd0iH5TyiX04YTrYZXJLHxKWLMYaT1cKpVNQ7J+SqqrcnpRCrkCFKZJwVz7Msa1e9ABvvCEKAqL5TZ7bH0tsP6Gx8FaIdbP0Ekj5gpRnTAbnkQzqlV+s7zB7pHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nx70/ipQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nx70/ipQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5585C2BBFC;
	Wed, 19 Jun 2024 13:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802128;
	bh=KNeA4R4x12CckLbxRrykSixDPpXQMCxHCysG5c1U2C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nx70/ipQqiua5tUB3/3WTynM7kiBza7cG+EG5XduJIU1donlRbT9t0sH2ks/BVj0g
	 y0Af6+OXVhvtle4NM2ds1+oCD/cCwPbyu8Qh9zXAZ5gXmbzLy2pRy9lq6tVqFAYwHx
	 455s2af51cJaHAeXMGhV5XMGysw0te4YS5w8Z6Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 092/267] xhci: Apply broken streams quirk to Etron EJ188 xHCI host
Date: Wed, 19 Jun 2024 14:54:03 +0200
Message-ID: <20240619125609.883017689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit 91f7a1524a92c70ffe264db8bdfa075f15bbbeb9 upstream.

As described in commit 8f873c1ff4ca ("xhci: Blacklist using streams on the
Etron EJ168 controller"), EJ188 have the same issue as EJ168, where Streams
do not work reliable on EJ188. So apply XHCI_BROKEN_STREAMS quirk to EJ188
as well.

Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240611120610.3264502-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -463,8 +463,10 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ188)
+			pdev->device == PCI_DEVICE_ID_EJ188) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
 	    pdev->device == 0x0014) {



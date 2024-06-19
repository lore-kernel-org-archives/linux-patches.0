Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609CC147C6E;
	Wed, 19 Jun 2024 13:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803769; cv=none; b=Lz/XPHj/nW4ov+QlyS9D5BOuMsNn+SXtyQB7FBAi9ccfrlmFjCTn7v3wGSob73BSOz1NuSuXOSdjJoHyj56lnpRX7p+gE7N4DzFC7boQAQAVbAdEmqUAUMUYSI1YMgp3ugXojdCCR+ZEWUgD8Wt/kqb7/tkneaJ6KRlI3sfuNxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803769; c=relaxed/simple;
	bh=TRLwRBFjNYzn9wKW1u5BVa29CUCWjBMRpru/NobJVFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7BnNFm8v7W6C60rBRq88yPoy/ZE5k3m32rFlU+RhbrARbYOEGL6G7pENo5owlAnhBHuzePneXor7Q8sxkbnzLWq1YQNlkc0qsB+zpyPMrnGPaiYCCpqhKtjZSHTkRWXqN0HJAVc2OeCuCklOQdgt8USwNKhmNBo6BNzlUyI8JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laioUaeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laioUaeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0699C2BBFC;
	Wed, 19 Jun 2024 13:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803769;
	bh=TRLwRBFjNYzn9wKW1u5BVa29CUCWjBMRpru/NobJVFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=laioUaeSHS6GjOAJlcfurDhagSqqwHNHLHwb49QciagADQwbh91z4SOuYTBwaIRPU
	 dJZroQW2jxKNEVPXA2E2lCnwtsPEQJCdyR+Lz9xh1VGnMJOLcQrs+zYO/DL3fVYQyD
	 psRcMr1I/JLJwqrrxIFfD/KibHMge0tgwb93Ffs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 096/217] xhci: Apply broken streams quirk to Etron EJ188 xHCI host
Date: Wed, 19 Jun 2024 14:55:39 +0200
Message-ID: <20240619125600.395118696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -277,8 +277,10 @@ static void xhci_pci_quirks(struct devic
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



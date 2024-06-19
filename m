Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7E1AD58;
	Wed, 19 Jun 2024 13:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802937; cv=none; b=KCxNdst5/J052lSIBjWASvJYrfCbD5sA+pT7eQk2ydd7uudCkiq4z6nlyQEZfFx5bug5z/FEga8eWqHORwVXSe6GwQE+2IzmJa6QMqGIEGtJeBv7ZIf6+YVN32fbdCI7P8V94QCgBdcrIPDfMZLgQf6UO52HAnLuN0EA7yCbXls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802937; c=relaxed/simple;
	bh=lGI6DQJpVUgXNiJ0XzJ19e8xG9kPVAOYoypAtx8Y46M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qndVtWBnTUyqYOwBqYUHCBwBYnK38C9pE8P8U6cuqN7fAsnQR41LXLRwarRBqb69T3EsLDrpS4G7bnwJVc34xcYdadKsR0LOrQ67sty0WmmOTP4/0PjpLmwzeCzK5+EYE+HrWpTRmCdXTJLEyhfPT4eUQfOZySEBfdru33ccOY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z283CkW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z283CkW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CF4C2BBFC;
	Wed, 19 Jun 2024 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802936;
	bh=lGI6DQJpVUgXNiJ0XzJ19e8xG9kPVAOYoypAtx8Y46M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z283CkW/rmxU2yGPQplusRPXx7rn2ox927lwI8JoZfe9NsxWfMRWLgKMDhrDUcsJf
	 V9wp8ZU9GL8G2YAsp/N9fEmCkHYL1g3zhaXcUGAn85PfEKWwRLBUTxYAtVcuVMJLS1
	 ukO5Mf8svA3mWlVRrXg2AP0m4waeIkC0r3Rl99RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.9 097/281] xhci: Apply broken streams quirk to Etron EJ188 xHCI host
Date: Wed, 19 Jun 2024 14:54:16 +0200
Message-ID: <20240619125613.584322557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -404,8 +404,10 @@ static void xhci_pci_quirks(struct devic
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



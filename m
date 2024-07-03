Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B5417BB05;
	Wed,  3 Jul 2024 10:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003872; cv=none; b=HhMvV8UFinudHWFS1ZqoX8BBrJ2a/wokdjbWx+jaj8TKeeP5fWfX+xVswM2ZzC6UlrCyF/Zk6elnX9/ID16uEcTTSD9dRmNy5rumYpOVJ0zP47jqOv3BP/d4DhHitxXg6ngWJFsN9DKcVFCkvAIiuB+oltj5ba590VX6mkajzQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003872; c=relaxed/simple;
	bh=AJyeJ0qIF1jAy40BOOLvQj028gmvc3OJ4x87ykchBgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcMaXIXKPBQU2e5PnMMp7yCHZTUtIPSfDxPcV6h9g+gMU+aF1wA1xU8WAPJQ3K7hSJCgRkr3gUlAWU6/CBqiYNvRIPMbF6MU6Ek4DCPDcpbHT49llSDySvhoa/iFhKAJy3kkxmlPRaK5PGiWz0bUkk7C60HRAtozbXd63ym6DL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVBvt9Dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVBvt9Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC774C2BD10;
	Wed,  3 Jul 2024 10:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003872;
	bh=AJyeJ0qIF1jAy40BOOLvQj028gmvc3OJ4x87ykchBgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVBvt9DdAHTxkxw2t1qjasKmdF3qeC8YWGUoRc9rVFqKsQKxmulJP13yD4sAsEOkQ
	 aPlg7MUWpD0inissbfKFz9Ehe81/awYw6bbEdUDTt60+q82iV2sUYRrZ7pp7B29zx0
	 PfcpzyUhOkG0JxfCVeRKsR3pb7Rm5NHggcpv+ucM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 048/189] xhci: Apply broken streams quirk to Etron EJ188 xHCI host
Date: Wed,  3 Jul 2024 12:38:29 +0200
Message-ID: <20240703102843.329042367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -258,8 +258,10 @@ static void xhci_pci_quirks(struct devic
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



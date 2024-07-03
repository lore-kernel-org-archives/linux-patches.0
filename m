Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4833613BC0B;
	Wed,  3 Jul 2024 11:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004465; cv=none; b=m+BBKN+Hg0ZLLT7wSgVZxHb8Oq7SNI0hH0tHXhWezvNAq6ur8QNLhapkX3v5ioBhbXzTtTevJ1HyosZX/zXbYFCGYBo2NXnUyuT6J9hSdhATLu5uzVdQC/XUNUBBkGegzXiMCeFAIfrNBS56HsgRMy6tnSuhuD2AW6jQdlGgrKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004465; c=relaxed/simple;
	bh=UpTWxdpq1Z9EvnQ39mQaZWGdmGLP0ZNzbkuqAOv9pH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNphG5VQeLSiCHMcAon/ZTwrVcrTm+N5R8JEd81jXTpgT66N8mNHLtNH/bU6m1u1dZgIBSUoBnouG3b75I4hCmTfpX8EeiLWCbeuohPxWY8hGiWpvW6KE4yB8zCucdPsKBmAyI1a8EuAp3YAia9bKiltY1dfIVjTaTnwRZuwYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/Qmbe8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/Qmbe8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F5C2BD10;
	Wed,  3 Jul 2024 11:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004465;
	bh=UpTWxdpq1Z9EvnQ39mQaZWGdmGLP0ZNzbkuqAOv9pH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/Qmbe8l5ytzXiBZPzkA+BWUeLTwxPcIy3Gl+/1K380IZlGrfzgMVlys7bBXcxFjN
	 bQTal6GSF9OfZsnjVCUt3FckZGS4vtI5w+yKSGyoH6BKBrkRTqxye9Euj3daVQA9Mq
	 kSZIk72XiQu1e9ZmfyZV9jmD8BEosB9aI338q/NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 049/290] xhci: Apply broken streams quirk to Etron EJ188 xHCI host
Date: Wed,  3 Jul 2024 12:37:10 +0200
Message-ID: <20240703102906.055104008@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -272,8 +272,10 @@ static void xhci_pci_quirks(struct devic
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



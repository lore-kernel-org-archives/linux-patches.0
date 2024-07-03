Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A5E180A99;
	Wed,  3 Jul 2024 11:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005529; cv=none; b=jgfpArvYZkD6evK8ssyxCur7NZc1pIdz4avAcRPmqc76vc3OJtJHtZoxJy7yQLX30Jyt/ReOtxQ0Ho7h5CP+X7kUrT5qwo3qt76NewDj7Rqr8tnz7ACOU6eya1jbSev1OdLKo/PPQ9+PtWUYC9N2bVR3hr7bN/Fqtd2XYH+wo/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005529; c=relaxed/simple;
	bh=NN+J4Jewik0wS1N5jUUNEwxZ3z6Cr6thK4lcOnaQASc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phLQT6qhDPKghNqZaXsnag77oL7C0KouPb47kwu4/zn4ugw4G7MgDGfHTFtt2e13V7D7By53kATOfz1682XqjH6MLbonLfi7U15W012IOdCmFrzdXLNfJyvf82JVJ5kOHxT7CL2UHVlLDZjrirxg+EwBB/bP8kyAOtGGToZSyaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oS5I+jsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oS5I+jsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9B7C2BD10;
	Wed,  3 Jul 2024 11:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005529;
	bh=NN+J4Jewik0wS1N5jUUNEwxZ3z6Cr6thK4lcOnaQASc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oS5I+jsJbRgtjTHH1wXbkWL19eEtU+awO1IN7+7YHgMFR2f4Iu0QoHNClHrSmfOw1
	 XIKGb0EHO7qF+pidszVIfycKBmjkr2Lmpvw191HN5MN627ghvvZQ7XGl2luHtSXQwd
	 Ive4bvsR5mA3ZVuhczX220k/Ap+9SChsShdNoZ1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 081/356] xhci: Apply broken streams quirk to Etron EJ188 xHCI host
Date: Wed,  3 Jul 2024 12:36:57 +0200
Message-ID: <20240703102916.168209301@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -278,8 +278,10 @@ static void xhci_pci_quirks(struct devic
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



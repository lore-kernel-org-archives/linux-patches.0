Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC042BEFEB;
	Thu, 25 Jun 2026 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392798; cv=none; b=jhTOpzMo69CVeHeCB9NfMXq36ced7CdIwzRiLaLv3hj1ZZTlgZ5GkfaA2ChMudOiNgTWm+hztkmLDltdQUDqAu9CUIjdhm+zDJuI8h+4R1tr7JS5sXzSNW0OPuJsyAxnTMEV9G02Sw0/CoCyGy1j2wNSA92znGTU7JgV/SNVcgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392798; c=relaxed/simple;
	bh=fgS3XvFcBMPt4dCsg5aqQQvToa1YqMaLiUQoP4q6D7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMvUdnRDIuSDimdGXKmWOzuv3aSMD74PyJykMWalfKQ3uOiaTg+Zh0YpxDGuaJGpNNm4wv14g5BaRy2Zl8h4Lgi1ZX0m/dhMptlS0TAxPD4P48pj8Aea+zK2+MBGNp0+DUsRBOz7hD80BnvSuJ3ax5hMjPJH4O0SNaK8K84w8bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrGGacW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrGGacW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3951F000E9;
	Thu, 25 Jun 2026 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392796;
	bh=iCazKUlU2epKhArGZKePaYc+PN8PpVxzZRQx8rnTEcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrGGacW4pN19mw5qpjj6KZXL6acY8iH+RZaZpJ/eIRQ5WplQhwA1HD93dTc06MmAm
	 bpcL2kNdB92AXSIrjF0oBxSL/X9J1nPUVabIU88+zA9TDTkgGLgn2JgV9pAVGJJr/2
	 pSF5u8epldqFJBy8YvgG1o1ocVVifvTq6f7fcnzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.18 12/60] agp/amd64: Fix broken error propagation in agp_amd64_probe()
Date: Thu, 25 Jun 2026 14:02:57 +0100
Message-ID: <20260625125647.309145181@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit b08472db93b1ccff84a7adec5779d47f0e9d3a30 upstream.

A NULL pointer dereference was observed in the AMD64 AGP driver when
running in a virtualized environment (e.g. qemu/kvm) without a physical
AMD northbridge. The crash occurs in amd64_fetch_size() when attempting
to dereference the pointer returned by node_to_amd_nb(0).

The root cause of this crash is broken error propagation in
agp_amd64_probe(): When no AMD northbridges are found, cache_nbs()
correctly returns -ENODEV. However, the probe function erroneously
checks the return value against exactly -1, rather than < 0.

As a result, the hardware absence error is masked, allowing the driver
to improperly proceed with initialization. It eventually calls
agp_add_bridge(), which invokes amd64_fetch_size(). Since the hardware
does not exist, node_to_amd_nb(0) returns NULL, leading to a General
Protection Fault (GPF) when accessing its ->misc member.

Fix the issue by correcting the error check in agp_amd64_probe() to
abort properly when cache_nbs() returns any negative error code. This
prevents the driver from erroneously proceeding without hardware, thereby
avoiding the subsequent NULL pointer dereference at its source.

Fixes: a32073bffc65 ("[PATCH] x86_64: Clean and enhance up K8 northbridge access code")
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v2.6.18+
Link: https://patch.msgid.link/20260504074823.99377-1-w15303746062@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/agp/amd64-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -546,7 +546,7 @@ static int agp_amd64_probe(struct pci_de
 	/* Fill in the mode register */
 	pci_read_config_dword(pdev, bridge->capndx+PCI_AGP_STATUS, &bridge->mode);
 
-	if (cache_nbs(pdev, cap_ptr) == -1) {
+	if (cache_nbs(pdev, cap_ptr) < 0) {
 		agp_put_bridge(bridge);
 		return -ENODEV;
 	}



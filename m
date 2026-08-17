Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D79303C97;
	Mon, 17 Aug 2026 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975781; cv=none; b=Gd4CGyCouu0Q/kkEBEtT7LbRh1geFNgO4biMpsP3WIzKrGIF0168uM/qm6vjx1Mogecnsz7Dchf+BF6NulZ9U0keA26BUhuItMyRhsmI5/Tfum4p+W1aZmAGPLzBUjQpjje5NNzFM29i9E1ApW6/y2/fiNK6FYLHCzVMum7ad3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975781; c=relaxed/simple;
	bh=4SfZ5SlgToxG5bo6qxDL0pv7EPrp8H4Q/EiXctkzcQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRBUhpzfGNXadY69fSOT5f8IWA3GQDD9GQo1tnrlJTsj0dkJVJk2D+f5QrMVgYnaVnr8VesLbjrg13yWBb2YwnkGGk9vjoDLWMG1OPi78UCKh4ylUrduqQx/fiHwXw03GlozJe/eJZpgFDRLGX0cojMf5l5DZuxRsFRWxst/tCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIESMZhI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIESMZhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5E31F000E9;
	Mon, 17 Aug 2026 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975779;
	bh=/8FnehGfLoFpjA+kfeEbKZOoLpcLFkURUcyyEfQjmQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIESMZhIFPztlksJvq4fA6DEl5nf0vpJkBDYIZLCUlKboX2mX+EVUdihWqiSw8RD/
	 YxYioo8kAgvkleRntKKhbRJmISZRzSbOsu4FW9KZf2i8zEozTQ9c6SWrGUApxRWDql
	 mzvLYHK8KWCmkB1zPB8lPnIcqUN3gouo40upKrG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 145/389] wifi: brcmfmac: make release_scratchbuffers idempotent
Date: Mon, 17 Aug 2026 15:29:44 +0200
Message-ID: <20260817132544.819804185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 538c51e9d124cf656f2dd0c0394a8545efc7102d upstream.

brcmf_pcie_release_scratchbuffers() frees the shared.scratch and
shared.ringupd DMA buffers with dma_free_coherent() but does not clear
the pointers afterwards, unlike the sibling release_ringbuffers() which
NULLs commonrings/flowrings/idxbuf on release.

Both the bus_reset .reset callback (brcmf_pcie_reset) and
brcmf_pcie_remove() call release_scratchbuffers.  When reset teardown
has run before removal, remove's own teardown would call
dma_free_coherent() a second time on the already-freed DMA allocation.

NULL the pointers after free, matching release_ringbuffers(), so a later
release observes that the allocation has already been released.  This
patch makes repeated sequential release safe; the reset-work lifetime is
handled separately by the following patch.

This issue was found by an in-house static analysis tool.

Fixes: 4684997d9eea ("brcmfmac: reset PCIe bus on a firmware crash")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Assisted-by: Codex:gpt-5.6
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260718024353.3147201-2-fanwu01@zju.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1246,16 +1246,20 @@ fail:
 static void
 brcmf_pcie_release_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 {
-	if (devinfo->shared.scratch)
+	if (devinfo->shared.scratch) {
 		dma_free_coherent(&devinfo->pdev->dev,
 				  BRCMF_DMA_D2H_SCRATCH_BUF_LEN,
 				  devinfo->shared.scratch,
 				  devinfo->shared.scratch_dmahandle);
-	if (devinfo->shared.ringupd)
+		devinfo->shared.scratch = NULL;
+	}
+	if (devinfo->shared.ringupd) {
 		dma_free_coherent(&devinfo->pdev->dev,
 				  BRCMF_DMA_D2H_RINGUPD_BUF_LEN,
 				  devinfo->shared.ringupd,
 				  devinfo->shared.ringupd_dmahandle);
+		devinfo->shared.ringupd = NULL;
+	}
 }
 
 static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)



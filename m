Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579A743BDA7;
	Mon, 17 Aug 2026 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979437; cv=none; b=Pr6XnVltCNi3WcQQYxftmUOq68wcLmmAtu0m4MOIO7YoVtCo/9rLEMTLwqw5G5h7ihamcZS/Lu4/60dhehUGy+zx4EuQ5nOBUQ/St/xChEtYrhxKI/eEfiVbrs/VRWOz7L2YqLpxNLDXGXnSzLk0FCv0Mi+srvzdNhccth/VkiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979437; c=relaxed/simple;
	bh=j8SDr1U8jPySX/ssvE7FGxycF1zja5ORkIkNPhmkDG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQIlMTRyh6+CeDAV2HpxQo93DhywRoeZZyIJHy9EC8x+kBBY8CRefqExP2+NcEo2BB+3Lhalc+PNTlao4rwqQLw9L1DQQLC1pJd5ch3qC0wn2oKdeyognXhWmkpmPBQfmzIznfstNdwgbbosMezp7OMHRL/uvGrqKz0Oreupnng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7WFhFUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7WFhFUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C781F00A3A;
	Mon, 17 Aug 2026 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979435;
	bh=pl9YMWNPuhj87IEH11KkFx4Fp0eZyrqVDZ6J3X/n6Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7WFhFUnTjdy7n+jzleFqCJNj1Ily2s4+zuLW/MnX7la7uONMDFKVbxCxi8p7TrZK
	 QOwZyFkViHKUUwClZxr0lcqGgD/ka2R5wBClANR4ve05vRf8GP5bH8TzetYXhPpu7G
	 xoc3Qrr+srPFje/ErUqg4JooRZEynfRJvu0IKldM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 224/609] wifi: brcmfmac: make release_scratchbuffers idempotent
Date: Mon, 17 Aug 2026 15:28:40 +0200
Message-ID: <20260817132551.584980278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1356,16 +1356,20 @@ fail:
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



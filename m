Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3BB43F0B0;
	Thu, 30 Jul 2026 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426249; cv=none; b=nWKZ45vSaDydbjfSuS7TFlfOWdu6wac9S8QSmM06xysRr+zHvKOG0GJmft8v2QEuUqdnrG9uThABNcdn8OxigD6ZTrnvUXqyc8anR3UH/MkokckArQjZj6Mw1xQxY+jw8vQSV//4dZu0SiphbZCbgw64xfK+MEwF196Ls+0rP04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426249; c=relaxed/simple;
	bh=w5g0zFtgza9DD66RBa+x+ZgMYviVoHV5JH9+1bko15Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izEMCvmToFeULHaOj9rTII4t2PMjLc7e0b0AF6meLr9aQRfEyIStxe/WRbAqhzfLeU6xb4RtoR+C7v5EKqyQhUDfkM9CXg5bCI5/RsXJwUeRFj2eSj0t2C8KbhLQJtQd1/i7StOeF+we2NlbrSvXG+XC7HOU5To7zTqIolO7xXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNahh56N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNahh56N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EF91F000E9;
	Thu, 30 Jul 2026 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426246;
	bh=0n+cIZZPhGOP+uDroEO3++ygbPD4+ma/zUhp60sY0BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNahh56NuRpMULF9kl6UnYrzxKZLR+PAQ3gQWNYAmETFlEodXGORIFqB5AobqmuBY
	 QZQKYIHNKy5es7mOB45YXqkOL3IwcMvi149h893chuZ5fCr+t1QVpqWqYrb4oYVJUA
	 WD65Xe2ygOtPRjtqUIlyT/Wtv/GT2b5gRH/ulJ6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 352/602] wifi: brcmfmac: make release_scratchbuffers idempotent
Date: Thu, 30 Jul 2026 16:12:24 +0200
Message-ID: <20260730141443.356555976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1376,16 +1376,20 @@ fail:
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



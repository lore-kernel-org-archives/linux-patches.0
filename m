Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE1C415F23;
	Tue, 21 Jul 2026 19:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660733; cv=none; b=i1gYoQgPaxYf2dhFde0DDge6droG2k7p6iUAqqEZnBR4UbTF0wiYm5NadMdGCeQJmD/sPELRBOG5782J7P9qIOdVgbUaVrBxM/lIXzvkelwXcvY/Dp8on9KYD0f2QHY1xBL24ytO5SaJcTd+xMaYcdjgKYgj4T/+jYma0ryX1eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660733; c=relaxed/simple;
	bh=LYVGVGHNKvnjIES8i/cNI3Lr/NrAFqJPlGjIk6TXpy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6af+PL5rP3pl/8eCiZYpBI2ciWEfHcxp3R0F68KaK1K7HlBsN333P32I1LVSqYpD89kFD5gZW789USGOLSRQ5hKtDIlg2wv7GPty/p3s9qsJkVpFoUb5omjy/YRDc7jSNiXexb6VA+22cvXEpVQUUjiPcFP4k6U/Wb1KtGul0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRIP44sT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRIP44sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A261F00A3A;
	Tue, 21 Jul 2026 19:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660732;
	bh=rLH9Xq7KAPoC0CKKgBlIfzsJxO2vzqqc7nAZA5aslUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRIP44sT7ffw0JF2GnJNSJHeCOdzNLncFHLNiL8fd+3c3rjYqoS9OR27iiK7RoZ9L
	 AKoY52DitiG31VWrm8iv+ZybWWXNZTSxLhI+ZEPxUlCQkJ93Uy2wcw29yM0A1Z9Mgt
	 MNHPxInGdqgL8VtwlW6O3aa6jZG+vV+g4nJbpqh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1090/2077] ALSA: usb-audio: qcom: Free sideband sg_table objects
Date: Tue, 21 Jul 2026 17:12:43 +0200
Message-ID: <20260721152618.532348829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 7d69804a35103a50852eae41bfe6a2e0061c68fd ]

The Qualcomm USB audio offload driver obtains an endpoint transfer-ring
table by calling xhci_sideband_get_endpoint_buffer(). This getter passes
the endpoint ring to xhci_ring_to_sgtable(), which allocates the outer
struct sg_table with kzalloc_obj(*sgt). The event-ring path is
equivalent: xhci_sideband_get_event_buffer() also returns the result of
xhci_ring_to_sgtable().

Inside xhci_ring_to_sgtable(), sg_alloc_table_from_pages() separately
allocates the scatterlist storage referenced by sgt->sgl. The returned
object therefore has two allocation layers: the outer struct sg_table
and its internal scatterlist storage.

The Qualcomm caller only invokes sg_free_table(sgt). sg_free_table()
releases the scatterlist storage owned by the table, but it does not
free the separately allocated outer struct sg_table. The local sgt
pointer is then discarded, so every successful endpoint or event-ring
query leaks the outer object.

Call kfree(sgt) after sg_free_table(sgt) in both setup paths, after the
required page and DMA addresses have been copied out.

Fixes: 326bbc348298 ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/90B353283AA150C4+20260616115916.1222915-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index 649228421e2f69..ccb5ffd73a66cf 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1165,6 +1165,7 @@ uaudio_endpoint_setup(struct snd_usb_substream *subs,
 	tr_pa = page_to_phys(pg);
 	mem_info->dma = sg_dma_address(sgt->sgl);
 	sg_free_table(sgt);
+	kfree(sgt);
 
 	/* data transfer ring */
 	iova = uaudio_iommu_map_pa(MEM_XFER_RING, dma_coherent, tr_pa,
@@ -1234,6 +1235,7 @@ static int uaudio_event_ring_setup(struct snd_usb_substream *subs,
 	er_pa = page_to_phys(pg);
 	mem_info->dma = sg_dma_address(sgt->sgl);
 	sg_free_table(sgt);
+	kfree(sgt);
 
 	iova = uaudio_iommu_map_pa(MEM_EVENT_RING, dma_coherent, er_pa,
 				   PAGE_SIZE);
-- 
2.53.0




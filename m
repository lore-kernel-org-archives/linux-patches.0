Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3363E471248;
	Tue, 21 Jul 2026 18:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657580; cv=none; b=oKAUxdYTGxIyz/e7Zc88BEooWpe4hgtRNhMprT/Mepe8fC0SNNIxUDzQTa1qgixCgGk24pcSXDb0xe9Ac4Jui+OUGnbbyinl1MjJ1d1N4XRdHyxmf7vymCabkIrz2OsSojvwVQFwXojQiCUFX4cf36CQDzKukOPEqfg73Yb69+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657580; c=relaxed/simple;
	bh=00f7K+ibZIP2cegE7PA7SpKHZjvRDFA9cEMoo1AjlPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usu3wDvMCX3vvbTED7yLrnJ5HwAk95UKQ1qBdbUYTM3cgvk5D183Iuota2k/wM9D5rm+eNwQc28EAsxmKhevmlHeNKfwx6k5LAhKC4dWgnYRaMc/VRzd8mXq/gCQFp1igo28Wvn7MsZ6DlDrAol95SZylWD28d+P7Hr4GCbl+C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m291DAEK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m291DAEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7751F000E9;
	Tue, 21 Jul 2026 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657579;
	bh=vq7xShYUOAFGWcJ7b8P2QT97s6NSLKqcsFi6rQUptSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m291DAEKRCs2OHN3C+ZcIEjYJxXeiaSQTpU8kHUU798IVY22KLc6obQu2vLl4hb/r
	 +uMLz2BYp3s8bBScbhYnSj1Dkpv0sgceViCP5BcXY0VRKDcEyfo88e2ABUOcOavkdh
	 wOoHfVa8HgO3LAmyDABlHpO7ndJ5Boklv3hCqWRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0791/1611] ALSA: usb-audio: qcom: Free sideband sg_table objects
Date: Tue, 21 Jul 2026 17:15:07 +0200
Message-ID: <20260721152533.180919802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 962b5f27f04478..26b632baefadc9 100644
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




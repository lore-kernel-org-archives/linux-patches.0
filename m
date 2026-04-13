Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6D61D6DB5;
	Mon, 13 Apr 2026 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096256; cv=none; b=HU7yOeRSBmhgAlh2s/JfpEkqdu9em2S/Wg8wj3pQADipgH+2dKfb15asgnUDF4coU2rv+yfwA7bVkTOAoVvPiP9yW4gFHP2b2PpxL8KYbxU33Py7+VHysRawRT55wZmiLR8E9kP313tQ0CNXLx27Xlz8Y7C/yv7w6/7o9K9TARY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096256; c=relaxed/simple;
	bh=wzpSCBfuywZmk+mjNTdGyO34hS/dzf5vRdSMiXEmFIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViE8A4ESlRJPCcTIgOAQ9pjE4WHyH4YyDVss0HglTZ7rVeGBqdd7jYwLFDN3v8iqXRPGfFkvJ1Q+XQmcdfzt8o5JBXuEu05+rPe+0G+snriY1gnmwSDd/e7yOhixPLBJVSfNCFqMYzbHfJWHLDV9pVDJI1HBOuqTPMheE6fDo5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAv4kNUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAv4kNUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E504C2BCAF;
	Mon, 13 Apr 2026 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096256;
	bh=wzpSCBfuywZmk+mjNTdGyO34hS/dzf5vRdSMiXEmFIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAv4kNUFCshqrOyjdooNHQGTcmMMMss1km4381iM2hMI3bDcl0OmCJZyPce+rbHIb
	 R2rFcUysmpZiRosdB9EH8Xdj/xklpdJrNYcU1Da0q6eFpRPnH+bH5zOE9d87QVOqAk
	 b5KYaHYF9tUGA8IfPxQgp3WjHbHVaDkB8frQaCFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.19 27/86] wifi: brcmsmac: Fix dma_free_coherent() size
Date: Mon, 13 Apr 2026 17:59:34 +0200
Message-ID: <20260413155732.590372756@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 12cd7632757a54ce586e36040210b1a738a0fc53 upstream.

dma_alloc_consistent() may change the size to align it. The new size is
saved in alloced.

Change the free size to match the allocation size.

Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260218130741.46566-3-fourier.thomas@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
@@ -483,7 +483,7 @@ static void *dma_ringalloc(struct dma_in
 	if (((desc_strtaddr + size - 1) & boundary) != (desc_strtaddr
 							& boundary)) {
 		*alignbits = dma_align_sizetobits(size);
-		dma_free_coherent(di->dmadev, size, va, *descpa);
+		dma_free_coherent(di->dmadev, *alloced, va, *descpa);
 		va = dma_alloc_consistent(di, size, *alignbits,
 			alloced, descpa);
 	}



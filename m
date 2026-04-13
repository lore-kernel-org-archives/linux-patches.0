Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58762F8BC3;
	Mon, 13 Apr 2026 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096717; cv=none; b=qPX+Y15ipBCCm1ixW48arb3aL+EhkyZ7TrHtORT+vBq5RXAiCqpFB5T6isZx48SHaS8uDXdEEzEvIwE09OD9aTHdS+msaaDvhGPwp4x7OVQbwh7PjgNj/4P18n+jxylAe/cZCzgTJwwtId4zOAqIE/rIUpFod8NIvIY3yNNug30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096717; c=relaxed/simple;
	bh=/th11HdEXUYQKBddLuBYqfxEGlUz7ZCs4i4k8yYTFtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz3u8uSg/Gprw38kc/RcKR2ScI0uzdjEhxcO6COQ8m7aU36O+gq4Bz5Ih2BXQABgbL2zIXe/awYC2uFZit+C+t9DOZ1s7YneNEVg91Jy8i3ZybiPNE/KioXbZf9KMiNHiWZWiCQPQocjQrS0JOpexav6vOuQwV9k76ldm1bXzD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nwBCapd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nwBCapd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0FAC2BCAF;
	Mon, 13 Apr 2026 16:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096717;
	bh=/th11HdEXUYQKBddLuBYqfxEGlUz7ZCs4i4k8yYTFtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1nwBCapdRwI9sPw5F8gdhjHoJQBmglB5dKXFRvuZyzQjfTRAj/C4xdkbvBftnOmoq
	 gSMJdyOjyb/UOJWrzX7CSD3zhJ5GVoa3Lw0rOYqWFustQRWZt3V5XveTliCdsNFo48
	 fyxuz1sKM3yk8iZKq/UOHvCbjyatNrRS3xMdI5TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 35/70] wifi: brcmsmac: Fix dma_free_coherent() size
Date: Mon, 13 Apr 2026 18:00:30 +0200
Message-ID: <20260413155729.494233746@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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



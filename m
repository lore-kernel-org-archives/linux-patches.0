Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F940337BB5;
	Mon, 13 Apr 2026 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099707; cv=none; b=GsOLAUys9jBvyC8jo/LY327cD38m8W5BtJ10bkMn7d+rXxGrmOb9wB6yvhrOVF3PgYmauZqYSl5hKWCjKCC2e1lp6/383MNMOpefL3vDrw8VqAFYYrVtyISi7IOZeCwtmyLeIdc3aQcFhy61dVGwm+kU9HSytEQ8bod+3WkxlVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099707; c=relaxed/simple;
	bh=7fKtP9KwUL8bfBa3AtjKdT+JLhB2+r+h46vcvzLIscg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OukTL2CtgJGU8FUcaVNU3rfqZvxnmhh3RnlMbArn5XDoH/s9EiZXF8QE52M/APc4RS3bXnVYGzbeKxso2/BrFskQpHBcQLcJznf/OROKXSGM1Mxy35NUeBxJ+CKtlgabXTo008oH6dzoyCjBYsa/67uv/FHHhqOBWYRZBr5gYxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px2XYNPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px2XYNPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358F7C2BCB3;
	Mon, 13 Apr 2026 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099707;
	bh=7fKtP9KwUL8bfBa3AtjKdT+JLhB2+r+h46vcvzLIscg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Px2XYNPMZBTzgyUBa+0HlkR4JXV7NhBUbOHkdGq9yGGVe9P8Jn74HGM7/T6qfAmHb
	 dglN2/cMT7SpgEZvGFZD1xx1ZNvvRSGD20WHD35C5ItuJTuJLCt602p/hvA6C9Rq68
	 jgZvtKY8uoHMI4Lmt8dgbtG9oVR9q9uXfTfqFaeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 443/491] wifi: brcmsmac: Fix dma_free_coherent() size
Date: Mon, 13 Apr 2026 18:01:28 +0200
Message-ID: <20260413155835.613050116@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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



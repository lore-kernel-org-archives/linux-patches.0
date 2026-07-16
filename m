Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5E13D4133;
	Thu, 16 Jul 2026 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209394; cv=none; b=by5tzFhf/fxuJ0xGYR15KqI8paMzJD3OcJmnO/nGBxa+2JlMn5hyI8/oz1s37Y9Ue3M+IetOA50h4yUGeJIaqfpQG724yLxoArcUNztbMzW9y01Ghwh98B/RqJWG7AkTwx74Z5IuFf799ILU1MAGH/KtFOgXAXUVkSmfVckm9vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209394; c=relaxed/simple;
	bh=sJbOQbn9lKk1y8a6NslR+G3CZYNyeOR0aFLJMF3Tfr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQVyySvh1qSL0qkwrssXMdy86DXhcp4kSU/VHcpqzpZVvVJYip9hXwHgkpQiScD1ykIsKt+ZSiZEFuAc04ogUtdhe9if+5bhv55VFn4r1udkXm0d6UxDMbBGYHpNNO6BeXtFuEKzrgmaHy14gfT/EC7EypeajE3g2rBSZV1rcHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3ZRxg84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3ZRxg84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4EF1F000E9;
	Thu, 16 Jul 2026 13:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209392;
	bh=Xz09Um8uJoFUimtxWHL12KCvxYAC7PDFVsqo8oRIAvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3ZRxg84l7sWTeVXdkthQPwdUPG/xOyzCE3lOkATKgFrJqkFAGMOfqGH8Iy1aYTTr
	 t9Ib4BBLcCVsEoQ9zcPeSk1xWGF/SkCiOL1XFKSLm/rMsMB0mW5sMf2vNsI5wqE8Bb
	 Qx3/5ydZIwcn66W9wcbWaUy4dMSdNdLuz2Imw9Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.1 125/518] xhci: sideband: fix ring sg table pages leak
Date: Thu, 16 Jul 2026 15:26:33 +0200
Message-ID: <20260716133050.591173816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

commit 49f6e3c3ef19f04f6657ed8dce550e36c763abb8 upstream.

xhci_ring_to_sgtable() allocates a temporary pages array and
uses it to build the returned sg_table with
sg_alloc_table_from_pages().

The error paths free the pages array, but the success path
returns the sg_table without freeing it. This leaks the temporary
array every time a sideband client gets an endpoint or event ring
buffer.

Free the pages array after sg_alloc_table_from_pages() succeeds.
The returned sg_table has its own scatterlist entries and does not
depend on the temporary array after construction.

Fixes: de66754e9f80 ("xhci: sideband: add initial api to register a secondary interrupter entity")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260703144033.483286-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-sideband.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-sideband.c
+++ b/drivers/usb/host/xhci-sideband.c
@@ -58,6 +58,8 @@ xhci_ring_to_sgtable(struct xhci_sideban
 	if (sg_alloc_table_from_pages(sgt, pages, n_pages, 0, sz, GFP_KERNEL))
 		goto err;
 
+	kvfree(pages);
+
 	/*
 	 * Save first segment dma address to sg dma_address field for the sideband
 	 * client to have access to the IOVA of the ring.



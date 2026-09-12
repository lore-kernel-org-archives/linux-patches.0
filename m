Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C2E3AFD0A;
	Sat, 12 Sep 2026 08:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201907; cv=none; b=CTmNZIP6wQCX1p3rJJXbwrSNMQt1zi/dQuc3yRfFEOcOKNeYAx/0u0+AbY291pGxo7tGkMFqrg8CKuVrIX8w+2iMBKnE2QM1GYn7A20l2vavjPiyLIsgMWOZaQTucrH3oEIYMQizVooZZTF9KgXEPjPzhFaRx+/feqW67V7fxYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201907; c=relaxed/simple;
	bh=0X7jmGkQ869LEcVVwfilsBeRYRqNzKWACulVAY6Qx+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvCvnutvUviFK+3baV6oYp6AZibWPsxqeydGMtosG/GgDGcxne4QFWzm/FCN5KizA4diu+gEa/8YRFZi1XL6aSLVtuCSy5Wn/Yu8eydzqlhIWzAJ7srxWiwXNIKNZTc4eK+ThnICxvhx42SWbYWMnNwrn1rFKXwTcpNb05jTcz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAhYVlnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAhYVlnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D271F000FF;
	Sat, 12 Sep 2026 08:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201906;
	bh=vyIo8H2zkNOhHENSTSz2CdeP5rNV949Dq6tmZwcs0ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAhYVlnKqc8Og3PGK9m3hE7dsLh4wQZv57L0wScLPSGBr8mmmBrZ2UPAt84E4fdbI
	 yACz6AXooOMtw1VFstASruc4iOIJrjKBbUqYR4CcbUTtpHvAEViJuewmHkgNxQGMRe
	 K3QTdTiBNQENAqeGHKsfGAposjv71fpaiDB0I12E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1091/1815] thunderbolt: stream: Restore consumer if copying from iter fails
Date: Sat, 12 Sep 2026 08:47:21 +0200
Message-ID: <20260912065714.632773681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 039701ea3d76ec004863fd7437fb56a9146cb094 ]

In tbstream_dev_alloc_tx() if copying data from iterator fails we leave
the consumer pointer as is wasting one entry in the ring. Fix this by
restoring the consumer back in case of failure.

Fixes: 6db21d817b43 ("thunderbolt: Add support for USB4STREAM")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/stream.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/stream.c b/drivers/thunderbolt/stream.c
index 4cc86d8d64918..c456f18ab4cd5 100644
--- a/drivers/thunderbolt/stream.c
+++ b/drivers/thunderbolt/stream.c
@@ -512,8 +512,10 @@ tbstream_dev_alloc_tx(struct tbstream_dev *sdev, enum tbstream_frame_pdf pdf,
 	dma_sync_single_for_cpu(dma_dev, sf->frame.buffer_phy, size,
 				DMA_TO_DEVICE);
 	if (pdf == TBSTREAM_DATA) {
-		if (copy_page_from_iter(sf->page, 0, size, from) != size)
+		if (copy_page_from_iter(sf->page, 0, size, from) != size) {
+			sdev->tx_ring.cons--;
 			return ERR_PTR(-EFAULT);
+		}
 	} else {
 		memset(page_address(sf->page), 0, size);
 	}
-- 
2.53.0




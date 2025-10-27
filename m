Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3912DC33D;
	Mon, 27 Oct 2025 19:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592591; cv=none; b=Xg3L3osxxHx9vnZF9nhv2hsk4zJyxkCVyWjOaQxusvhTwTwW/f5ZZtfZAgwIMBJI42mxSJ7VeQG8Id1SgM9wC03sE75dzP3mAMVo+Lkk99/+v4kGBBumc0YZZ2yx5t1Y44K12f5U3cANZjVpiHGxQd/PxEhcU9iwZBwGuHnp/0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592591; c=relaxed/simple;
	bh=2awGQTVe6ylerQ3YKE+FEIeA0Q69e0cDEKRFW/Qzwgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dX/GXx0cRyDZ2oh8dDBhS+RQr549Cg9G4Jf9OQid/toUqnOZPKoTMd0/i7PY3fAN1ZPVoPrJgu7gJF00H2IbU6cNTA4ucFdVO1OlbtE8rzOgZqE3TffjBQxg64k7ipzyrXdB3X2l0CTLu8NsZX/Wh3ZaSC8D92RJrGwYzygvRlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/hwFuSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/hwFuSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3C4C4CEF1;
	Mon, 27 Oct 2025 19:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592591;
	bh=2awGQTVe6ylerQ3YKE+FEIeA0Q69e0cDEKRFW/Qzwgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/hwFuSPhy2xzNYOyzp6TRQxS8BIRAWFiP+4w2f9sRhnpuvmJpiyU6VMp/3o2FuMS
	 w1T6UF4008l17fQYjMex4rfz9vXxZWfMYiycr2KvgCEGDrNMto5+Jgn2LeMOprDbuW
	 2nXYr443xzx+mQkJ7ZKU2WIA/K5aK/fHGRJuKsG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/84] net: enetc: correct the value of ENETC_RXB_TRUESIZE
Date: Mon, 27 Oct 2025 19:36:10 +0100
Message-ID: <20251027183439.385661697@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit e59bc32df2e989f034623a580e30a2a72af33b3f ]

The ENETC RX ring uses the page halves flipping mechanism, each page is
split into two halves for the RX ring to use. And ENETC_RXB_TRUESIZE is
defined to 2048 to indicate the size of half a page. However, the page
size is configurable, for ARM64 platform, PAGE_SIZE is default to 4K,
but it could be configured to 16K or 64K.

When PAGE_SIZE is set to 16K or 64K, ENETC_RXB_TRUESIZE is not correct,
and the RX ring will always use the first half of the page. This is not
consistent with the description in the relevant kernel doc and commit
messages.

This issue is invisible in most cases, but if users want to increase
PAGE_SIZE to receive a Jumbo frame with a single buffer for some use
cases, it will not work as expected, because the buffer size of each
RX BD is fixed to 2048 bytes.

Based on the above two points, we expect to correct ENETC_RXB_TRUESIZE
to (PAGE_SIZE >> 1), as described in the comment.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20251016080131.3127122-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 860ecee302f1a..dcf3e4b4e3f55 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -41,7 +41,7 @@ struct enetc_tx_swbd {
 };
 
 #define ENETC_RX_MAXFRM_SIZE	ENETC_MAC_MAXFRM_SIZE
-#define ENETC_RXB_TRUESIZE	2048 /* PAGE_SIZE >> 1 */
+#define ENETC_RXB_TRUESIZE	(PAGE_SIZE >> 1)
 #define ENETC_RXB_PAD		NET_SKB_PAD /* add extra space if needed */
 #define ENETC_RXB_DMA_SIZE	\
 	(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - ENETC_RXB_PAD)
-- 
2.51.0




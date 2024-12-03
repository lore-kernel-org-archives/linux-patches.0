Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810A1EE00B;
	Tue,  3 Dec 2024 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242747; cv=none; b=IIbwRr2c1ena4flYLxdnUZ85ECcZQKgrlnLJCzLecJyl8zJFCvV/NYFuTPhSnH+cywYv/8BzeAtoh+ybqxrGx5oL5vxUyqPgb1/HFng6LyOz9OV60oSWUgv90V3VuPW6Q2RTZWnvuxAywj9ldy/XpA7n90EnKD9/tH5XQ4cdVdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242747; c=relaxed/simple;
	bh=B7enR28gZTSS2qOOVg1zw8iH4LhmqieCmXqF2xF0isc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMF/PqfmDMpRCrcu7xlZ1x6TjtR/PKPpPfOecsXDpB/jLPHyU2xkni7Z2ydHboin4YE6Q6My1uYUoSWVruuD+mmb/KKzoRiX+c1/+0m/wWBxxo5vI5m2EnhzVGD/BFtXpnxXfwb9A+lW9EhMB176/dgxAmHLV1KOvcJFoijTzqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny7FZ3Cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny7FZ3Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A907C4CECF;
	Tue,  3 Dec 2024 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242746;
	bh=B7enR28gZTSS2qOOVg1zw8iH4LhmqieCmXqF2xF0isc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny7FZ3CdM+NSdbzqfUftvJYj/laPgtmXH/nmsOJE86WeCNiUIcyotmQIB2PMH/LET
	 jpvk4HTiC7GGA9KnBIlt3PTF4BRGCemfB1L49463hHOeLx/dKqnWnjbLsYVEEmfrSt
	 fRRs1EqGHlKypICSQv1/gUyIH6LLESOpj8L9mcGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 798/826] 9p/xen: fix release of IRQ
Date: Tue,  3 Dec 2024 15:48:45 +0100
Message-ID: <20241203144814.887271985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alex Zenla <alex@edera.dev>

[ Upstream commit e43c608f40c065b30964f0a806348062991b802d ]

Kernel logs indicate an IRQ was double-freed.

Pass correct device ID during IRQ release.

Fixes: 71ebd71921e45 ("xen/9pfs: connect to the backend")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241121225100.5736-1-alexander@edera.dev>
[Dominique: remove confusing variable reset to 0]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 0304e8a1616d8..b9ff69c7522a1 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -286,7 +286,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-			unbind_from_irqhandler(priv->rings[i].irq, priv->dev);
+			unbind_from_irqhandler(priv->rings[i].irq, ring);
 		if (priv->rings[i].data.in) {
 			for (j = 0;
 			     j < (1 << priv->rings[i].intf->ring_order);
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC5D2E3363;
	Tue, 15 Jul 2025 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586174; cv=none; b=Qqfbs+5XVTtlEtZeCYxXzuxPkaJPSK0TgzgEuW9D+1wDSL4ovidMZK0QCXmXT4O/J5QLdt/je27dc5ckmOjla5xq4h88ZLzu49ae1CCWlxc2qlgg1AklR0N7gcRSLmWz8Toq9pB+qEeJjxIIlux1lXFFmzjbeXtSxEl2YDTkX64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586174; c=relaxed/simple;
	bh=xXtlmuAOD5+GRXSDhmlC2Z2kT0+dKf/17YZb+i7XqQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNITBpeEhIQ4Fqiq9+QFVN8508QaTl7TPZSDdKw9zC2Vt2OypCvEMF4No5yPiy1Qb9KwbV4lKyuGLHf4gYxldIXiPTHwIcsSYZrmdsmfb47mQh03YPpFAnCzv/f50OyNeMcORTBAT0qX0yczJjF0fa04D6FbKkYyC9xRNjqlrfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSP1ST+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSP1ST+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E578C4CEF1;
	Tue, 15 Jul 2025 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586173;
	bh=xXtlmuAOD5+GRXSDhmlC2Z2kT0+dKf/17YZb+i7XqQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSP1ST+VOTCkGOZPlG2WA4aFLty8enTnFKHCZcIJMkX/7DiAM1vN4nSAv7lhVby3V
	 Eoc9OFhn6d4e73XaM2yJzwecQRtvxJkCa+3HA0AkHUSTGtCU/Oa/R+EXPVDq0tx13t
	 +k86v0Hsf1Y8yO8TM0nYxERDY1ZEXrPqDmLfX9g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 44/77] xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS
Date: Tue, 15 Jul 2025 15:13:43 +0200
Message-ID: <20250715130753.480818737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

[ Upstream commit cd65ee81240e8bc3c3119b46db7f60c80864b90b ]

Disable stream for platform xHC controller with broken stream.

Fixes: 14aec589327a6 ("storage: accept some UAS devices if streams are unavailable")
Cc: stable <stable@kernel.org>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 83c7dffa945c3..daf93bee7669b 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -361,7 +361,8 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (ret)
 		goto disable_usb_phy;
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		xhci->shared_hcd->can_do_streams = 1;
 
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);
-- 
2.39.5




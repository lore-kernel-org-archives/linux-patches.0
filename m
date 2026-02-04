Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCCB40758D;
	Wed,  4 Feb 2026 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216281; cv=none; b=Mx2nM0OauXqf0xRrydKc19/kRzD2HJem+ur/OIXqO0CzUoRAYCIy6Irr+InOXrORS2Vin9daYX+nDtkv+lt2EH2ag9s1KBVdminiAmPOQyeMY0qhgze59/JqYENH63o6B2Re0KRwyYdwZtmdajCCUHdNcHAaOJH9EZN4fCm4hz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216281; c=relaxed/simple;
	bh=oCDubmWtmpkR3h+Ws8Oy8aAVPLd84OL3d+kpgGTtpSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZbd9N4+wt52BxTL+hyTH2hCZCJt1Oxyp5g8zKxhod9gS9kC1GFmROH+EiOl1iVp4p2MXGMcrSo4CsrXtpFyfi8FGD9N3JWkHyc0zHbeOE4FNRB/Ojer274A17P+1rShrf0Nz+D1ou8J3YAGHB1BFLC+YkxqBzf9FCVVM6HcCJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyYzMUOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyYzMUOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461D8C4CEF7;
	Wed,  4 Feb 2026 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216280;
	bh=oCDubmWtmpkR3h+Ws8Oy8aAVPLd84OL3d+kpgGTtpSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyYzMUOtxa0rDm6tMPiLYJbKnL9mNr+H3XAiwaXhrMCjlYtv6iQITTawxeyqxzZ8c
	 frQV2v1CJTeZ8PWy/UbfGtaBiAFULEPhDaVjmILBSjqYpeJkgt3O+HP59OG7hhWra0
	 XEToFBPtfwsDbG0TnGGQ97G2aq1bC1ixeTMTjWgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 042/161] dmaengine: ti: k3-udma: fix device leak on udma lookup
Date: Wed,  4 Feb 2026 15:38:25 +0100
Message-ID: <20260204143853.278217201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 430f7803b69cd5e5694e5dfc884c6628870af36e upstream.

Make sure to drop the reference taken when looking up the UDMA platform
device.

Note that holding a reference to a platform device does not prevent its
driver data from going away so there is no point in keeping the
reference after the lookup helper returns.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Fixes: 1438cde8fe9c ("dmaengine: ti: k3-udma: add missing put_device() call in of_xudma_dev_get()")
Cc: stable@vger.kernel.org	# 5.6: 1438cde8fe9c
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-17-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma-private.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/ti/k3-udma-private.c
+++ b/drivers/dma/ti/k3-udma-private.c
@@ -40,9 +40,9 @@ struct udma_dev *of_xudma_dev_get(struct
 	}
 
 	ud = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!ud) {
 		pr_debug("UDMA has not been probed\n");
-		put_device(&pdev->dev);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 



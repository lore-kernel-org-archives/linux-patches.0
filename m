Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D1130C358;
	Wed,  3 Dec 2025 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775928; cv=none; b=KrCXfQAk/xP1eJQ9t9oNwDRXnAacR+sucZtUrwqC5Uf2HGIf5k4QvYoFCLpJAq7o+Wtm91m7/eE3/XHMXH9CIiiRFQzvR2MAAAIcisPF/bLHkovXKLkXhuDZHIAiAV28Iv87jxq5QF3HuiUv8TFupXaNNsvWBUO0XAH3EYRLtSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775928; c=relaxed/simple;
	bh=rFbHk1t25LXjZE8L0Ia/o01BOmgC5DiSHSDE09Q9jls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGncNhYs+pFp1MPk5IZlvzNKCeQZ8wpP+u2kfmQA4Vy92clCmRFUOMKde4iJsH8fE9Qai+dEjn6dGLj4D3UkTGPRAqAkwEnJACBooCVtGu6F3JZVMNiWFnCokewdpf1cz5USsARTARGK2VqmNaSvdTppVxl7GUpnTRXgHOnrOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnLZdjPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnLZdjPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B62C4CEF5;
	Wed,  3 Dec 2025 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775928;
	bh=rFbHk1t25LXjZE8L0Ia/o01BOmgC5DiSHSDE09Q9jls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnLZdjPR3/F2dmegVqphJ8Alh7SQBUvPxLnOOgoZ+RuIgKqmfQywdZyTI0DAUZmJN
	 MYSXNt9nFDq4HUCUF5a8p5RyvmSdJFijoRmYWZ5mAj5thffgr6+cZq5XuVhhjoA8E0
	 Lka/a5NbYorLDfRP1B1aIOZGRKWT+iNjbVbXhlHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 007/300] fbdev: atyfb: Check if pll_ops->init_pll failed
Date: Wed,  3 Dec 2025 16:23:31 +0100
Message-ID: <20251203152400.731769836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Daniel Palmer <daniel@0x0f.com>

commit 7073c7fc8d8ba47194e5fc58fcafc0efe7586e9b upstream.

Actually check the return value from pll_ops->init_pll()
as it can return an error.

If the card's BIOS didn't run because it's not the primary VGA card
the fact that the xclk source is unsupported is printed as shown
below but the driver continues on regardless and on my machine causes
a hard lock up.

[   61.470088] atyfb 0000:03:05.0: enabling device (0080 -> 0083)
[   61.476191] atyfb: using auxiliary register aperture
[   61.481239] atyfb: 3D RAGE XL (Mach64 GR, PCI-33) [0x4752 rev 0x27]
[   61.487569] atyfb: 512K SGRAM (1:1), 14.31818 MHz XTAL, 230 MHz PLL, 83 Mhz MCLK, 63 MHz XCLK
[   61.496112] atyfb: Unsupported xclk source:  5.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/aty/atyfb_base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/aty/atyfb_base.c
+++ b/drivers/video/fbdev/aty/atyfb_base.c
@@ -2606,8 +2606,12 @@ static int aty_init(struct fb_info *info
 		pr_cont("\n");
 	}
 #endif
-	if (par->pll_ops->init_pll)
-		par->pll_ops->init_pll(info, &par->pll);
+	if (par->pll_ops->init_pll) {
+		ret = par->pll_ops->init_pll(info, &par->pll);
+		if (ret)
+			return ret;
+	}
+
 	if (par->pll_ops->resume_pll)
 		par->pll_ops->resume_pll(info, &par->pll);
 



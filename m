Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E48D346E57;
	Fri, 21 Nov 2025 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732157; cv=none; b=hiDF0pGIu+BETIRExWQekYrO/QwjFnGkatoFY1dwK2WglLKYeu0pa/3Yee1QCmgyE5SnHF4nTM5IAtI1y+yqQ0Uq7DgQYcvWCS2GgacgzdUSsXnnpkWemHB9j1w8GAXyHF14Nf69GktWJtaAVe2XyiGsdrtsH+X/9V9//2vYJwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732157; c=relaxed/simple;
	bh=tnhQWB89v9bc7UydmdJH0SzKNLxeeTdXajm0Y9CHgkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muBCk+A0kUEQxE+jsqqrM+0o6LilqWSKTFBQLYjWApxX4mHDByqOLn1AzdzThAUleeesJdeQEl7ZVh1E1iGjQ8xZWmdxrb1MkkxlBo5OhS+29/tHiLAPkti7Q2KhCASoHp5sESYG5auDhlN9acPAar3fUlGBfoi63pFL/kDACSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6orRFv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6orRFv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA82C4CEF1;
	Fri, 21 Nov 2025 13:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732157;
	bh=tnhQWB89v9bc7UydmdJH0SzKNLxeeTdXajm0Y9CHgkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6orRFv62fv5tVln8lOuSbh5bQAbEem3DVtb57krEcJZgjiWv3Ek3PjB7COLg7pM4
	 va80aUhiXJPhF2jYdF90uV/4t+MTYjW9Azl3gQ+pjiwnC9SSfButfbdiDR8qjJFXWg
	 AVqpVvzXMUyFZY3W5tTJTGPZpCvlO+XA5JXtjOKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 004/529] fbdev: atyfb: Check if pll_ops->init_pll failed
Date: Fri, 21 Nov 2025 14:05:03 +0100
Message-ID: <20251121130231.151422368@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
@@ -2611,8 +2611,12 @@ static int aty_init(struct fb_info *info
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
 



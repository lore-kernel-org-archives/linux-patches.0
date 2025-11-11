Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A873451;
	Tue, 11 Nov 2025 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822136; cv=none; b=C3TV1pw6NjRe3F/wTai5/hFdjPpz9Xqv7zS685AT0B5CRI/Z3WtnL77sdTNNZ47dqmjlDrRuvgFb4leCC1G/L93HP2S16jFC9bIK+ClnnI91ssm//eH/uBWo3p/F4eGOZntIoGydy2xwiff9sAUMtP4MjfzqgCFMOXWyiTYQYuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822136; c=relaxed/simple;
	bh=AoO+HG5Hmf6AqFp1mY8x3ZJ4aG23z2iUMiu9EU644zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0yjyqRnYxdZiB3aAgHbAHS5q5knl8CJD5JBffbjRyqU56mVg31rv3OcD/dJSLD7W/gRHwsv59eoeJzqVclXntAUYxQj+n3AS3G3Qy0Sj41PhGnbG7/j+LqhfZ9QbjRj4VyoOQwIiyjERRCyEC4aLfOnRN69n9RZyPaMTD2YUsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxA0giw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxA0giw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E412C116B1;
	Tue, 11 Nov 2025 00:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822135;
	bh=AoO+HG5Hmf6AqFp1mY8x3ZJ4aG23z2iUMiu9EU644zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxA0giw9Ma+QaJRLkuEyztbymHmSuwI4GSD1Fyqyl0BHB5S7ipt3hWVoJqCU9+Azk
	 8Q9IgCiAbuVUPiTuzkAcXRa3CYZTwnYhOlDbMfO1ajoc63hzOKP4k+DUbht0n2InaD
	 Gk4p3oJO9pO6CAg4GAJfwgXZL1L+ZK6HYHzR3QNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.17 008/849] fbdev: atyfb: Check if pll_ops->init_pll failed
Date: Tue, 11 Nov 2025 09:32:58 +0900
Message-ID: <20251111004536.663947498@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2614,8 +2614,12 @@ static int aty_init(struct fb_info *info
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
 



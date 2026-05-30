Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AD3331200;
	Sat, 30 May 2026 18:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166297; cv=none; b=oQ0Gdz7BWMD2I/n6kVls9IDAcEVuS3qBpGWXGtS1iY3e1mT1h1OBiI2eI9orlEZ5ET9N3Gu2sjpxYE8ZX/wMBQGInc+J7IW4p3dPNFJztfa60u06Gl3Y3WiAKAKIaxm2WmwKwDv0Bmmrgv+lf0/h7rdbzIRcEKQ13kxqFDaKIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166297; c=relaxed/simple;
	bh=bycomV14JRSeiIjZf577Pm8DV2W4lFsNUYZdULq0FPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAAsR+d5NAr1EJe31M/vEfIuyAGmXdgRP+MTOSy6sCuOthjdG5Z6/3XDbvV2BwXmzyhF/JZj8W2W4zzEhHEMnnEXFWJIycSNvTnBTH0OZTnG1uMAVyYC4qKeRJyUy6NBVVN1eIp2Z9m0c3hbkZ22AgRz7wOmvsIsaiBUqKyiwoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTLVNDVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTLVNDVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD94F1F00893;
	Sat, 30 May 2026 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166296;
	bh=rwIqFJzq19wvsXUQr4dzak04dxlqbcNxOxFgN2KnA8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTLVNDVr6oocMrvoGxdTP8tBmzkusoB3O56qw0cvM7f9laLsYc0vo/LUCFNyM5QVQ
	 Pcq5Q5m33Ehc7WZ1abEFPu5pwjiH3SrVqduD6q9tS0LT7KKEwtUoMn32T1BbEjfClT
	 uifI73RIxS/oCJiZYDZiNcWSfdJk+4KBPccsah/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jason Yan <yanaijie@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/589] fbdev: matroxfb: Mark variable with __maybe_unused to avoid W=1 build break
Date: Sat, 30 May 2026 18:03:33 +0200
Message-ID: <20260530160233.634487496@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit caf6144053b4e1c815aa56afb54745a176f999df ]

Clang is not happy about set but unused variable:

drivers/video/fbdev/matrox/g450_pll.c:412:18: error: variable 'mnp' set but not used
   412 |         unsigned int mnp;
       |                      ^
1 error generated.

Since the commit 7b987887f97b ("video: fbdev: matroxfb: remove dead code
and set but not used variable") the 'mnp' became unused, but eliminating
that code might have side-effects. The question here is what should we do
with 'mnp'? The easiest way out is just mark it with __maybe_unused which
will shut the compiler up and won't change any possible IO flow. So does
this change.

A dive into the history of the driver:

The problem was revealed when the #if 0 guarded code along with unused
pixel_vco variable was removed. That code was introduced in the original
commit 213d22146d1f ("[PATCH] (1/3) matroxfb for 2.5.3"). And then guarded
in the commit 705e41f82988 ("matroxfb DVI updates: Handle DVI output on
G450/G550. Powerdown unused portions of G450/G550 DAC. Split G450/G550 DAC
from older DAC1064 handling. Modify PLL setting when both CRTCs use same
pixel clocks.").

NOTE: The two commits mentioned above pre-date Git era and available in
history.git repository for archaeological purposes.

Even without that guard the modern compilers may see that the pixel_vco
wasn't ever used and seems a leftover after some debug or review made
25 years ago.

The g450_mnp2vco() doesn't have any IO and as Jason said doesn't seem
to have any side effects either than some unneeded CPU processing during
runtime. I agree that's unlikely that timeout (or heating up the CPU) has
any effect on the HW (GPU/display) functionality.

Fixes: 7b987887f97b ("video: fbdev: matroxfb: remove dead code and set but not used variable")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/matrox/g450_pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/matrox/g450_pll.c b/drivers/video/fbdev/matrox/g450_pll.c
index ff8e321a22cef..b2d3f7328ea83 100644
--- a/drivers/video/fbdev/matrox/g450_pll.c
+++ b/drivers/video/fbdev/matrox/g450_pll.c
@@ -407,7 +407,7 @@ static int __g450_setclk(struct matrox_fb_info *minfo, unsigned int fout,
 		case M_VIDEO_PLL:
 			{
 				u_int8_t tmp;
-				unsigned int mnp;
+				unsigned int mnp __maybe_unused;
 				unsigned long flags;
 				
 				matroxfb_DAC_lock_irqsave(flags);
-- 
2.53.0




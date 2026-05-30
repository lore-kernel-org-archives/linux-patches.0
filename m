Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873303148DA;
	Sat, 30 May 2026 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161145; cv=none; b=dWDD/gFfLXMfZAy3980Sim9ltzz68tIY5kbrzUyl6AtXk63BJ2riSRnMNPWFdpam7Ljo2SUdDfHCHnjhtXVUMJ9OmjoWNDGFAp8aQXu52DzcQJCofwiXYB6fuu8G6r4ThxjevH9qJU4YeVEFOPV/e5zggI25nnGv96b9q7yXz0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161145; c=relaxed/simple;
	bh=pb9394vX1NAEXOEiDzN41z/rGNtPq77ny+733Ccbgzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2oH87IEZAlXx0dDZb61h/QZ8Hb5BkFuhC/7LOSJZkT6t5CWT9+m/b3mvPFoCsLqt8+UORdZ81GMjfNIXPRijXaiNJH3fewhRP9M/vNGYUtn1eaLGJpsJMOYqlbxtIsnmn11wG2tILSV42CyqT02thFkbx1sMSMi83RBX7aqhjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLixAQbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLixAQbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32E31F00893;
	Sat, 30 May 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161144;
	bh=pRqfJ52H2nxtHVg8BS2EpQnNKDinpKo1WQMc7H4htJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLixAQbLQfJ4ns/fJoDfye3zeW0LHXFqUV4V29TnYuf3dkYbQ5QHtaO3FSNPdWdGs
	 JmQq/YgSbKZezEJLeO49upXun+jwRM3QE5r1SedRRlHu3kwbMQc6YkiEqevfIVdJHJ
	 /DWa1JsP42Am/gK2jgOKd3/vwE+Nd3U0FuWwrmbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jason Yan <yanaijie@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 508/969] fbdev: matroxfb: Mark variable with __maybe_unused to avoid W=1 build break
Date: Sat, 30 May 2026 18:00:32 +0200
Message-ID: <20260530160314.359698678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




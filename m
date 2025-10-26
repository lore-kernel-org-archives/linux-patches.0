Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A72609D6;
	Sun, 26 Oct 2025 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490219; cv=none; b=rlVtzsaRWgOh8rCo3qyUISPFgGCuSTd4VA5gochup+X026/f/0HXWTVJmr2P7g9az8MlY+lbOyNgyHKluZHyni5E2MMRN6XX3Y/UyrU32JwBX+q8VBmFdYYSJIC4b3fUAd9oaJ4ZDiU27IlReMKSOp7LQjZQUCfb5mdX03yuUyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490219; c=relaxed/simple;
	bh=KmiJMuNTVluGqoO5cmOrCav6DccbWSUzZwrYyrynEvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aCSix9BpVUN/12kKuhB/dCfaAycfvCtz7+jCG4OPji7oD2/fJOmSXYHWs5JP/tCtv+X73c0LXLBC/tRORtZmulQc/brebkerQq+ee/NeQRPnWD/qUYwuZfKEDCQWrVuNcPTuGMxtzxqBcc8vmHt+4kyCO2aczb4Z62Fg4gNHPwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDa/VjgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDa/VjgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3147C4CEE7;
	Sun, 26 Oct 2025 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490219;
	bh=KmiJMuNTVluGqoO5cmOrCav6DccbWSUzZwrYyrynEvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDa/VjgPmE1YkypMBDdBEefri531Mg7+3znbgvQUv8SHbyTp0/z+55Im8kSIC1geg
	 DNOIKRPg1+ohjTGxlpt5JgDiHzlSMxSf6NDBcT42atvFiqsJfLhK27e1vrf9ZmVJK3
	 N+HQ8Do2ZOz84G8UsaXzotm9X6233aGO7GSGjCWOs1HNH3SZ/xjhgVW3MFBrCRn/Jx
	 wCNEQOT2AgcbpCV025Y0e59Gil51X2x6m9htNREriZZsDRCFTiu6z7p1Uy0JnLGnaF
	 XHb9rq3tG8xWNhjTxUp+7O9+AEEGchOmGpXfq9SlwkxJGE6fyYAfK1sCbmo62hj9wP
	 MM36GSWUDEPzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zsolt Kajtar <soci@c64.rulez.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	simona@ffwll.ch
Subject: [PATCH AUTOSEL 6.17] fbdev: core: Fix ubsan warning in pixel_to_pat
Date: Sun, 26 Oct 2025 10:48:48 -0400
Message-ID: <20251026144958.26750-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zsolt Kajtar <soci@c64.rulez.org>

[ Upstream commit aad1d99beaaf132e2024a52727c24894cdf9474a ]

It could be triggered on 32 bit big endian machines at 32 bpp in the
pattern realignment. In this case just return early as the result is
an identity.

Signed-off-by: Zsolt Kajtar <soci@c64.rulez.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Returning early in the default branch
  (`drivers/video/fbdev/core/fb_fillrect.h:94`) keeps `pixel_to_pat()`
  from reaching the big-endian realignment block at
  `drivers/video/fbdev/core/fb_fillrect.h:97-99`, eliminating the
  undefined `pattern >> bpp` shift that UBSAN reports when `bpp ==
  BITS_PER_LONG` (e.g., 32 bpp on 32-bit BE). The skipped logic was an
  identity operation in that case, so correctness is preserved.
- The old undefined shift was triggered during ordinary rectangle fills
  (`drivers/video/fbdev/core/fb_fillrect.h:266`) on big-endian
  framebuffers, causing sanitizer aborts and risking miscompilation even
  without UBSAN, so this is a real bug fix with direct user impact.
- The change is tightly scoped, has no dependencies, and leaves little-
  endian paths and sub-word `bpp` handling untouched, keeping regression
  risk very low while restoring defined behavior.

Next steps: 1. If feasible, rebuild a BE configuration with UBSAN to
confirm the warning is gone.

 drivers/video/fbdev/core/fb_fillrect.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_fillrect.h b/drivers/video/fbdev/core/fb_fillrect.h
index 66042e534de77..f366670a53af8 100644
--- a/drivers/video/fbdev/core/fb_fillrect.h
+++ b/drivers/video/fbdev/core/fb_fillrect.h
@@ -92,8 +92,7 @@ static unsigned long pixel_to_pat(int bpp, u32 color)
 		pattern = pattern | pattern << bpp;
 		break;
 	default:
-		pattern = color;
-		break;
+		return color;
 	}
 #ifndef __LITTLE_ENDIAN
 	pattern <<= (BITS_PER_LONG % bpp);
-- 
2.51.0


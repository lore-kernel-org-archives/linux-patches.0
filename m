Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B29F1586C9;
	Mon, 29 Jan 2024 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548217; cv=none; b=aKH+jR3IptNdBeza9d4kWekuGGnb+eyE6LggvX7aDhxWZgnuBTg38yyF5yP7jSd/9KlkIDKvvtr3sWozhoahfhT5YiiHgAKTHsdJBB6ut8c8n7iH4tMAXRcj1tfBYWWP1E9DtY8HqgXGSoaVxKHd/dPvBxD+kb7RjVcMpZHbrlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548217; c=relaxed/simple;
	bh=RhosSEDf3+foqyIIVL+yRx3uTZ0KPC9X5ZT9zrAXX5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t4YKd4XyjJRWFZMDuFSm5rM5Djw3joA6Q17XPpDCG1KPNL7K4VtehT/N0VT9KIqzrU9PG5aZB5eulUVDgFkN7cb0bB5/wmvdQ7NYegA4/E859VcCk5LQ2xPXGDnax2gKQ3YIOv8nXEgW3pkdQq9J3mxidN3CooUs891IR6sqHZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoZsMCQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoZsMCQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8ABC43394;
	Mon, 29 Jan 2024 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548216;
	bh=RhosSEDf3+foqyIIVL+yRx3uTZ0KPC9X5ZT9zrAXX5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoZsMCQH8f07bAdwPZPQ1Gcl1opnwD1wkPM+acIpH6aBho4tCAA3Sw9tlaSbrRC9O
	 klHz8p4HhXReIn4bELlH6dh75gSz3fSHjJdnbZ4oS4JMVDtRGI1kgGBaJWou6osfcX
	 9pmfhKy2oNuIz7TqKIJf7gRNX0FSsFkRbAvF9pSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.7 249/346] drm/i915/psr: Only allow PSR in LPSP mode on HSW non-ULT
Date: Mon, 29 Jan 2024 09:04:40 -0800
Message-ID: <20240129170023.742795996@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f9f031dd21a7ce13a13862fa5281d32e1029c70f upstream.

On HSW non-ULT (or at least on Dell Latitude E6540) external displays
start to flicker when we enable PSR on the eDP. We observe a much higher
SR and PC6 residency than should be possible with an external display,
and indeen much higher than what we observe with eDP disabled and
only the external display enabled. Looks like the hardware is somehow
ignoring the fact that the external display is active during PSR.

I wasn't able to redproduce this on my HSW ULT machine, or BDW.
So either there's something specific about this particular laptop
(eg. some unknown firmware thing) or the issue is limited to just
non-ULT HSW systems. All known registers that could affect this
look perfectly reasonable on the affected machine.

As a workaround let's unmask the LPSP event to prevent PSR entry
except while in LPSP mode (only pipe A + eDP active). This
will prevent PSR entry entirely when multiple pipes are active.
The one slight downside is that we now also prevent PSR entry
when driving eDP with pipe B or C, but I think that's a reasonable
tradeoff to avoid having to implement a more complex workaround.

Cc: stable@vger.kernel.org
Fixes: 783d8b80871f ("drm/i915/psr: Re-enable PSR1 on hsw/bdw")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10092
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240118212131.31868-1-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
(cherry picked from commit 94501c3ca6400e463ff6cc0c9cf4a2feb6a9205d)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1401,8 +1401,18 @@ static void intel_psr_enable_source(stru
 	 * can rely on frontbuffer tracking.
 	 */
 	mask = EDP_PSR_DEBUG_MASK_MEMUP |
-	       EDP_PSR_DEBUG_MASK_HPD |
-	       EDP_PSR_DEBUG_MASK_LPSP;
+	       EDP_PSR_DEBUG_MASK_HPD;
+
+	/*
+	 * For some unknown reason on HSW non-ULT (or at least on
+	 * Dell Latitude E6540) external displays start to flicker
+	 * when PSR is enabled on the eDP. SR/PC6 residency is much
+	 * higher than should be possible with an external display.
+	 * As a workaround leave LPSP unmasked to prevent PSR entry
+	 * when external displays are active.
+	 */
+	if (DISPLAY_VER(dev_priv) >= 8 || IS_HASWELL_ULT(dev_priv))
+		mask |= EDP_PSR_DEBUG_MASK_LPSP;
 
 	if (DISPLAY_VER(dev_priv) < 20)
 		mask |= EDP_PSR_DEBUG_MASK_MAX_SLEEP;



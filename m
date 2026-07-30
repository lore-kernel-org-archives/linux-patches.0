Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8020943F0B0;
	Thu, 30 Jul 2026 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422585; cv=none; b=cx17qkDVnVXrAUPPKQ5pgi8IgGzFRG8jvDP9/2Ua6BWYSLTpd2QEdPf+ztw3rk92xckcphJfK22xgEU73ynlJFbY1HEOmI2mpDAWLtXUHn8gr0IaJOzecdMe4DypaBHrj68fCa4aLtQbgRrb2vZwrxZP38+oavTRkTQZNE1Frgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422585; c=relaxed/simple;
	bh=1rWQOEXIWWgh0dFzVf0vpNNDP2Hp67tgS996ydSl+Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLMtVWImuWfHuTGoVkV3qWHGpjqtJq0HM6UjYfMlNZ8/pjxKeoI+xaDGRSwE4H/Ny1MuONEx7UPqYGELrXi/KVRa2wWoIyar89uGBELfl1DV33YMAR0FaZn7A3LCEoG44rhOlv+tjDfS7+UxOsQB0SnzwqXWzIb95sXpfhC3m94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfjSRHIp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfjSRHIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33291F000E9;
	Thu, 30 Jul 2026 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422582;
	bh=nvONbN9w0Q5cP/2CQ5o/vd8/Wo3lwazq2Yh8DhaVt+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfjSRHIpZlyYogkLw5752vTJLDng51i95v9QWZ3HRCUXCWNo+wyDT6dLBCSZYsJmn
	 /hJq0VF51yd0M84AUSfw3aeG2lw586/MZSUJOnM0e0kYpd7rKFdKo+mDci0VoPjMKQ
	 p0GP4uTNVR84TLjazKZnm8tam34la/54Sh3p9IPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nenciarini <mnencia@kcore.it>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.1 487/744] media: intel/ipu6: Improve DWC PHY HSFREQRANGE band selection for overlapping ranges
Date: Thu, 30 Jul 2026 16:12:40 +0200
Message-ID: <20260730141454.646751331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Nenciarini <mnencia@kcore.it>

commit 477620dccf3e9481ed6ae67cb5c747f25751c531 upstream.

The get_hsfreq_by_mbps() function searches the freqranges[] table
backward (from highest to lowest index). Because adjacent frequency
bands overlap, a data rate that falls in the overlap region always
lands on the higher-indexed band.

For data rates up to 1500 Mbps (index 42) every band uses
osc_freq_target 335. Starting at index 43 (1461-1640 Mbps) the
osc_freq_target drops to 208. A sensor running at 1498 Mbps sits in
the overlap between index 42 (1414-1588, osc 335) and index 43
(1461-1640, osc 208). The backward search picks index 43, programming
the lower osc_freq_target of 208 instead of the optimal 335.

This causes DDL lock instability and CSI-2 CRC errors on affected
configurations, such as the OmniVision OV08X40 sensor on Intel Arrow
Lake platforms (Dell Pro Max 16).

Rewrite get_hsfreq_by_mbps() to select the optimal band:

1. Among bands whose min/max range covers the data rate, prefer
   the one with the higher osc_freq_target.
2. If osc_freq_target is equal, prefer the band whose default_mbps
   is closest to the requested rate.

Since the frequency ranges are monotonically increasing, the loop
exits early once min exceeds the requested rate.

For 1498 Mbps this now correctly selects index 42 (osc_freq_target
335, range 1414-1588) instead of index 43 (osc_freq_target 208,
range 1461-1640).

Fixes: 1e7eeb301696 ("media: intel/ipu6: add the CSI2 DPHY implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Marco Nenciarini <mnencia@kcore.it>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-dwc-phy.c |   24 +++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/media/pci/intel/ipu6/ipu6-isys-dwc-phy.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-dwc-phy.c
@@ -288,15 +288,27 @@ static const struct dwc_dphy_freq_range
 
 static u16 get_hsfreq_by_mbps(u32 mbps)
 {
-	unsigned int i = DPHY_FREQ_RANGE_NUM;
+	u16 best = DPHY_FREQ_RANGE_INVALID_INDEX;
+	unsigned int i;
 
-	while (i--) {
-		if (freqranges[i].default_mbps == mbps ||
-		    (mbps >= freqranges[i].min && mbps <= freqranges[i].max))
-			return i;
+	for (i = 0; i < DPHY_FREQ_RANGE_NUM; i++) {
+		if (mbps > freqranges[i].max)
+			continue;
+
+		if (mbps < freqranges[i].min)
+			break;
+
+		if (best == DPHY_FREQ_RANGE_INVALID_INDEX ||
+		    freqranges[i].osc_freq_target >
+		    freqranges[best].osc_freq_target ||
+		    (freqranges[i].osc_freq_target ==
+		     freqranges[best].osc_freq_target &&
+		     abs((int)mbps - (int)freqranges[i].default_mbps) <
+		     abs((int)mbps - (int)freqranges[best].default_mbps)))
+			best = i;
 	}
 
-	return DPHY_FREQ_RANGE_INVALID_INDEX;
+	return best;
 }
 
 static int ipu6_isys_dwc_phy_config(struct ipu6_isys *isys,



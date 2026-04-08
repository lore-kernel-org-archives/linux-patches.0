Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B513D4134;
	Wed,  8 Apr 2026 18:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673671; cv=none; b=mPFHqfN6a+4cihtuFpxaY+IAeMqUJx9wmd3M7DKiSRdUYkz9KwhimVEdWYTVO3dsagsszVcLngql4y0Tys6UZHJUYIDPLeWiJH7iULNvYwppc8+HRtCMLASe3cfchRZxX8xc26jkZbg9x5vYJQUeNLCZruIgnryiA43fDSUlQ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673671; c=relaxed/simple;
	bh=0ySuQ1D1SKHCj1MRsGhvvumZP9BNw4xykSlXuejUBYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duP6d591Uy838gG4foEJtZwkbywcCKtksBn53JIuMJXc9RmnBsAJvmjtgl5kYz7yM1E5aO6dBZi8ayElFjbsEDXkKDvyamuKxFCPVn96yQxBMXB2d02uEPuEvkABiT9yOS7gprIC8toWLiMZ2ItIi7pwPkthYV41dOT9MgoMpSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWn57CzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWn57CzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781F9C19421;
	Wed,  8 Apr 2026 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673670;
	bh=0ySuQ1D1SKHCj1MRsGhvvumZP9BNw4xykSlXuejUBYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWn57CzU2cnzDMPUM2zCvNNEqzwmhn7PqiAZSjW6nKZ0gjctMeDHGHkXdztQiYNBC
	 DyWiOvgQxcld1sO8x9yef2L/R7gt/dNqGnAzvRN2Sq/TXKpyQayNbO6rL7nw6lGGiz
	 2oAZ6K/kJWjhKha9Hc5PlmxlOurJSJ9BESTwXTKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/242] net: fec: fix the PTP periodic output sysfs interface
Date: Wed,  8 Apr 2026 20:01:25 +0200
Message-ID: <20260408175928.758021970@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit e8e44c98f789dee45cfd24ffb9d4936e0606d7c6 ]

When the PPS channel configuration was implemented, the channel
index for the periodic outputs was configured as the hardware
channel number.

The sysfs interface uses a logical channel index, and rejects numbers
greater than `n_per_out` (see period_store() in ptp_sysfs.c).
That property was left at 1, since the driver implements channel
selection, not simultaneous operation of multiple PTP hardware timer
channels.

A second check in fec_ptp_enable() returns -EOPNOTSUPP when the two
channel numbers disagree, making channels 1..3 unusable from sysfs.

Fix by removing this redundant check in the FEC PTP driver.

Fixes: 566c2d83887f ("net: fec: make PPS channel configurable")
Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Link: https://patch.msgid.link/8ec2afe88423c2231f9cf8044d212ce57846670e.1774359059.git.buday.csaba@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 4bb894b5afcb9..778713c2fed40 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -546,9 +546,6 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
 		if (rq->perout.flags)
 			return -EOPNOTSUPP;
 
-		if (rq->perout.index != fep->pps_channel)
-			return -EOPNOTSUPP;
-
 		period.tv_sec = rq->perout.period.sec;
 		period.tv_nsec = rq->perout.period.nsec;
 		period_ns = timespec64_to_ns(&period);
-- 
2.53.0




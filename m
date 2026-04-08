Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8439E3D890F;
	Wed,  8 Apr 2026 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674296; cv=none; b=jaYNyWZfAizavoVMmcqxCbJ+uvbLFhuEt6Onj9cFqnZYqIa0zdZs22HGkQZT1Vq7iIo843Lmp3L2n5ImD0hnj/TKjengMWHSdlveGccgantspBvunmmqOIXIvM91D74NZEdmJQVIyVEiXKHdQ4mpCBfVgpfekBF7rJdISkFHv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674296; c=relaxed/simple;
	bh=R0ouCt6aIhwXChWeQt2eoMhfvzuxZPIZvRr9F80DhIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2zpq/Zf+CsiSMEtDF+E2yz1ROC8Y1YWN4mA2fIbIWhVyjmGY3XxiobLTsdY5+wdXgWcECRleEVz4Npv+Qrpdy9nNZwkw0tbUedjDz4ZcFXqWRfHX3AFDILtSaE7V3CE5981UmYb3RMH2jzV3ZJjPCKZsksQD1lYEKYtSpHKdX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVxr0gzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVxr0gzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACF7C19421;
	Wed,  8 Apr 2026 18:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674296;
	bh=R0ouCt6aIhwXChWeQt2eoMhfvzuxZPIZvRr9F80DhIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVxr0gzD82cpjKpcfcShHJXS3YQ9K/5HkAzKmBTfj+b5z6C6XeHfg8xEQ3fef5AEq
	 iw5NATFmFOnXxy+f+ki0g2PV8aMhm1+cTqkIuuJYgH184sxF6/w2Zoja0jRU/wz/YE
	 V4W9udllkBZDlEmWBjlgBNPjhmJio7Tzv0Z9YVRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 043/311] net: fec: fix the PTP periodic output sysfs interface
Date: Wed,  8 Apr 2026 20:00:43 +0200
Message-ID: <20260408175941.023010697@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4b7bad9a485df..56801c2009d59 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -545,9 +545,6 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
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




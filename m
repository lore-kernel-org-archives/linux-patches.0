Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5780A17BED0;
	Sat, 17 Oct 2026 16:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253874; cv=none; b=oxeEcQv14giTGbjzHnFZm7VOGboZ1LxMx+ju3KAvFlXwZRBZwVBy9qZHiXsokUUN7+oMCEjq0wRS7j0QkstfJ5aPpS9TFUTTI9u4p2hOqbzimT3JfmZ91psXQrUGIj+ctezmw2DsETw6c+VwCKHhv4RXm4Vxi8W9XuCR61U23fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253874; c=relaxed/simple;
	bh=kyxeeK9xgkyqQT6qqw/rvPZYcFqvuG+SBno2LMMeqOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+hZBeFLRc4pNYk/g5AgK724hUwp2K1Bw2vFBUelQKLTdAid+8hy05X/orWBPaZSOZoAIpZ4duNe1DFBU390dQFo/0cwZvi2JibqM/FgacMAXV900c8sH38eIN0ftuXsZcwz3zGBGE8uRKsIHr2X7tzZ5/ibUqLGmDtaEh4x65Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svyk+VhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svyk+VhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5041B1F000C4;
	Sat, 17 Oct 2026 16:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253872;
	bh=8sCE1Dw3OlGY7JhNlPahXTyc03IrUCi3lYOemT4kVag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svyk+VhDoBlfdew0nLul7Z0a3jTPeO9AZ+bKt9nGCYRf81iHTsIstR7Z6tQEwYHx/
	 +eKo1LAe0+VbaTgzlUisX1YovhHyp/YUmqSh9msdRB2Dv8B+4kU8WN+qZOOJ7h28rf
	 T21D2n+Bm2cqnCB8Ao9o3S8bOS/4QwywzMBiCsts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/869] ice: ptp: dont WARN when controlling PF is unavailable
Date: Sat, 17 Oct 2026 17:51:43 +0200
Message-ID: <20261017160043.778616102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit bb3f21edc7056cdf44a7f7bd7ba65af40741838c ]

In VFIO passthrough setups, it is possible to pass through only a PF
which doesn't own the source timer. In that case the PTP controlling PF
(adapter->ctrl_pf) is never initialized in the VM, so ice_get_ctrl_ptp()
returns NULL and triggers WARN_ON() in ice_ptp_setup_pf().

Since this is an expected behavior in that configuration, replace
WARN_ON() with an informational message and return -EOPNOTSUPP.

Fixes: e800654e85b5 ("ice: Use ice_adapter for PTP shared data instead of auxdev")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index ca0d4ba2b63b2..f0dab91ce831e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2936,7 +2936,13 @@ static int ice_ptp_setup_pf(struct ice_pf *pf)
 	struct ice_ptp *ctrl_ptp = ice_get_ctrl_ptp(pf);
 	struct ice_ptp *ptp = &pf->ptp;
 
-	if (WARN_ON(!ctrl_ptp) || ice_get_phy_model(&pf->hw) == ICE_PHY_UNSUP)
+	if (!ctrl_ptp) {
+		dev_info(ice_pf_to_dev(pf),
+			 "PTP unavailable: no controlling PF\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (ice_get_phy_model(&pf->hw) == ICE_PHY_UNSUP)
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&ptp->port.list_node);
-- 
2.53.0




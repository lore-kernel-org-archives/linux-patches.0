Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CC3168C7;
	Tue, 14 May 2024 11:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684827; cv=none; b=bWWRKEGEj+KkBaOB//5P3RTFVYGBOSaSJkeBBfARE9dhVQ2UTfvtRu0MWAZCPhb8TO4orgYPEZSoBDQjos6dIpkM7tj22rHjTLkD5QFGXcQRkBw9CbIdIUtD/YQOTZDhT/JhS8C8QB+E24ie7sAcvylBAIJ7wMf6fGwQOZ2ytxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684827; c=relaxed/simple;
	bh=TGIXemcBBxcVDhaud6NsFTTaI4zxOD99V+hdA4M+luM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI9JsJWo2/vLzIBIbAdZpO8J52BInlh3FUL/bV0lzR5e3JGMOSfdOz3MB906xpqLAFWqJ4zET1zlV2rIfxfseypq1vizT2Ke3TMch0aRyrBruJALdc3vrGAC6vvfFaihl5I5+SwqOwuCGrz69MzN7zjppviLtaGUDPBsaprLpn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iB8/02v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iB8/02v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9DEC2BD10;
	Tue, 14 May 2024 11:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684827;
	bh=TGIXemcBBxcVDhaud6NsFTTaI4zxOD99V+hdA4M+luM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iB8/02vFHdIqHUJG10irTYoWC1GsW0F6jjMpudCr7u6X97Kbnk8UVRFuFrDG8yr9
	 1uk9ug0/T+yZ8tHFtRz1D/77VoeVH6i8vHV6hFSdMRDDsNRI5SQBTdFublBjPlhHky
	 nNoXFJOVo5gHAOY8O4BQGZ6ewGdNva/CbZ4pPIXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/301] vxlan: Add missing VNI filter counter update in arp_reduce().
Date: Tue, 14 May 2024 12:15:35 +0200
Message-ID: <20240514101034.659785440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit b22ea4ef4c3438817fcb604255b55b0058ed8c64 ]

VXLAN stores per-VNI statistics using vxlan_vnifilter_count().
These statistics were not updated when arp_reduce() failed its
pskb_may_pull() call.

Use vxlan_vnifilter_count() to update the VNI counter when that
happens.

Fixes: 4095e0e1328a ("drivers: vxlan: vnifilter: per vni stats")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 3d3c11e61f9de..7e5e60318045a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1838,6 +1838,8 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 
 	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
 		dev_core_stats_tx_dropped_inc(dev);
+		vxlan_vnifilter_count(vxlan, vni, NULL,
+				      VXLAN_VNI_STATS_TX_DROPS, 0);
 		goto out;
 	}
 	parp = arp_hdr(skb);
-- 
2.43.0




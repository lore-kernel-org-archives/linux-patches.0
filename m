Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004CE23767;
	Tue, 14 May 2024 10:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682445; cv=none; b=O3QiSrrkavpMvRNjDaMK6Vst4KN5ZfPWuGjZ0HJ103C87fI7J8VCyXDqaoz4R9l+svsHyyUFtF55ABB2kJazrG5+mVgetzesRNku7KShozsYt3awp64ePDmh8j0tYhTh41rauFhzXNQJDyKUPQUysr00j9NfLHL5TaXwXNvHWmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682445; c=relaxed/simple;
	bh=VdnksoazOloxS0Wiq2B1yO6Asax/HWOXQh+GI0malb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0fKw0qOWvE3Od8Iuob7jyATjn75saryx88e945SQLBziiWJUGX4acllLJacdPRofO9D47sNJiKH15TSlx82f0LbgmtPrMx6MyIJCVHZ1MjoPiXPyRqF59q0ItgUp5jOeKPKvHBHIrz6BcSucSVYCNW9Ch9c7CqbOnyGmj7yaeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZEcdwM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZEcdwM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC94C32782;
	Tue, 14 May 2024 10:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682444;
	bh=VdnksoazOloxS0Wiq2B1yO6Asax/HWOXQh+GI0malb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZEcdwM/RVDhQqrT6NK7FUpDp40lXprorxYpe9a+Wx3kozXttR2Rf2GiA96zC0RzM
	 O34a9QKySI0PJk2eLVyY8cMyS0ixQcMHLqmnB64Kh4JZHSgOWecOVpdYY5/qRMELye
	 OKMIoBp/3dXo4FVPrAG/n29IYlJKuhb+dcwWSOGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 062/336] vxlan: Add missing VNI filter counter update in arp_reduce().
Date: Tue, 14 May 2024 12:14:26 +0200
Message-ID: <20240514101040.946991217@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index afca4f42c31b4..743fcde565b2f 100644
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




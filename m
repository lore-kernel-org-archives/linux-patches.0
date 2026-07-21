Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEF046DFE3;
	Tue, 21 Jul 2026 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656701; cv=none; b=Fkf9V6kHtn70JjsBq0CKcRSf3S/NeohiG6HWB2F7Mt41gv3XT/pnQwq9g2KdA5TLZtu2YhWz4oYhHF/2jQmzjnw/Ra3GtgHq5l04CMAEofi8ndzFUJ5gsiPTQLxCOssctSVwaDw/OsDx5MPmRrVTN/XTkkPWbXbpVz7/biJm5Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656701; c=relaxed/simple;
	bh=NH6UsCC+6cKx37aonPXloI3nVDNZkQI6vcki5akW0Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5Wj+wSnfSjH1OwZ2Rn9TZ719k+XPt5IK0fXtbf8oViDEl8WcM53lB+cG264nQzM9prdW+eQYIwkzklbAd7SxWh1F+SFPsyfY8YlIDvd+vIZOizoKfTG/r/CBPzjNBLkHeNwQISLxB9T5OIkK9ducN4QsjUa//sgqsNzJ/trvBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcm/un6Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcm/un6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC561F000E9;
	Tue, 21 Jul 2026 17:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656700;
	bh=yfJbMwEhglUZk72Z+5W6NKFl+/iVX+GoId6dGiyjwqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcm/un6Yfr1OKfxMvXRqjOSwDsmLB4eGJFlAnvA61RIcnMdRuIoyh3xOEoGHg/2Dp
	 fxboDLV3uuN+YOQ6JwkQZ0zCUEBLJOvyBkTQUbgTibvB/ZwgqDtLnsNF/3xXTDbCuf
	 eEl28ReOglXRJrMEjIFWkjxofBMO7dsU5HQi2YuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0486/1611] net: pfcp: allocate per-cpu tstats for PFCP netdevs
Date: Tue, 21 Jul 2026 17:10:02 +0200
Message-ID: <20260721152526.266757556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit 24041543da8cd84eb5d8ae738c534372fff54820 ]

PFCP uses dev_get_tstats64() as its ndo_get_stats64 callback, but
pfcp_link_setup() does not request NETDEV_PCPU_STAT_TSTATS.  The net
core therefore leaves dev->tstats NULL for PFCP devices.

Creating a PFCP rtnetlink device can immediately ask the new netdev for
stats while building the RTM_NEWLINK notification.  That reaches
dev_get_tstats64() and dereferences the NULL dev->tstats pointer.

Set pcpu_stat_type to NETDEV_PCPU_STAT_TSTATS during PFCP link setup so
the net core allocates the storage expected by dev_get_tstats64().

Fixes: 76c8764ef36a ("pfcp: add PFCP module")
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20260609232244.1602027.c569f6c530f6.pfcp-missing-tstats-link-create-oops@trailofbits.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pfcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/pfcp.c b/drivers/net/pfcp.c
index 28e6bc4a1f14c8..a6aa30ae0af762 100644
--- a/drivers/net/pfcp.c
+++ b/drivers/net/pfcp.c
@@ -148,6 +148,7 @@ static void pfcp_link_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
 	dev->priv_flags |= IFF_NO_QUEUE;
 
+	dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
 	netif_keep_dst(dev);
 }
 
-- 
2.53.0




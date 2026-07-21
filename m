Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3D946C4DD;
	Tue, 21 Jul 2026 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659737; cv=none; b=cUPoW0+VPi68CuZJBrHIAVYGTXB7vXYUhv11Im/He4G43C20zRaveSZF+843tflYaZpaAQHiHcKZyc4J9bzP7kZQkGfcXXdorFhiY6h1K41YwQflsn6HDVc4ueiq2xHYBRtC4UjQUoi3gi4WrcOt2wz7Arfn8+bmewWz+LFJdDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659737; c=relaxed/simple;
	bh=zfWGBqZuQHhYMsCanXxgjtdZuvRI/u8BaYHgVu2taC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsBkg0I/oOMIS994V/dzxuJ+5qfocQED1kaKoMGQQuymE1d9tuGunp15njmyuvAFLsUi56kGzFeqdT5Q0HF5NwYFke5CRLWAYWuR49UYc5Njq8CgpK5wBuk/6ctoyKG0O+z8cq+ANRxRv3Z//OsUUGzjPPqRIYOWEZNqG4+nflQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khyoWeVb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khyoWeVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C991F000E9;
	Tue, 21 Jul 2026 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659735;
	bh=Hua7TwHMdY/noBnYTYY4BM5ZhiLBmLU2alhDSQqCutI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khyoWeVbgSwjwemdI/neOWYu37dEzHquNgvUWP8VodPQuBnFH32O2cZHQgSbgNmp+
	 nyFboV63Vcm5Mz9znxvKsiDSXupt5+NPPsCYpfTTalhQH3Y1nIyv+e6UWR9MIRIsVS
	 BV6uMlVJHcB1HdnnD75gT9oUvCIEoWRghu1lrePo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0714/2077] net: pfcp: allocate per-cpu tstats for PFCP netdevs
Date: Tue, 21 Jul 2026 17:06:27 +0200
Message-ID: <20260721152609.640024669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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




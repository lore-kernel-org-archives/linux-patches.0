Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC1146EF61;
	Tue, 21 Jul 2026 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662152; cv=none; b=nmNkQZvwUP/zCMc9haLrhgJDGfsdpkPC2uhdj85MwJ3YiqaMWxAXEdqZHxrKrGlo6my7xXg+VY9rROfsyyQVXX4H+sKHGBbtML7GVD8gEY8/a3HQxZVe3oCTjYw1R/tqox2S+l0s/sQGBcBMtTPQLhxrdyfeVpb9rrMQzJukWSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662152; c=relaxed/simple;
	bh=VeKnXqYLqGfJJadBlOoReyk1Gdrr4xs655dE7kymNVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/qno+kFe6Qn9zySJYcH0h4n2WcytRYOx8btrWZeTK1iQcqth/DAZpV0dT2qA7lxc4YojNt0ElXi7PFQK5a+8j9gxRJ4RtS0OOGrsSvy0q9A59pw2CZ12LbKf9AoPOwuMpaTMWxlT+XPALtTmB35e0mN178OIyLcCf9tYblWgd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D19M6ELO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D19M6ELO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530DF1F000E9;
	Tue, 21 Jul 2026 19:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662150;
	bh=FU5yaZEmQG8u4DFaIc2Qvu+6LaTEhWZSkOQzq4aeGww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D19M6ELOhFCsKG1ulQbU3VKb+2tgtTsO8BGMiAhQPfRWYglHmBzju974s9pS+LTy6
	 slES1EKv4hSW3Da0Ov/dXbOucQLo3YT5gtG//CWaUPL+/DdCsHPH0sWfxYnLwpICd/
	 u7fsAjaAeK8hTGTW4FbJztJoo395HC4gIQMU4pgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0337/1276] net: pfcp: allocate per-cpu tstats for PFCP netdevs
Date: Tue, 21 Jul 2026 17:13:00 +0200
Message-ID: <20260721152453.644551950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 68d0d9e92a2209..b07517d4fe2dbb 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD6550B433;
	Wed, 30 Sep 2026 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784368; cv=none; b=fligY9owuM8sLpgSHJgqrQV+QQFNdcjI2usDPuPyggNBRW467gP7lTPgqFqELl40ocaeo50jA8Ousrg43j8M/Ma8Ve2hVOezVOW6eUCExmCErA9YiJTzZ6xeRu/NMTdayGleashoZopqA4zwusANg5vQ6ElwhZjmBti93aUcw3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784368; c=relaxed/simple;
	bh=EctSn9sOQRk3DbGip+dlsPNgfu/29rKJklDKA/tMyEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7pZ9bs4t0V38HOXHACCUs3IvFKx81LsdrLuEFDh42q7yHKUI/oFaJTBlpfVHq2mmQXWiFz9p5KbSRWAP45JnWe+1yQho7n0N4m7hnqRyGk0D43qU74m2NVkece5wsDZY8C7fmvcGUSxVSXxhHg2b2xEdk7tS8dUD/vl4145OOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyWf+iUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyWf+iUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE7E1F000FF;
	Wed, 30 Sep 2026 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784363;
	bh=LMex0jvs6SsVBnE/PGAOZzzuLWeDvv6se107v2OZWEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyWf+iUUHTPfIpzpsJRQoT5eO40cW7/+VeaEX+N2jGqaUwrGXq8rMzF+2W+2Ca/zI
	 J2c8W+Fs3hX8azNcO2RX2fLdpSAXwMF+P3bdIjXJ8JkplnX0TBtEFmNnEQ9d+FpzOM
	 hkbyncGMOvKra0RqJl25ydVKdBQ4aDowCARD4RfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/982] net: ibm: emac: Reserve VLAN header in MJS limit
Date: Wed, 30 Sep 2026 17:14:26 +0200
Message-ID: <20260930152419.607102058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0906c117f81c2ae6e6dbfa82719f79c75e1c9325 ]

The IBM EMAC programs its Maximum Jumbo Size (MJS) drop
threshold from ndev->mtu directly. The hardware sizes the threshold
against the L2 frame minus the ethernet header, but does not
discount the 802.1Q tag, so a frame carrying a VLAN tag and a full
1500-byte payload exceeds MJS by exactly 4 bytes and is dropped.

This is normally hidden because JPSM (and therefore the MJS check)
only engages when the MTU is raised above ETH_DATA_LEN.  With the
qca8k DSA tagger the conduit MTU is bumped by QCA_HDR_LEN to 1502
during dsa_conduit_setup(), which is enough to enable JPSM and
expose the off-by-VLAN-tag in the limit.

Pad MJS by VLAN_HLEN so a VLAN-tagged full-MTU frame passes.

Reported on Meraki MX60 (qca8k switch): tagged VLAN
traffic drops at 1500-byte payload, while 1496 bytes works
and untagged 1500 bytes works.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260526202247.13823-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 9b08e41ccc294..d78a5a9e79b55 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -30,6 +30,7 @@
 #include <linux/skbuff.h>
 #include <linux/crc32.h>
 #include <linux/ethtool.h>
+#include <linux/if_vlan.h>
 #include <linux/mii.h>
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
@@ -465,7 +466,7 @@ static inline u32 emac_iff2rmr(struct net_device *ndev)
 
 	if (emac_has_feature(dev, EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE)) {
 		r &= ~EMAC4_RMR_MJS_MASK;
-		r |= EMAC4_RMR_MJS(ndev->mtu);
+		r |= EMAC4_RMR_MJS(ndev->mtu + VLAN_HLEN);
 	}
 
 	return r;
-- 
2.53.0




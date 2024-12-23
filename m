Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0178827;
	Mon, 23 Dec 2024 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970638; cv=none; b=JKJetIaIXqWekwObGRf0gNOuLndImzS0LwqJ1RT/C3itovspxQN8NuLyOjx2pzd9hLbXIP09/ms4PPMqBQkDjK08zvsQtmCh25tRnje1QrOm2aIposF7s1qJCY7NGXGuKStrgdYpQxVKGGvKv5MqWw+Iq5IMYeRzCpPXRn6NGT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970638; c=relaxed/simple;
	bh=HZdZDargUMDSEx/YmqmlqccaHDoo6H+16sba+BLZqAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ng8HgT7FpU8wWkgNPe75rGDKbkCxtqtwnDA6AYnzeHlO5rYNfeTfibv+s+1oQy2evKHkMi3cnf3Oge4RlgJ7Ek3io/bN1XiyogByLR0288s9Lyqzux8TkooixskKN1LTaP4aP+/2IhoeI+rrj5LOzswP4Qh+1+pVl90+cenbRAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3rMkQ6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3rMkQ6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE2FC4CED4;
	Mon, 23 Dec 2024 16:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970638;
	bh=HZdZDargUMDSEx/YmqmlqccaHDoo6H+16sba+BLZqAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3rMkQ6jNQPVvCgNjle79RLWSbJv2egeFHxO+35TuDFm7w2DAr0AHmN2FS001MYO8
	 +QbAlDISSkDY7Zv+j5tDU45pOpRswcI9N3gH971z/Q6SUIcTZ5kIKHXzizMd/WbEPn
	 Ee1fIg2u1z7xoAJ5RMo49Fl6KGXPoe7vqSMnylgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/83] net: mscc: ocelot: fix incorrect IFH SRC_PORT field in ocelot_ifh_set_basic()
Date: Mon, 23 Dec 2024 16:59:03 +0100
Message-ID: <20241223155354.570553334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 2d5df3a680ffdaf606baa10636bdb1daf757832e ]

Packets injected by the CPU should have a SRC_PORT field equal to the
CPU port module index in the Analyzer block (ocelot->num_phys_ports).

The blamed commit copied the ocelot_ifh_set_basic() call incorrectly
from ocelot_xmit_common() in net/dsa/tag_ocelot.c. Instead of calling
with "x", it calls with BIT_ULL(x), but the field is not a port mask,
but rather a single port index.

[ side note: this is the technical debt of code duplication :( ]

The error used to be silent and doesn't appear to have other
user-visible manifestations, but with new changes in the packing
library, it now fails loudly as follows:

------------[ cut here ]------------
Cannot store 0x40 inside bits 46-43 - will truncate
sja1105 spi2.0: xmit timed out
WARNING: CPU: 1 PID: 102 at lib/packing.c:98 __pack+0x90/0x198
sja1105 spi2.0: timed out polling for tstamp
CPU: 1 UID: 0 PID: 102 Comm: felix_xmit
Tainted: G        W        N 6.13.0-rc1-00372-gf706b85d972d-dirty #2605
Call trace:
 __pack+0x90/0x198 (P)
 __pack+0x90/0x198 (L)
 packing+0x78/0x98
 ocelot_ifh_set_basic+0x260/0x368
 ocelot_port_inject_frame+0xa8/0x250
 felix_port_deferred_xmit+0x14c/0x258
 kthread_worker_fn+0x134/0x350
 kthread+0x114/0x138

The code path pertains to the ocelot switchdev driver and to the felix
secondary DSA tag protocol, ocelot-8021q. Here seen with ocelot-8021q.

The messenger (packing) is not really to blame, so fix the original
commit instead.

Fixes: e1b9e80236c5 ("net: mscc: ocelot: fix QoS class for injected packets with "ocelot-8021q"")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241212165546.879567-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 310a36356f56..71dbdac38020 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1161,7 +1161,7 @@ void ocelot_ifh_set_basic(void *ifh, struct ocelot *ocelot, int port,
 
 	memset(ifh, 0, OCELOT_TAG_LEN);
 	ocelot_ifh_set_bypass(ifh, 1);
-	ocelot_ifh_set_src(ifh, BIT_ULL(ocelot->num_phys_ports));
+	ocelot_ifh_set_src(ifh, ocelot->num_phys_ports);
 	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
 	ocelot_ifh_set_qos_class(ifh, qos_class);
 	ocelot_ifh_set_tag_type(ifh, tag_type);
-- 
2.39.5




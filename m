Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F179A80C02;
	Mon, 23 Dec 2024 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969727; cv=none; b=bdVdQ3OLuLHscW6/nb3ruY3e4fP7OytqwcbHx6ouin5pSPJQunXdJK2Dl2F8KU7VhjXfJClyNtggSThhUAZ7klYEr3DL4228YY11Qqqu0WmCK9ujJTW8CVfcmlVIXdYgZ27szsugOjFb9cFB9E4J2G9MDeAMZk0MeP0E9Qdls7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969727; c=relaxed/simple;
	bh=Gk86rJVhsQfqj2RhD/tk00I/kQAzg8KLjHMUWpsQlEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1eQz79PkIrdp86Y+GWUTX1C1rn5klbvWQlvP0ZMhF4OJ0hCEqAzFvU6fETe8oRBEJxEj7UlVL4N2BfZRVN8TUKP0fcsLBBjeK6ILAQhucnKDUfTrDs+rDaTmEFgFm3hOXWRIPanTNz1uvx6S/lT8fhl7cIKeWYs/fTE8cjeXfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HfpDPduI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HfpDPduI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57419C4CED3;
	Mon, 23 Dec 2024 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969726;
	bh=Gk86rJVhsQfqj2RhD/tk00I/kQAzg8KLjHMUWpsQlEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfpDPduI3RfZ1zs5UV15/Z/ghWgQhesCPbHEwH0/BeNBY6ZR63CiISqF1KqRpolMm
	 4RaXQtAOtDgszE0XwtWCOZewKrGAAg0nu6pCbK0v1s3whZOQH6lEt8L/vG6rHbInoY
	 tU740qGo9LT1IkzaRlmISvTsQf+TVPDK8zKu6yog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/160] net: mscc: ocelot: fix incorrect IFH SRC_PORT field in ocelot_ifh_set_basic()
Date: Mon, 23 Dec 2024 16:57:28 +0100
Message-ID: <20241223155410.111130806@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3d72aa7b1305..ef93df520887 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1432,7 +1432,7 @@ void ocelot_ifh_set_basic(void *ifh, struct ocelot *ocelot, int port,
 
 	memset(ifh, 0, OCELOT_TAG_LEN);
 	ocelot_ifh_set_bypass(ifh, 1);
-	ocelot_ifh_set_src(ifh, BIT_ULL(ocelot->num_phys_ports));
+	ocelot_ifh_set_src(ifh, ocelot->num_phys_ports);
 	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
 	ocelot_ifh_set_qos_class(ifh, qos_class);
 	ocelot_ifh_set_tag_type(ifh, tag_type);
-- 
2.39.5




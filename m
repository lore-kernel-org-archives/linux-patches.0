Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8438413C90B;
	Tue, 25 Jun 2024 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308421; cv=none; b=GfslPiyC5QySH+Xae290zZ5lFgJXDy9H+u8ZNCvuV6dkg9ucC23ykFeB+kei0T0Nje31eHAjnzMXBBqWGJEX3N5gPYgW5QSRnRWCO5VR2xohPMcAcfPv1ctkc4ADq1S/r0uNfVElH5NAxkXgnsDT2TamVkcZqkHllSeCj1KrViI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308421; c=relaxed/simple;
	bh=TupzBAfHt+HvBBWlLFfpQxtB746O7ilyUGqTM0LLiK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7kMiVzA/sQCejr5FdgoXbQpfe3jsh6HsWLkP6E4CwCICxm1xjFOptilzYJ7qNHdsSGUmVtZi58NrTCRcQOUGKvvW+WMaQPOs1HydlxOBDWm/K55+j02vyDD9EK4o4BtPbhi53WGkSowDcigkkbPNVAtC1av5t1tNn42KaAGc9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvFin+AY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvFin+AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00897C32781;
	Tue, 25 Jun 2024 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308421;
	bh=TupzBAfHt+HvBBWlLFfpQxtB746O7ilyUGqTM0LLiK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvFin+AY/ErwrHoHz20VYX7vc/UUITVR/ejzSrUMcZo/ZcUQ0M8X5hvPT/JfBA5/q
	 b6Gi2HHYAaRgJw2z42MOtgUA6iUpijzBySVs3FuL6oWbSBuAfKxHXd0XRyDxjpovkT
	 AjUigHp7laNjTJd1N/v+8bXmAv7hZySeMvas0exM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amritha Nambiar <amritha.nambiar@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 115/250] netdev-genl: fix error codes when outputting XDP features
Date: Tue, 25 Jun 2024 11:31:13 +0200
Message-ID: <20240625085552.485144791@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7ed352d34f1a09a7659c53de07785115587499fe ]

-EINVAL will interrupt the dump. The correct error to return
if we have more data to dump is -EMSGSIZE.

Discovered by doing:

  for i in `seq 80`; do ip link add type veth; done
  ./cli.py --dbg-small-recv 5300 --spec netdev.yaml --dump dev-get >> /dev/null
  [...]
     nl_len = 64 (48) nl_flags = 0x0 nl_type = 19
     nl_len = 20 (4) nl_flags = 0x2 nl_type = 3
  	error: -22

Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")
Reviewed-by: Amritha Nambiar <amritha.nambiar@intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240613213044.3675745-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 7004b3399c2b0..8c2d5a0bc208e 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -59,22 +59,22 @@ XDP_METADATA_KFUNC_xxx
 	    nla_put_u64_64bit(rsp, NETDEV_A_DEV_XDP_RX_METADATA_FEATURES,
 			      xdp_rx_meta, NETDEV_A_DEV_PAD) ||
 	    nla_put_u64_64bit(rsp, NETDEV_A_DEV_XSK_FEATURES,
-			      xsk_features, NETDEV_A_DEV_PAD)) {
-		genlmsg_cancel(rsp, hdr);
-		return -EINVAL;
-	}
+			      xsk_features, NETDEV_A_DEV_PAD))
+		goto err_cancel_msg;
 
 	if (netdev->xdp_features & NETDEV_XDP_ACT_XSK_ZEROCOPY) {
 		if (nla_put_u32(rsp, NETDEV_A_DEV_XDP_ZC_MAX_SEGS,
-				netdev->xdp_zc_max_segs)) {
-			genlmsg_cancel(rsp, hdr);
-			return -EINVAL;
-		}
+				netdev->xdp_zc_max_segs))
+			goto err_cancel_msg;
 	}
 
 	genlmsg_end(rsp, hdr);
 
 	return 0;
+
+err_cancel_msg:
+	genlmsg_cancel(rsp, hdr);
+	return -EMSGSIZE;
 }
 
 static void
-- 
2.43.0




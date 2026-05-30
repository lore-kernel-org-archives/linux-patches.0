Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F417825B08A;
	Sat, 30 May 2026 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166634; cv=none; b=ji+j8MYM/d8DSENAqNtP5M7Y4GzoCjYuIO6V+yG+uytL4s3nMHrhB/A2MGEE+I//OJEMYWf6k3sKdX/0deQ9OERujT5+WxImJ/3H2XOwnpAeSp6Gb4tevdPO6vbPPfjnW6h0C5q/hxcDq6YCyXmOBnE+btc2LHPtkMEXGqeO0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166634; c=relaxed/simple;
	bh=n/qzWarChJXi0Xnt/NPPpHF6LCIzGUB2HElIbg6SSck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7BKea4sAEM6yiJ6eqi5fVo3Mj/R+TnBI80cMG6ha/nrGW6oaQUPRyiy/wQTQKdX9dzGEW3iZEL48AJSUPlkSpmPBtnOeAQgiKdvMRV4hfwByMOcZKfnaWGOpj8DOIr2f+8a1YrE5WeMdeTBGD8bWysl1XvQl7pb3DxIGjbi8lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5z9uEz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5z9uEz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3CD1F00893;
	Sat, 30 May 2026 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166633;
	bh=K4qWCZ7jbdGy6TjhULLb8rrv04DNQqlxofWDGSddas8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5z9uEz7HUS/wbgTg46USJSq1YrxlGPen7Yyc7GzXiyldhsYlkaj+y9jOGvU7IP+H
	 E4QFQuVxcq1pUC01abWMpGL1tXHinupygy1epj5dkqaBuVPFPE/vVlnBHXvAyOKapG
	 IEZ172MtGLKrAU8G7sQzJLuKk02gCWomGrOwQKf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 424/589] i40e: dont advertise IFF_SUPP_NOFCS
Date: Sat, 30 May 2026 18:05:05 +0200
Message-ID: <20260530160235.872968238@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit a24162f18825684ad04e3a5d0531f8a50d679347 ]

i40e advertises IFF_SUPP_NOFCS, allowing users to use the SO_NOFCS
socket option. However, this option is silently ignored, as the driver
does not check skb->no_fcs, and always enables FCS insertion offload.

Fix this by removing the advertisement of IFF_SUPP_NOFCS.

This behavior can be reproduced with a simple AF_PACKET socket:

  import socket
  s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
  s.setsockopt(socket.SOL_SOCKET, 43, 1) # SO_NOFCS
  s.bind(("eth0", 0))
  s.send(b'\xff' * 64)

Previously, send() succeeds but the driver ignores SO_NOFCS.
With this change, send() fails with -EPROTONOSUPPORT, as expected.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-9-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3d3816de72ec8..56bbaefbcbb7a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13192,7 +13192,6 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->neigh_priv_len = sizeof(u32) * 4;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
-	netdev->priv_flags |= IFF_SUPP_NOFCS;
 	/* Setup netdev TC information */
 	i40e_vsi_config_netdev_tc(vsi, vsi->tc_config.enabled_tc);
 
-- 
2.53.0




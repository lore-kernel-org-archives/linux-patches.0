Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31F325F7B9;
	Thu, 28 May 2026 20:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000288; cv=none; b=jg9FzHVHedb/dcmg01FPUJYfMOk9QO93WjWSIwfYiH8FfWfScDfdIGIfq94MhJdio0Bp2781XpYoOaOfhlcHPv+Ul919gKG+Z+9FOc5r6BWE69m2vKvI2VBXTbXPxhJ4k7Yq80zGFVQFvhpS8B7qxXQRC5VisCSoS7eACoJ/5/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000288; c=relaxed/simple;
	bh=oSlqdqfNATOmtBPCQAZC8H3D/gU+n9ZDAANPZN35c2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/Hd57Bxe0BtNXcCHOuHbXbOcmJYADQCV2o3yQxMIW8pm0m6I7gDPyKH9NPTb2Nzmk5UY2WPCszATcFaezyBhwjDanOqnEGwPoq0w8ArrbutdbIx/yWNr5wyYlR20mxnQOHQoLTCt+rF/aEEntpQPZdDVYe+tsM6xW3IuUdvNSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UM8Y/zby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UM8Y/zby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531511F000E9;
	Thu, 28 May 2026 20:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000287;
	bh=P8gT0hOtABW4A3AIcbRxWYQ8NyV417d6QDzi6sUdoM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UM8Y/zbyxF0U/e6T+FM3Q4bybK/kpjGqVjXb0OkED53FUXs5we1JkbAAtuzSU7tSY
	 /N5J5opJlDoz8Uu6yy87Vuy/bEX2tXzgLMHMnu2ao2h1MRj1ineeP93+MfbNHGAWlr
	 Ly8BhSUNmXfeyR9r0BaD3Os1t65xHBq+mXFfSKW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/377] octeontx2-af: npc: Fix allmulticast skip logic for LBK and SDP VFs
Date: Thu, 28 May 2026 21:50:07 +0200
Message-ID: <20260528194649.111824814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 9eddc819f00b5b74bb4ac91396f80bd35f5f3561 ]

When installing the allmulticast NPC rule, rvu_npc_install_allmulti_entry()
should skip LBK and SDP VFs (only CGX PF/VF may add the entry).  The
code combined is_lbk_vf() and is_sdp_vf() with logical AND, which is
never true for a single pcifunc, so the intended early return never ran.

Use logical OR instead.

Cc: Geetha sowjanya <gakula@marvell.com>
Fixes: ae703539f49d2 ("octeontx2-af: Cleanup loopback device checks")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260520043036.1523798-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 8658cb2143dfc..e28675fe18907 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -837,7 +837,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	u16 vf_func;
 
 	/* Only CGX PF/VF can add allmulticast entry */
-	if (is_lbk_vf(rvu, pcifunc) && is_sdp_vf(rvu, pcifunc))
+	if (is_lbk_vf(rvu, pcifunc) || is_sdp_vf(rvu, pcifunc))
 		return;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-- 
2.53.0




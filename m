Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB234AB19;
	Sat, 12 Sep 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226314; cv=none; b=MrU3Ykd4LNsVOGo12QjncmrjBZd/7e3MEKxFSZc3rcmqQ98Bg8o/G5anY6GcW+yGJeSfBrbvGqoQtvfxW/B7kXrAgw8zRpHKVcA4mfzCNQ/mFRnsHDWY9/eXUKbzUrMrrJpzzm+RPTKPZQr8+hr+77uNEU8qG+M8IuYRkUjo/yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226314; c=relaxed/simple;
	bh=crc0HRyhP3vfVnFiDB6ScAiE3mfxi9DejdtS+AQ/2tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjNiJGVf0f8YXP28WD7j+9kKlcpVLc3s2TWJxol/84C/Rq8/6ttDm8+nIF005n4v2I+rfUbLcixV8XhxIX8AIsTpXMZveZxr/i9Wix71/JAcxaAgd3osBMGchTYwoaAus1aVTVMa7rBUrTPDPy5AzEd4iabpOPNZ6xP2/e+zwww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpWmPUix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpWmPUix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513611F000FF;
	Sat, 12 Sep 2026 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226313;
	bh=wqucDTiDsP5DD+ZGZXfQ25coAssH6Ob1j/mTKhtTBw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpWmPUixBJViJ4C1Fd3Q3J6PyTiuSNMtVk6jftarHIvoqlUxHN3T1CqDfT0+0BdDL
	 615LdAiFxBA9KVSCTaMNHCo3SPb0OyO/+mjF5JZLtUovXtQ7uFHYTjmWSF458yUllM
	 ydqlX7tEPIHTKCPOF/e8iCd3N+STJYVZY2Wl1dVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1378/1424] net: stmmac: selftests: Pass the IP proto mask in the TC selftest
Date: Sat, 12 Sep 2026 09:03:30 +0200
Message-ID: <20260912065638.118074222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 9a56a27e6002e29a6707dc4238d469ec84c3a68e ]

The stmmac TC filtering rules have recently gained sanity checks to make
sure the passed keys and their respective masks are aligned with the HW
filtering abilities.

The stmmac selftests failed to pass the mask in the match data for L4
filtering tests, and are now failing consistently with -EINVAL :

$ ethtool -t eth1
[...]
23. L4 DA TCP Filtering          -22
24. L4 SA TCP Filtering          -22
25. L4 DA UDP Filtering          -22
26. L4 SA UDP Filtering          -22

Let's pass the ip_proto mask in the l4 filtering tests match data. Found
on imx8mp, which now have passing L4 tests :

$ ethtool -t eth1
[...]
23. L4 DA TCP Filtering          0
24. L4 SA TCP Filtering          0
25. L4 DA UDP Filtering          0
26. L4 SA UDP Filtering          0

While at it, initialize the masks and keys to avoid re-using whatever
was on the stack.

Fixes: 5536d7c84363 ("net: stmmac: fix l3l4 filter rejecting unsupported offload requests")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260825211748.360935-1-maxime.chevallier@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index f9e43fc32ee84..54ca4abec407f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -1452,11 +1452,11 @@ static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	struct {
 		struct flow_dissector_key_basic bkey;
 		struct flow_dissector_key_ports key;
-	} __aligned(BITS_PER_LONG / 8) keys;
+	} __aligned(BITS_PER_LONG / 8) keys = { };
 	struct {
 		struct flow_dissector_key_basic bmask;
 		struct flow_dissector_key_ports mask;
-	} __aligned(BITS_PER_LONG / 8) masks;
+	} __aligned(BITS_PER_LONG / 8) masks = { };
 	unsigned long dummy_cookie = 0xdeadbeef;
 	struct stmmac_packet_attrs attr = { };
 	struct flow_dissector *dissector;
@@ -1509,6 +1509,8 @@ static int __stmmac_test_l4filt(struct stmmac_priv *priv, u32 dst, u32 src,
 	keys.bkey.ip_proto = udp ? IPPROTO_UDP : IPPROTO_TCP;
 	keys.key.src = htons(src);
 	keys.key.dst = htons(dst);
+	/* Match the full IP proto field */
+	masks.bmask.ip_proto = 0xff;
 	masks.mask.src = src_mask;
 	masks.mask.dst = dst_mask;
 
-- 
2.53.0




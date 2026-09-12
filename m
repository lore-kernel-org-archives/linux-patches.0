Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215E147124F;
	Sat, 12 Sep 2026 13:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219274; cv=none; b=GqhyhqDStJ6GOr4WLjZ+oDvJxe/1tsrGNg1HbYsBAUsWZWkHpYTHkHvQ4s9Pe3ol+b4u+ekHb3w29ZyGZ69Uj6FtziMSjfKl1VFAM4OjlxlfWRjK0QEQWeZdnWIKzHneDJFdpTqn5ZvKhxZ8kq2KMsyu35tK8Bn8/Vw57pmkbUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219274; c=relaxed/simple;
	bh=1EU1WI+J8/RmGvpgOupNxCkUzRcCPJp2WEzk/7OWy70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TetKIJjZqoxNBLk2Of0b37XcZOCh8Qj0vzh1l2zDHJ1gFk3+pIANfpz2e5KKnAoocYaDErIefIFvqFbUA/LysdqdP0pjr2Bivcq9swvbRI3rddUVa9Vp+nCLhSbVHTUaoHAuOwgqa+Rw5IRHtWCaLyP51J8KOpocp1mJ/dLbpgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4tGgMTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4tGgMTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75411F000FF;
	Sat, 12 Sep 2026 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219273;
	bh=ViAchtunLLj6PyduGrzY3eLNSZqHnK21MNqlabse0TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4tGgMTtuhQ04HiaNnxpwbj8gBBtk4siUaQ6IsMuVHzcPAffMPkmiPMbV0P2MaABa
	 m95PI0iOss3njDApdBRaLHA5nFGyTszyxOOSF+R/TQ2EzMHe6d9rnW07xR0Ac+v6E8
	 +oaOp+ZPmO/XA0PyvqQqf4ywVRoIEZhxIiBmJIBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1317/1376] net: stmmac: selftests: Pass the IP proto mask in the TC selftest
Date: Sat, 12 Sep 2026 09:02:23 +0200
Message-ID: <20260912065636.885452037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 3ca1c2a816ff1..63aaafc9f48ca 100644
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




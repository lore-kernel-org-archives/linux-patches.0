Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD671A238F;
	Mon, 17 Aug 2026 13:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974150; cv=none; b=e1tiE8IXPUlE2pHNUv6jBmJCxBXAetRju1kko0rFJ+oPJ52Aq2390MmbZFbo1NXTTZQG+93FNsUL1Q0AfrqJ2co3PlsHzgc19exuBtKsw9BCmCCblO5dCpmncXtqEppTTytSuoqMxfNMFpNoZfBUcgCS+hnNbSl77qQNcOThkjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974150; c=relaxed/simple;
	bh=seYRbwWFdkm/L8CAvWLABLc3ubVMqs1rN6Xm5LW12i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGBFOcdVYkLDVyRgj0SpMIozNcuDEGe0u/dNt2EyRrwCI4hBxCgdAseWJ/tRCvtOhMOOI5ZdDe2K28IKc2CY+BLBO1Gx5xLc8qtArv9qNjBwtpjLgSB5fqm5CSpHjysvaPVz2PfpQKfwozdgKRbADrlgX3AtQHQYr/Sd6dgcsiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmO96Qzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmO96Qzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F281F000E9;
	Mon, 17 Aug 2026 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974149;
	bh=ArOQW3InMMWO+o1aT2xq87qG73dSG7bcq0oKsrN2HxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmO96Qzp0ffJ0vy6f8j/zRBIvf0Gw9yuHS2aFbSnq06iC6P83h3MUlSet7+NnPSjD
	 AFX2P1VzGmByt2Aoc9czgygnV9fAB8h7QHAcvuE/Ir7Cy51tHAIPgv5wX2inZDa7U9
	 APd9+O+yoEXmGB6pEn8Je6m79Yr8erbmtlUtNFes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 106/271] net: qrtr: ns: Raise lookup limit to 128
Date: Mon, 17 Aug 2026 15:30:31 +0200
Message-ID: <20260817132541.203899536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Patron <priv.luk@gmail.com>

[ Upstream commit 7fc1c937b6b37c77df4ba374c37435ab06a2e945 ]

Current limit of 64 is not enough for Sony Xperia 10 VII (SM6475).

After merging v6.6.142 into a downstream AOSP device, it's stuck on
boot animation and following log spam can be observed in dmesg:

E qrtr    : ctrl_cmd_new_lookup(): QRTR client node exceeds max lookup limit!
E qrtr    : qrtr_ns_worker(): failed while handling packet from 1:16600

No idea why it needs more than 64 client lookups, but it appears to
work fine with 128 as it did when there were no limits.

I don't really have a good way to investigate what it needs all
these lookups for as most of the userspace is closed source.

Fixes: 5640227d9a21 ("net: qrtr: ns: Limit the maximum number of lookups")
Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
Link: https://patch.msgid.link/20260804201919.1148015-1-priv.luk@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index e5b2adb161d92..c5e7e01db2498 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -78,7 +78,7 @@ struct qrtr_node {
  */
 #define QRTR_NS_MAX_NODES   512
 #define QRTR_NS_MAX_SERVERS 256
-#define QRTR_NS_MAX_LOOKUPS 64
+#define QRTR_NS_MAX_LOOKUPS 128
 
 static u16 node_count;
 
-- 
2.53.0




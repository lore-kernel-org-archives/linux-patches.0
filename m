Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E433733DEF9;
	Wed, 30 Sep 2026 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792165; cv=none; b=Fnz87R0jWz+Hz0y4Q/yYCCXARkDs1xJWrJ8+csips/KxNXJzqphGclpyyB+HCrqDAz8WFl6Az/r2PVsFD830kOAs0dute+1mGuAR4fyhKLGO7Cr7OnQ3Zu0od5V5ZoSdHcB20H1xwfy6e1jm8/2Rp9RcJRhk5Oanf2G0LfGEx1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792165; c=relaxed/simple;
	bh=RTcNAxtvbl1qEjtjYaVRKKCddqLVntVCHxtj/2fw1gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KRXHxNLg2X1layxpsqw/TCdlc3wDBsaVmuEIdOOop6YyKMmQGiTNt2Y/Y/4RMtlx1dSzVPaGuvJAnGVgRLfIzwZYSvRiqs7NfUPQeDYN3M40C8PaWzTh76Roufq6ORCzvGvEdMEEkm5Y14YrSRyybzfz816gYIjRxacjvrOaoh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPlQnnSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPlQnnSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040851F000FF;
	Wed, 30 Sep 2026 18:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792163;
	bh=Amv8C/W3Cj07o4LJNLzvEgDWVUO0RuUCmKbBRgBAeoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPlQnnSEIrg/19L/d7AehebDJNzRr+GtXfsRdTBfhcHePKIq6kDaWlEh7ALw1r3R2
	 JUDw65nV32i6X3TGQGq2K9cLAKaD5w26nrcJD1GYGIQ9B3d/4oRpOb+Xg36NYVwJDO
	 CoM/qH90tWUaFAHeXfNJmm/hM4DvQVx+1lyfb+mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Okunev <dokunevdmitriy@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/752] net: mvpp2: prevent buffer overflow in page_pool allocation
Date: Wed, 30 Sep 2026 17:26:23 +0200
Message-ID: <20260930152409.359072629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitriy Okunev <dokunevdmitriy@gmail.com>

[ Upstream commit 14cb1e7702e5cb3c58888f6aed498381a73927d2 ]

The per‑processor buffering scheme is supported only if the
number of pools (nrxqs * 2) does not exceed MVPP2_BM_MAX_POOLS (8).
This is already checked in mvpp2_probe() during the initial
activation of percpu_pools.

However, mvpp2_change_mtu() may later call
mvpp2_bm_switch_buffers(priv, true) without this check, which can
lead to an out-of-bounds access in the priv->page_pool array in
mvpp2_bm_init(). The array is sized to hold MVPP2_PORT_MAX_RXQ
entries, and mvpp2_get_nrxqs() may return exactly that value. The
per-CPU scheme then doubles it to nrxqs * 2, exceeding the array
bounds.

Check that the hardware version is MVPP22 or newer and that the
number of pools (nrxqs * 2) does not exceed MVPP2_BM_MAX_POOLS
before switching to per-CPU mode.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7d04b0b13b11 ("mvpp2: percpu buffers")
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
Link: https://patch.msgid.link/20260914091557.71769-1-dokunevdmitriy@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c4951eb88241b..de582b10ab6be 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5072,7 +5072,8 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
 			mvpp2_bm_switch_buffers(priv, false);
 		}
-	} else {
+	} else if (priv->hw_version >= MVPP22 &&
+		   mvpp2_get_nrxqs(priv) * 2 <= MVPP2_BM_MAX_POOLS) {
 		bool jumbo = false;
 		int i;
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D74503918;
	Wed, 30 Sep 2026 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783484; cv=none; b=GrC/tHjQf8Ov2MJwweqXgKlPVMzTAOgD/0cmEdtpQ6DykKPasdIaxaQECFbpF1iDJB8/BkdHfopdZjlQhZ7qHwpjgKRzFfrhnbUsMsW9xD02cO+t/MPLRZRy/cFeEvW3rTVpXUvEcYqW9HAW6M4iR+UshaIxDR2VU7OJ8np7Tb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783484; c=relaxed/simple;
	bh=Ynd2c2Jsr/yruYnuP7Xg5fdr1SVzPmDRZTU4sD9Pgj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PeDAauxEutQ/t6+sOFA3oEcRS4afGt8Z4hDp/Z3QoYlSJJeIhLOWvDVTqF6IUacgOXCnAltrSY0swd97CmRE23rVRtC15XhF+uVT6KrMpKgDfT2zlHVtYC2/lFS+wK8wgpqM/Md7Rxqi5xfdLe0SgShMLR6JaPJj7MvI+cr3M+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb25Nv4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb25Nv4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7AF1F000FF;
	Wed, 30 Sep 2026 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783478;
	bh=y9Nq+EMQCoqMwIkp6YSgXOtq0WYMxK4yexyUtsJoGLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sb25Nv4CtHi2kaAUSeFxJlqsoSAbRiXLZheqE+I/HIHtM+UKLRrCy1cgI6m+p05t8
	 K2LTlK6UVyHDY7LedoMoThTEcTJcUWcjB3zPipS7mYo3Y2OvAcMJ8Z/GWHGA+k3I7B
	 yhqG3CS8ExekgWptm+vq3WmaLyOfV8C+HBvG9rn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Okunev <dokunevdmitriy@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/595] net: mvpp2: prevent buffer overflow in page_pool allocation
Date: Wed, 30 Sep 2026 17:25:07 +0200
Message-ID: <20260930152356.583383583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d672afc73d50..cb0e319bc2f1d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4689,7 +4689,8 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
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




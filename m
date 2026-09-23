Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0E55304A0;
	Wed, 23 Sep 2026 14:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173379; cv=none; b=K1apqHy8T+K0WHLiOW0mvZkPX/huR5olEOIEfQ9qr+oZkTm837xnriYrr/Qx8kYhYImmxX5VdCnZ2g3gd9XBW8CjQskOCXpGTEsk6EtLGQ5AajCkNwATeiWa+w98wjvobicgJ0HbCBpLP3OzTR9hqUr4PfYB78wnEhvKGFSXnEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173379; c=relaxed/simple;
	bh=Br00mF/hTM6FoYsbVJouDhoS42Jxc3FuliQlWdEiFhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hOpV2+5H4JYjKTyQMzvrP+/eVe1UMECNTdVZICooVQX3EDzZbdcNcb7pvAmuyYQbeccSbAGHXcK14gzx7v2g1aSzj0uNH8OENr7d+XKBWh2r0EM8B2OWE8aCmulWO1jb2AMKYCAUqzYPSUc8e4RvLzxIabeaCaUB1gknKpUdMaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fY4qtt8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fY4qtt8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A621F000FF;
	Wed, 23 Sep 2026 14:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173378;
	bh=6Dz2CsKozSf0DeZvzh3Tj1xDXm7AiUwStR/q6A+XLNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fY4qtt8ZWMg365tc/bYI4d/oz3/XPwwx7RHRSr8TYF358wZuwIDSE2oPtGb537XXp
	 Rj/ea189SPRBCJ7V8mzURskKS/yFCf5Nb7MrxLTGT68Lo2gII/VgExRiV1Q7xojSNW
	 HYaMk9/i83t4HWBhqEtgb8bYXBRsIgB0JDDgt1dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Okunev <dokunevdmitriy@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 220/438] net: mvpp2: prevent buffer overflow in page_pool allocation
Date: Wed, 23 Sep 2026 16:04:01 +0200
Message-ID: <20260923140650.468339996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ccc24a1301f22..848ee655c6ea6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5086,7 +5086,8 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
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




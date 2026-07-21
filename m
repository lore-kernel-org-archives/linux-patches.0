Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1861C35C68A;
	Tue, 21 Jul 2026 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669162; cv=none; b=EkWY+9y/jnnyEPg/ZQfTSQ/CAkrbxol7O0mRGx8gKoY1r10IbsjjWX+R6G7WRPxE54SnQnZOtoXHjSooQwat8CdrnSodXZB/OleQbPWi7yxhnaH7wXfQPaVXnj0999+oQ4d8KrIpPTzy/jmaJGRyjdXJIPyALRM5dHFPVZPFi6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669162; c=relaxed/simple;
	bh=7WmT6cv5QRiWdg+r6ldYmqPxSNybSAFvSPsCA8Jdrik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyWkMGd6OCTW6N2qY2O/BsCvvE7h0/pZT4OF/jeVxrwUfUv8z3NZ9p71WdT2NkYrQiMTFJS/Aq5xDYGThqDEGgAwyKU6LU3HTsODUouYQ0bpO3PvSA1L9dxg46wTJniYDGQYW13O/enf5roWQIegzT2wXvvptmmSIEvB+IwUQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvbWbu9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvbWbu9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7D41F000E9;
	Tue, 21 Jul 2026 21:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669161;
	bh=ic2UJ0q+chuipyRQtPZKtV09u5qzgZgpIsLb1hVF4Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvbWbu9+lSA47NxpRQMXrp6eLb7NR4tgSnudhD/weQDgxd1Eo2SyVkfaOwIuUS9xh
	 AkwO+qvNGwcfq85Fxk8xGo7ISVak1pPplhlZOPkuLtWiQQSkZVMOVxA3uyiVg+to4B
	 cTzF935iiudEvSS61p2znC/PRSUaZRXuWla+wrh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0450/1067] net: mana: guard TX wq object destroy with INVALID_MANA_HANDLE check
Date: Tue, 21 Jul 2026 17:17:31 +0200
Message-ID: <20260721152434.686239034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit f8fd56977eeea3d6939b1a9cd8bd36f1779b3ad0 ]

mana_create_txq() has several error paths (after mana_alloc_queues() or
mana_create_wq_obj() failure) where tx_qp[i].tx_object stays as the
INVALID_MANA_HANDLE sentinel set at allocation. mana_destroy_txq() then
unconditionally calls mana_destroy_wq_obj() with (u64)-1, which firmware
rejects and logs an error.

Mirror the RX-side pattern in mana_destroy_rxq() and skip the destroy
when the handle is still INVALID_MANA_HANDLE.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/20260608101345.2267320-3-gargaditya@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 0f84cc4586f02e..db1b8f965eeca4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1413,7 +1413,8 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 			netif_napi_del(napi);
 			apc->tx_qp[i].txq.napi_initialized = false;
 		}
-		mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
+		if (apc->tx_qp[i].tx_object != INVALID_MANA_HANDLE)
+			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
 
 		mana_deinit_cq(apc, &apc->tx_qp[i].tx_cq);
 
-- 
2.53.0




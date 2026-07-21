Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A733EEAE2;
	Tue, 21 Jul 2026 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659824; cv=none; b=lNuohE7ARaIhlktO8GpHIrLTdPFUDWFqvWGUu7b65fyo6rRaKDJhQBfoBKkMWjKXKByXsZFfv8FMrIKSQFX+iNvvuxOGib+stijLx0ISwbD4nIADmViu9d/j+ASRx2XvBnfKaP1VTe3wb3Cz/agkitHKRhID66BzhGSag/c6iN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659824; c=relaxed/simple;
	bh=oNg4DZjQ2Q1JNTe3qrf+uq7U6qxpj4yDa2RmkSOOAkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i797NeRwfCWpXRUIfZSMgE0bWFZ1qasbrJhHFoechqT41WqDYgMYpC/zUDEt53bWOI2poEeKmEXs4FU7ftdGbx6mq+pDp75gkpcnEOimlvdoDfMk2/VqgJvlGb7Tg/Ir6kPvir4YwzjlVmZOtTLySJTzCQTgqHy+sWDELgJJBGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBRAP0tY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBRAP0tY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECD01F000E9;
	Tue, 21 Jul 2026 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659823;
	bh=8RVuQ/fEQDaVv+/PyrasJaeVnc4IBt/eXjKPWT4EIIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBRAP0tYYwuKwRIKDLCveeus05ER2JE0I75uj6fyVuUUQ0g/ZWbYCNvNjLVw3Wdul
	 7/4g/B6xa5hDLneI3KiZUPG28+0wuQTZh8YzMJvhqgd6ZjQISclPiJ9kzKQ1YaYHfm
	 ou7qOMlMWfy4nYgD9qXAbg2a6KO+iPRCxC9c6CsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0748/2077] net: mana: guard TX wq object destroy with INVALID_MANA_HANDLE check
Date: Tue, 21 Jul 2026 17:07:01 +0200
Message-ID: <20260721152610.436742526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c9b1df1ed1098c..d7de4c4d25bbe5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2334,7 +2334,8 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 			netif_napi_del_locked(napi);
 			apc->tx_qp[i].txq.napi_initialized = false;
 		}
-		mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
+		if (apc->tx_qp[i].tx_object != INVALID_MANA_HANDLE)
+			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
 
 		mana_deinit_cq(apc, &apc->tx_qp[i].tx_cq);
 
-- 
2.53.0




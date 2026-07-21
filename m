Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9387747013F;
	Tue, 21 Jul 2026 17:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656767; cv=none; b=G3UNVrmdFdOUGd5au3KrNUi7nzq6cnWiU+Chda+4iuMtOL+XlWOfIxkn3xqpgFWGDlqz94iRXtI+JtMVFRBAFuEJX164kiAeBgVEdFeVLfbWUn2HBM+cRhOJxwfdu6uGW73VePoRDpfrQsghfrDngJ+eMm7okBtMW4ybaT2vKrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656767; c=relaxed/simple;
	bh=n6JL2sDOPwcXXyuvve59/8s00EKu77y+6BxPe4t3D9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJjDQJgKDz91s5kf2cZVZfj2Ot8S5nITzamSRGsQ3L0yLGudw4AH6OM+pmS0jI6kGwhbBo9asr9tjW/eEvsgWz7twMt+C0WPp10gpiZPxYc6RJFtfa+rPAaPd69bh/hTnP4nQgR9nfA/kgs2vWPXISr1IpHlVP+6J7k8yyRHJZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKfXUXF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKfXUXF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD9D1F000E9;
	Tue, 21 Jul 2026 17:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656766;
	bh=BqvmlN0/oI0OaN+XmPq6T5UPvlkoMktLoRAFIclUdqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKfXUXF3oCwpmugzvKQca+lpVa3dULNyrsIliGINNc+XnA2px8JRrJuWIXqKV0xxK
	 TXeBrurRZKhlg0GH5DT7ff2hZwyw8uXhJPLgJM9e6Ei4L8HMpYAn7W88JQDV1eHfW2
	 FuVo9jv5O0GjnT/7K3GCGdB2iI9Mpd84h+koVzxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0509/1611] net: mana: guard TX wq object destroy with INVALID_MANA_HANDLE check
Date: Tue, 21 Jul 2026 17:10:25 +0200
Message-ID: <20260721152526.796898954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 1f723c0ea12837..62418f164dbac1 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2304,7 +2304,8 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 			netif_napi_del_locked(napi);
 			apc->tx_qp[i].txq.napi_initialized = false;
 		}
-		mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
+		if (apc->tx_qp[i].tx_object != INVALID_MANA_HANDLE)
+			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
 
 		mana_deinit_cq(apc, &apc->tx_qp[i].tx_cq);
 
-- 
2.53.0




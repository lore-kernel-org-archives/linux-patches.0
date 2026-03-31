Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA629410D27;
	Tue, 31 Mar 2026 16:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974958; cv=none; b=CukiCQDLcicQguFWrLQpBbB6dTS38b17mJrOoNuOB4blPFqurdF91HRdAlHTSxuSFkRFDa43Bkeb+lomSk4EAR2NfxDGUdp+wd2vm9ge7ps5KBfYWHcCHAvO/CHQAaFFjx9iNh67KBB3oOwmnYwKkgvEPhC8AC6kXFVQkrB8PEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974958; c=relaxed/simple;
	bh=Ed/zcM6aIzzfqHt1wfvZVngpl14ZBfJJqbcLNOEAOvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K05mgNTsdd1Z6kvHsT688KTSkV6u+w0mg0Rtlo5MyspoZC+9NsZLV59tFj3+MxtdlX1oG87nitbjM/MdM3t2+2x9U4Sk1Ccq9+D9B6b/w2pnRA3gzbv4PpGMdiuOin/Bgzd2lPacy90FnndLx4F4FnQyvpYYZfSb78GQU3t5FFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okGBWAK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okGBWAK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF9EC19423;
	Tue, 31 Mar 2026 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974958;
	bh=Ed/zcM6aIzzfqHt1wfvZVngpl14ZBfJJqbcLNOEAOvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okGBWAK5rd5cMAJD7ssX/iOZ5o73bxUauTvotLSu6aeGQZmsgVC2VozZLtCyrVT3S
	 yxuc0BUFwSPi0vWHtbZxx3huArjAz0ND9bJlFsmpJHzw0AQGqqPcN7hhnmy86zGkdT
	 euPhu76w+icJH3+yRF39xmW0xRgrf1XZlTBNve1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 109/342] net: bcmasp: fix double free of WoL irq
Date: Tue, 31 Mar 2026 18:19:02 +0200
Message-ID: <20260331161803.024634329@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit cbfa5be2bf64511d49b854a0f9fd6d0b5118621f ]

We do not need to free wol_irq since it was instantiated with
devm_request_irq(). So devres will free for us.

Fixes: a2f0751206b0 ("net: bcmasp: Add support for WoL magic packet")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260319234813.1937315-2-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index de5f540f78049..fac795ac0fcee 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1157,12 +1157,6 @@ void bcmasp_enable_wol(struct bcmasp_intf *intf, bool en)
 	}
 }
 
-static void bcmasp_wol_irq_destroy(struct bcmasp_priv *priv)
-{
-	if (priv->wol_irq > 0)
-		free_irq(priv->wol_irq, priv);
-}
-
 static void bcmasp_eee_fixup(struct bcmasp_intf *intf, bool en)
 {
 	u32 reg, phy_lpi_overwrite;
@@ -1368,7 +1362,6 @@ static int bcmasp_probe(struct platform_device *pdev)
 	return ret;
 
 err_cleanup:
-	bcmasp_wol_irq_destroy(priv);
 	bcmasp_remove_intfs(priv);
 
 	return ret;
@@ -1381,7 +1374,6 @@ static void bcmasp_remove(struct platform_device *pdev)
 	if (!priv)
 		return;
 
-	bcmasp_wol_irq_destroy(priv);
 	bcmasp_remove_intfs(priv);
 }
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E08D51DE10;
	Wed, 30 Sep 2026 17:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789168; cv=none; b=OcvM2QkJ/aI3NymKb7E/9jUxulTAta2RhyCsJ+T2rCj86wS6hd+CgQbwCFW7KRgl6rWeERdun3bx+QLftfFAWNHMOaFg9v8NAr60LpikPoT3/ssruS6IIoTqPUDpwNTsO0XIEzO7zRJ95yzbZ4e/K4je+mNGNoYA232RxMR87D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789168; c=relaxed/simple;
	bh=lXs3BM39mJNyuWQs1J8iFFjEfcwLHPfISevsbGd5fUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF4Yhqst8KPIOwm3dPmHaFmUb/z6e0I+O5f1QFj76h64UOFpDFtCtURxLzJ/OfY04u3tU5wO2hxxRuau4JuhzxSARstd6bDLUxUSpLJFvAWtBjvwCOe9Ue6G9IkfGF10LFlAoGb8xb/qJBT28PP4qteeKaFXWjVLVgfc2RWvLew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDFZmRBT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDFZmRBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95DC1F000FF;
	Wed, 30 Sep 2026 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789167;
	bh=Bt7/hcFX25D4ZJaDLhAFCcGMXrZwdTgU6dhOgEm9WAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDFZmRBTnM3XvAi17a2OCoKcY1z1RxHKixZH8nHgtEFnhMz7bAMDBu2FqTZdNqnbq
	 6gvlhWU3e/bFoSVkP10RZdCb2jB8J0tFjTFbUbPS3FQUcjNhi1bW64hwO8lzaqUH5X
	 /oDtUigvIWgjVCpCV3enR1Xmz+ZWVii0gNS1iBtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/877] tg3: clean up PHYLIB resources on probe failure
Date: Wed, 30 Sep 2026 17:21:32 +0200
Message-ID: <20260930152422.896970253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit a92e1a412c53dc0d9ad639e7abf8b3fc70a5b6ad ]

tg3_get_invariants() can register an MDIO bus and connect a PHY for
USE_PHYLIB devices. If tg3_init_one() later fails, its common error path
releases the mappings and netdev without undoing those PHYLIB resources.

Disconnect the PHY and unregister the MDIO bus before the remaining
teardown. Guard PHY cleanup with USE_PHYLIB to match tg3_phy_init(), and
call tg3_mdio_fini() unconditionally to match tg3_mdio_init(). The existing
IS_CONNECTED and MDIOBUS_INITED flags make both helpers safe when
initialization only completed partially.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 158d7abdae85 ("tg3: Add mdio bus registration")
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260917183336.36239-1-mhun512@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 752f33ae98383..1df77bf9428b1 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18031,6 +18031,10 @@ static int tg3_init_one(struct pci_dev *pdev,
 	return 0;
 
 err_out_apeunmap:
+	if (tg3_flag(tp, USE_PHYLIB))
+		tg3_phy_fini(tp);
+	tg3_mdio_fini(tp);
+
 	if (tp->aperegs) {
 		iounmap(tp->aperegs);
 		tp->aperegs = NULL;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7F23C07A;
	Thu, 20 Aug 2026 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238602; cv=none; b=PVi7leOy1j4KZWOaqqxPiJpeW8blA9syTDe0zAmb4uy+pDAymFejuql9QJd/9fNhn2yFxQ/Bv/U0gYC1lrBgbxLZhThH2LE5f7omWpg7Q3xmdIt/E/Gj2TpW556SKP2QNtloYIltu8a0NrFRze3m8Tc5YsYXKAWzxKazddNm10U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238602; c=relaxed/simple;
	bh=o4FTjHp4CRI8jV2DXk3PsELtKw/PhycOCfpOZGeByi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWuDRhWBn9+ZyQmcvqoVCUOpZizU21TqIWUZ0Q7aAdZkMJwk+8BD9t4oAR1TjX5AxLQeZYauUWVfVibBvSuDngtrdWvONWY96xDVnDY1cGi6cm+m1ADXo6Zqt7mC15samslvC15ypzODtUd9R6iGRxDT5CpNa8esh8TaRew7h1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T63ZKx3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T63ZKx3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2012F1F000E9;
	Thu, 20 Aug 2026 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238600;
	bh=MIbF+MiOi3mJhLqzz767Y/e1s6c9PR6jdh5Fr7kqg+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T63ZKx3hINbs1hsc1BTh4bmcLTD5MW0kICYLkEoZq37rwxyhDfb1yoLlw1p1fYzeb
	 sxg2B3A+hOprOifq7fkb7mcxV5ZI2PfsOSkAu3zLxDQcTa4rSzbtsQF2bCL2UrZj80
	 RMGx6rPn/XosmbBx93hW6b20TMPnS9YgCwQqycJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 204/228] net: ngbe: fix NULL pointer dereference in non-MSI-X interrupt enabling
Date: Thu, 20 Aug 2026 16:55:46 +0200
Message-ID: <20260820145251.231424480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 5f3a13e0bb5ebcc1ca2dfda42ea40b9f3c2be6ea ]

In non-MSI-X mode (such as legacy INTx or single MSI), wx->msix_entry is
not allocated or initialized. Calling NGBE_INTR_MISC(wx) dereferences
wx->msix_entry->entry, leading to a NULL pointer dereference crash.

This issue was introduced by fixing the IRQ vector when the number of
VFs is 7. Fix the issue by explicitly checking `pdev->msix_enabled` to
determine the correct vector index.

Additionally, as a side fix, set the interrupt mask to BIT(0) for the
non-MSI-X fallback. In MSI/INTx mode, the MISC and queue interrupts
share vector 0, and the WX_PX_MISC_IVAR register is only valid in the
MSI-X case. Thus, BIT(0) is the correct mask for the miscellaneous cause
when MSI-X is disabled.

Fixes: 4174c0c331a2 ("net: ngbe: specify IRQ vector when the number of VFs is 7")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/B2693E9A8BFAD110+20260807062214.410838-1-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index d8e3827a8b1f2..899c768d97d4c 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -180,8 +180,10 @@ static void ngbe_irq_enable(struct wx *wx, bool queues)
 	/* mask interrupt */
 	if (queues)
 		wx_intr_enable(wx, NGBE_INTR_ALL);
-	else
+	else if (wx->pdev->msix_enabled)
 		wx_intr_enable(wx, NGBE_INTR_MISC(wx));
+	else
+		wx_intr_enable(wx, BIT(0));
 }
 
 /**
-- 
2.53.0




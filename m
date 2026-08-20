Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCF7381AFF;
	Thu, 20 Aug 2026 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239226; cv=none; b=GK8McvOAitW85dpBjdDo/VBE2h0zGJhsz6g7BO1ak6pnn4Fy4/loAsdbZ43yE5BMxqPlVNEnFGLkooxxd9KvbF4Tr0M+LvHY93ZkFvX+1+SvldP91XPNDPS+5gpEn/y3KWilcBWocC5HQrv0HugSm2VfY134cXyxCb3e42WYt6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239226; c=relaxed/simple;
	bh=lyGHAdJ10iJzZ1VaSJDiSiYCSWmTTOM49/ksJvSuUmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti8M2dBRNLP8BSLM1DOK4Su+i/JomFbEkvzIU8c7Z+MDTqIx+xQyFSVRgxJwxq7wfx3rGY6U80WWdHpDCI7czvkf0rOtuRyCIZjVf+Ec89oRe8zgHxy8TkPZHoc008sB6L8S5mQc2j7TZGuEuDnwZVrrYMaX5+tdBp3FeFWz1Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSVzIgJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSVzIgJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1536B1F00A3D;
	Thu, 20 Aug 2026 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239225;
	bh=ZeuTuXqrPPu6BFvXcl+uhjJeqFHmx5t8Ru8Qc14f9FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSVzIgJGbEMZqjp0TClI5FeAuK4Sr58hq6GtTUCZ2kcuy5wi+/1oVOpAkgBMD8JEp
	 sjTGRns3lc/TcUMB0itaTjaAvuut4grZfrJY0KzHtg3d1cT+Ei3ScxYtLdZAY+eR5z
	 AnuIByEe1RV/bV+xpz0hM689k1sUiI7CpSmJXF/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/217] net: ngbe: fix NULL pointer dereference in non-MSI-X interrupt enabling
Date: Thu, 20 Aug 2026 16:56:00 +0200
Message-ID: <20260820145243.494853715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
index 58488e138beb4..e80962d40f7ed 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -160,8 +160,10 @@ static void ngbe_irq_enable(struct wx *wx, bool queues)
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




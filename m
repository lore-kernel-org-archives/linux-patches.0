Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8426FB1;
	Tue,  5 Dec 2023 03:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3bpBrlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD8AC433C8;
	Tue,  5 Dec 2023 03:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747192;
	bh=jYhrRJU+BVlJ0574Pv7W5IENqclEVlnWrf57T3diJ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3bpBrlV+Nmyftlyt+tkzIOlmWbdvvaNP7YNP0Xc9gxLdZMlVpax1e8U6ebzau8y3
	 emGsEOcVyI67VoKOrvAI/SeBdBmlnpgbcITw/tB9QrzSokvtybkyG1refGk2OdW1An
	 fcnFs1Z15BnqtREhpVqUxn1tqxunURfNae1+2dWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/107] r8169: prevent potential deadlock in rtl8169_close
Date: Tue,  5 Dec 2023 12:16:45 +0900
Message-ID: <20231205031535.848892037@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 91d3d149978ba7b238198dd80e4b823756aa7cfa ]

ndo_stop() is RTNL-protected by net core, and the worker function takes
RTNL as well. Therefore we will deadlock when trying to execute a
pending work synchronously. To fix this execute any pending work
asynchronously. This will do no harm because netif_running() is false
in ndo_stop(), and therefore the work function is effectively a no-op.
However we have to ensure that no task is running or pending after
rtl_remove_one(), therefore add a call to cancel_work_sync().

Fixes: abe5fc42f9ce ("r8169: use RTNL to protect critical sections")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/12395867-1d17-4cac-aa7d-c691938fcddf@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 770391cefb4e4..d293c996252cd 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4656,7 +4656,7 @@ static int rtl8169_close(struct net_device *dev)
 	rtl8169_down(tp);
 	rtl8169_rx_clear(tp);
 
-	cancel_work_sync(&tp->wk.work);
+	cancel_work(&tp->wk.work);
 
 	free_irq(tp->irq, tp);
 
@@ -4890,6 +4890,8 @@ static void rtl_remove_one(struct pci_dev *pdev)
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_get_noresume(&pdev->dev);
 
+	cancel_work_sync(&tp->wk.work);
+
 	unregister_netdev(tp->dev);
 
 	if (tp->dash_type != RTL_DASH_NONE)
-- 
2.42.0




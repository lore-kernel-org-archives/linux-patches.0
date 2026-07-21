Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F040803D;
	Tue, 21 Jul 2026 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656892; cv=none; b=Jwk+FjHTZ6tABE4GWNokwqKimnrwnemgg1iygdk39R2aauEjX0mHm2c4OkmgGJ9Poe1cr5+uR2m1jtWE9R399vYwaXciWHPAEdiFTj6AygT3+0AE8z4s6ZqvQEeTJ6zeWZVwzYbux/Rq6nXQk2O/m3WmxMiJ9iOx1vfLtcsw84g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656892; c=relaxed/simple;
	bh=OBG7PB+WEKqjbBAtbs59FduoOX/RURSK64siIcaMwh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8qSlLliGL6ffTIyyxM/X6qt6WYFDAU/mnQLa1P+EHtNGFd4HCdt4N/ciDFO4s21ol6EEdwEUHEBV85ceh4VVfx55c/spSSY7NB1J40lx+7ZhNKKgljwFOA2kV0B+NZxI3nO8eaitz75j4203rb8ka9JtHZ654Awg37j+4bGpG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwRq6sWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwRq6sWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82DE1F000E9;
	Tue, 21 Jul 2026 18:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656891;
	bh=C1nnxkEm1WtRggLSdQRsZDqmkgeGEon0mijQqWAcxko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwRq6sWlRE+LLzZIN0KuBfozXNy+UU9OS+mwGOCtF5llfCMPCH6tS+UptTCU6/GdM
	 Q6yeBLq8ES47ufobl45k2Ubz8vyb2+FrXRLw7VBqHx3eWMb4j6n8O3gFLCF2/lTziI
	 9f5kKxv0+zY3yeOZQRjtAu8bso/7RIb+oUFbQBGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0556/1611] ionic: Fix check in ionic_get_link_ext_stats
Date: Tue, 21 Jul 2026 17:11:12 +0200
Message-ID: <20260721152527.885085396@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 7678e69079c10b2fb10977f28f44ddb22971ea5b ]

The current check will fail if SR-IOV is not initialized for the
physical function; this is because is_physfn is 0 if sriov_init() isn't
run or fails. Change the check that prevents getting the link down count
to use is_virtfn instead so that VFs don't get this functionality, which
was the original intent.

Fixes: 132b4ebfa090 ("ionic: add support for ethtool extended stat link_down_count")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Link: https://patch.msgid.link/20260614205303.48088-2-eric.joyner@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 347b0aff100b9f..62b739ca26d26e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -116,8 +116,15 @@ static void ionic_get_link_ext_stats(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	if (lif->ionic->pdev->is_physfn)
-		stats->link_down_events = lif->link_down_count;
+	if (lif->ionic->pdev->is_virtfn)
+		return;
+
+	if (!lif->ionic->idev.port_info) {
+		netdev_err_once(netdev, "port_info not initialized\n");
+		return;
+	}
+
+	stats->link_down_events = lif->link_down_count;
 }
 
 static int ionic_get_link_ksettings(struct net_device *netdev,
-- 
2.53.0




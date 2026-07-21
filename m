Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FC9432E6F;
	Tue, 21 Jul 2026 19:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662321; cv=none; b=OwPGB9Br3JYvf/A5a+QKrckK8QhV66q8in0RMV22+YO/AoWaPWfpwTKL8GwIUdLfZMQXavCUqo5yu2wBtIn66811DZahoeRC7a+ouda9TuPxW4G94tpB2slnN/Q25yTsAFzLBbKK6WvA9MSDx5Q9olbDI711sbuiYKBhpx2IJvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662321; c=relaxed/simple;
	bh=2j+YfamZn2E8ZSLbhJmFu86rl4XIDq5mLYfQKtlabAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2K2MUCanyIr/1jC3PgH1QnVkgwwrTjmyB7MavjRLcQtN5Gu4Qb69btqfaZSP3sU07dF68Yq5LS0m7jnRw0vajYFOJkzgDVEGcfgamO96z0UJai7mW4v4InKmk34KSw6hk+d5CBNxiLHlysd1hJREZ5qQaCoTjYgcivn6Qlb0As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgPGln/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgPGln/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93B51F000E9;
	Tue, 21 Jul 2026 19:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662320;
	bh=sqSxfA8Ryd9jYM7l7aaq00SPr6mlpDeoJ6IkEqPlJeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgPGln/fAn03YZkHMQMT+HGpuQ2wPioiRC648qNIapCmoogANgzoebf3zCX+SicK7
	 k8QX+wb8GCfdW9HZy+m3UNTs4q2Q7oj/OZeR59i5EobSmuQnDQJUTm/t+iS/fjVt+U
	 3PkNCLg8/f5itbhzz8VSVxC7ySi63i3tk60KSWQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0399/1276] ionic: Fix check in ionic_get_link_ext_stats
Date: Tue, 21 Jul 2026 17:14:02 +0200
Message-ID: <20260721152455.030032074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index a632536bd7f2f1..8ce45aaa74a732 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7B33BB42
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJU9ZZQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0C3C433C7;
	Wed, 15 Nov 2023 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076201;
	bh=x1h4cyY4Hr+Ee2M7FBZ36ITWWPuRiG90GvVZYEOG7WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJU9ZZQRYHC96UAO/R+WDCkzuTA3mP7heWs+hSf6UZNXyEFtWQRdZEV0iiwBAu4gG
	 zvt4yb0zRnErUIroDaRJbt2fX4dKKyP0pvX+J4hRuBeg7hjP1clDDvtSnpSyNgiqNt
	 H1yt8vdkVI1YVOwkjlQohGpAjmQO+f7gyxtqi068=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Kj=C3=A6r=20J=C3=B8rgensen?= <me@lagy.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 115/550] r8169: fix rare issue with broken rx after link-down on RTL8125
Date: Wed, 15 Nov 2023 14:11:39 -0500
Message-ID: <20231115191608.665479655@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 621735f590643e3048ca2060c285b80551660601 ]

In very rare cases (I've seen two reports so far about different
RTL8125 chip versions) it seems the MAC locks up when link goes down
and requires a software reset to get revived.
Realtek doesn't publish hw errata information, therefore the root cause
is unknown. Realtek vendor drivers do a full hw re-initialization on
each link-up event, the slimmed-down variant here was reported to fix
the issue for the reporting user.
It's not fully clear which parts of the NIC are reset as part of the
software reset, therefore I can't rule out side effects.

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Reported-by: Martin Kjær Jørgensen <me@lagy.org>
Link: https://lore.kernel.org/netdev/97ec2232-3257-316c-c3e7-a08192ce16a6@gmail.com/T/
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/9edde757-9c3b-4730-be3b-0ef3a374ff71@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 361b90007148b..a987defb575cf 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4596,7 +4596,11 @@ static void r8169_phylink_handler(struct net_device *ndev)
 	if (netif_carrier_ok(ndev)) {
 		rtl_link_chg_patch(tp);
 		pm_request_resume(d);
+		netif_wake_queue(tp->dev);
 	} else {
+		/* In few cases rx is broken after link-down otherwise */
+		if (rtl_is_8125(tp))
+			rtl_reset_work(tp);
 		pm_runtime_idle(d);
 	}
 
-- 
2.42.0




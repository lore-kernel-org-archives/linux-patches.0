Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB493A380C;
	Sat, 17 Oct 2026 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260791; cv=none; b=GQIYi36p281LpNMhvbkoytZu21VDXyNYK9RWJzcy76iM3Floeu5AHuzuq07S+5MD65C9sSdg5jHDnYAA/Js02pZBFxBArAof9mKWBoMLeAs5bK+zAxwgeinwVzYVflu/1MHR/ldidJBhTjpybVR0YcdhmatDLJ8nUCWCElo+fcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260791; c=relaxed/simple;
	bh=7cqPta1T8Yo4SviE3tYiuREPqhIrGOzD4yVE+xK3+EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3KopiQ6aYRsr1+iKIxMV9OE9xDRhAmpgeHo8vSU+gQjmxIwxJfaKJrx6TLHfPkNZT6kAnn/3dyrUHeL18r64lQFzVeddURIoH+yGHtcHltdHpZ51A1DB6+1iunmPHtFGdRhRxJdfEjx9o5A/PIkXxoyUplU8b8mKlGKYnu6UEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJYbygxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJYbygxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3B61F000C4;
	Sat, 17 Oct 2026 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260790;
	bh=mBOVEBgmv75tSrtfcIZy4e7CGlt/2gSwavt3K8mKnzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJYbygxISo28S7dXXWSYvKWOYWjlMijSMJrs3syYlt/CRbNYE02EkgioZUIWcNXMA
	 Vb/xrapqi44OCdDpC2xRvF7lE51lk0oMROwE+Xc8Ao4TDvBjQsk4bZGRoE4JNMhhrF
	 n6iJH1vXnrciSLAFmHBeDcKYo1PTEVb6kqv7THGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1660/1674] r8169: remove original workaround for RTL8125 broken rx issue
Date: Sat, 17 Oct 2026 18:05:32 +0200
Message-ID: <20261017160513.679280772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 854d71c555dfc3383c1fde7d9989b6046e21093d ]

Now that we have b9c7ac4fe22c ("r8169: disable ALDPS per default for
RTL8125"), the first attempt to fix the issue shouldn't be needed
any longer. So let's effectively revert 621735f59064 ("r8169: fix
rare issue with broken rx after link-down on RTL8125") and see
whether anybody complains.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/382d8c88-cbce-400f-ad62-fda0181c7e38@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2e731b5587a23..39d97c56166dc 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4669,11 +4669,7 @@ static void r8169_phylink_handler(struct net_device *ndev)
 	if (netif_carrier_ok(ndev)) {
 		rtl_link_chg_patch(tp);
 		pm_request_resume(d);
-		netif_wake_queue(tp->dev);
 	} else {
-		/* In few cases rx is broken after link-down otherwise */
-		if (rtl_is_8125(tp))
-			rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_NO_QUEUE_WAKE);
 		pm_runtime_idle(d);
 	}
 
-- 
2.53.0




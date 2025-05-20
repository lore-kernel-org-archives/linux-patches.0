Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7095A2459D4;
	Tue, 20 May 2025 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749226; cv=none; b=kPCblpZMSLeMA/U+UR3HxyWUtbk4awYYs5sl/HkRpnwhBu0VHc6IUTzqp6Mb3X5C2OCyPXJNZTjb8uFJFcjcQkzZfw1iuCVUcDj8dQAnHT7oznLpFVstAYV2ttVIv11CpVNRCOhqFaRe/adjTixy8EbJbAK8X88e8N/NFnkzGPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749226; c=relaxed/simple;
	bh=Gyb/4YBqtd8fCFV8CmjbJYwI+QPZgI16cuHJnOk0CP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5WyoKbvzS7FpU1lC70CpL2BXil/v+aSXcJblUNwA5MaXDesXknPehe1jeKb/3ZW1vqouVIZjztUKMA03RVMcInDatsBAa58X3baxtY7LDkGV0/84DsryyFoloQcrVXASJkHdWls/BTWC6boTOIZNSFqRm0jp6QB9tfO1OazIKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbo+JL4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbo+JL4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D7CC4CEEA;
	Tue, 20 May 2025 13:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749226;
	bh=Gyb/4YBqtd8fCFV8CmjbJYwI+QPZgI16cuHJnOk0CP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbo+JL4NsNv/GdzA150r7b7FuiHGUoJBJORNl2mVWOwa52TiL6tZjeLbPrrpn1Zs2
	 NEHFAasraSdHlSKhzCfU5+ZUWnHOpnIOonexA9j3mOTQqrfUs9n8E3PCHkgkUqx9pC
	 AW5eb3Ec0GyRYk8HKNujECQzDbDdocUrgVV45cRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Othacehe <othacehe@gnu.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/59] net: cadence: macb: Fix a possible deadlock in macb_halt_tx.
Date: Tue, 20 May 2025 15:50:00 +0200
Message-ID: <20250520125754.206899792@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Othacehe <othacehe@gnu.org>

[ Upstream commit c92d6089d8ad7d4d815ebcedee3f3907b539ff1f ]

There is a situation where after THALT is set high, TGO stays high as
well. Because jiffies are never updated, as we are in a context with
interrupts disabled, we never exit that loop and have a deadlock.

That deadlock was noticed on a sama5d4 device that stayed locked for days.

Use retries instead of jiffies so that the timeout really works and we do
not have a deadlock anymore.

Fixes: e86cd53afc590 ("net/macb: better manage tx errors")
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250509121935.16282-1-othacehe@gnu.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 275baaaea0e12..667af80a739b9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -986,22 +986,15 @@ static void macb_update_stats(struct macb *bp)
 
 static int macb_halt_tx(struct macb *bp)
 {
-	unsigned long	halt_time, timeout;
-	u32		status;
+	u32 status;
 
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(THALT));
 
-	timeout = jiffies + usecs_to_jiffies(MACB_HALT_TIMEOUT);
-	do {
-		halt_time = jiffies;
-		status = macb_readl(bp, TSR);
-		if (!(status & MACB_BIT(TGO)))
-			return 0;
-
-		udelay(250);
-	} while (time_before(halt_time, timeout));
-
-	return -ETIMEDOUT;
+	/* Poll TSR until TGO is cleared or timeout. */
+	return read_poll_timeout_atomic(macb_readl, status,
+					!(status & MACB_BIT(TGO)),
+					250, MACB_HALT_TIMEOUT, false,
+					bp, TSR);
 }
 
 static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
-- 
2.39.5




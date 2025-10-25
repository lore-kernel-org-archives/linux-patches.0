Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C52FC893;
	Sat, 25 Oct 2025 16:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409182; cv=none; b=bNf/0KG5Q49EqWeoOUt8RRJyjOV/zcf90fCkSk53ns2EaeRYG1QU8zcxD+/ES8n/u6ZlaLdg8SKX5K1A7VdEfUWfgvKhdW5GYl4OdYYltQr9DxRJoPRPt2XpN4rLIBhfT9y4NaPHhNuX47hy0G1JuWG1rULDnKrNo84ZWbPo8tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409182; c=relaxed/simple;
	bh=afWHb3gFsT0vDh4zieSFw/sUmsJjUwN4HXbzjwzZjfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JsjJv1usvEX7Hs7eg7vgfVXJArBvlAeESUH/aJVFosOkAHPAsX6XGfCY6e8Di1flckiRIhyDboZZYMo8hyJGWnPtYc4x1n68/Ux7Qp+3DWz8DQYcWqCvm1IRpHWuFnaGb2pVHh92F8+gRbWowGAYPh5NSiWp8ZWL4rLsz95ClWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCxNJVdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCxNJVdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39EDC4CEF5;
	Sat, 25 Oct 2025 16:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409181;
	bh=afWHb3gFsT0vDh4zieSFw/sUmsJjUwN4HXbzjwzZjfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCxNJVdE2/tZnEP+d9OpVyehdRxSDUkiMkcv/Q8QG8jfeG1xb/vcCI8U4Eo5Dt2bV
	 MWVrIwi3bp53/OKMR8EBrS58lmJOhjNvpiS1ngWOsm4iCwz9NKjg30tFAdMYQnuGVR
	 Y9Sj16kb0RFBQ9LpUA16J6oB+kIehp0pJNqU7ZdPILMLJxY3mvyK/gFuUTciEBvGHP
	 fo2rJilzGeU2zUarTjYwrz/Rpk09s9dFAzzwNc6FKmarx64o09vGFQw1PeXU2hc1ra
	 V4mPGT9uzkf0myAPEA3wJzYgaVmvXxCaq3BJjXah2RbmlJJraoCPAOnZcNYSu73GVl
	 zgVKgXj7+B0xA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rohan G Thomas <rohan.g.thomas@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Furong Xu <0x1207@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	rmk+kernel@armlinux.org.uk,
	maxime.chevallier@bootlin.com,
	jacob.e.keller@intel.com,
	hayashi.kunihiko@socionext.com,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	alexis.lothore@bootlin.com,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.12] net: stmmac: est: Drop frames causing HLBS error
Date: Sat, 25 Oct 2025 11:57:42 -0400
Message-ID: <20251025160905.3857885-231-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rohan G Thomas <rohan.g.thomas@altera.com>

[ Upstream commit 7ce48d497475d7222bd8258c5c055eb7d928793c ]

Drop those frames causing Head-of-Line Blocking due to Scheduling
(HLBS) error to avoid HLBS interrupt flooding and netdev watchdog
timeouts due to blocked packets. Tx queues can be configured to drop
those blocked packets by setting Drop Frames causing Scheduling Error
(DFBS) bit of EST_CONTROL register.

Also, add per queue HLBS drop count.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Reviewed-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/20250925-hlbs_2-v3-1-3b39472776c2@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Enabling EST currently leaves blocked frames in the Tx queue when a
  Head-of-Line Blocking due to Scheduling (HLBS) fault happens, so the
  scheduler keeps retrying the same frame and continuously raises HLBS
  interrupts, which ends in watchdog timeouts. The fix explicitly sets
  the hardware “Drop Frames causing Scheduling error” bit when EST is
  enabled (`drivers/net/ethernet/stmicro/stmmac/stmmac_est.c:66`
  together with the new definition in `stmmac_est.h:19`), so those
  unschedulable frames are discarded by the MAC instead of wedging the
  queue.
- The change is tightly scoped to the EST path: when EST is disabled
  nothing changes (`stmmac_est.c:65-68`), so non-TSN users of stmmac are
  unaffected. The additional per-queue accounting merely increments a
  counter when HLBS drops occur (`stmmac_est.c:110-114` with storage
  added in `common.h:231`); it does not alter behaviour and has no UAPI
  impact.
- This solves a real, user-visible failure (interrupt storms and `netdev
  watchdog` fires) that exists in all builds with EST support since it
  was introduced, while the code delta is minimal and self-contained.
  There are no prerequisite refactors beyond what is already in stable,
  and there is no evidence of regressions from setting this documented
  control bit.

 drivers/net/ethernet/stmicro/stmmac/common.h     | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c | 9 ++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.h | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index cbffccb3b9af0..450a51a994b92 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -228,6 +228,7 @@ struct stmmac_extra_stats {
 	unsigned long mtl_est_btrlm;
 	unsigned long max_sdu_txq_drop[MTL_MAX_TX_QUEUES];
 	unsigned long mtl_est_txq_hlbf[MTL_MAX_TX_QUEUES];
+	unsigned long mtl_est_txq_hlbs[MTL_MAX_TX_QUEUES];
 	/* per queue statistics */
 	struct stmmac_txq_stats txq_stats[MTL_MAX_TX_QUEUES];
 	struct stmmac_rxq_stats rxq_stats[MTL_MAX_RX_QUEUES];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
index ac6f2e3a3fcd2..4b513d27a9889 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
@@ -63,7 +63,7 @@ static int est_configure(struct stmmac_priv *priv, struct stmmac_est *cfg,
 			 EST_GMAC5_PTOV_SHIFT;
 	}
 	if (cfg->enable)
-		ctrl |= EST_EEST | EST_SSWL;
+		ctrl |= EST_EEST | EST_SSWL | EST_DFBS;
 	else
 		ctrl &= ~EST_EEST;
 
@@ -109,6 +109,10 @@ static void est_irq_status(struct stmmac_priv *priv, struct net_device *dev,
 
 		x->mtl_est_hlbs++;
 
+		for (i = 0; i < txqcnt; i++)
+			if (value & BIT(i))
+				x->mtl_est_txq_hlbs[i]++;
+
 		/* Clear Interrupt */
 		writel(value, est_addr + EST_SCH_ERR);
 
@@ -131,10 +135,9 @@ static void est_irq_status(struct stmmac_priv *priv, struct net_device *dev,
 
 		x->mtl_est_hlbf++;
 
-		for (i = 0; i < txqcnt; i++) {
+		for (i = 0; i < txqcnt; i++)
 			if (feqn & BIT(i))
 				x->mtl_est_txq_hlbf[i]++;
-		}
 
 		/* Clear Interrupt */
 		writel(feqn, est_addr + EST_FRM_SZ_ERR);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h
index d247fa383a6e4..f70221c9c84af 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h
@@ -16,6 +16,7 @@
 #define EST_XGMAC_PTOV_MUL		9
 #define EST_SSWL			BIT(1)
 #define EST_EEST			BIT(0)
+#define EST_DFBS			BIT(5)
 
 #define EST_STATUS			0x00000008
 #define EST_GMAC5_BTRL			GENMASK(11, 8)
-- 
2.51.0


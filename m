Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB3D1D3634;
	Tue, 30 Jul 2024 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355261; cv=none; b=RCYPWPlUJXDi6ZweKldvnHigegFCo9opFM3ckPBZh1sefvvz/9nr3LXwqrdqOF/fvPyiYCgAiRJcprV9Y0vmbCfEPNvc9TtSgA5F4Jr4jasKtj+nRMh6SFCli7rS7aYwM3TAXDkUIzYk2EHWWtSB1se8lwYW81xQX84BjCq6/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355261; c=relaxed/simple;
	bh=1ZY839CPLnqqr+S0c4VJ1GZjPCLHzBK7Pq/rgTu/ylM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo/nRRI+fgLeKEAaA6TjUCms4oF7QfAki9zqb7KwHOhY5THGLTwPNlfQjk9csMTpbSbpz9bA0nLHEn0FuQhDRnkh14gSAvE9aIvfnoMaSD9VPDqyq2bApFgnw6guh6icbEnV0L1G/j55/avF62wU6p/usNPMowN7IYFhiA1kvCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q077XYTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q077XYTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42B7C32782;
	Tue, 30 Jul 2024 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355261;
	bh=1ZY839CPLnqqr+S0c4VJ1GZjPCLHzBK7Pq/rgTu/ylM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q077XYTeWvC6BdbsIpOj/jxBSnMqkKKtvri5ll8jOvR/oaa7hnL7VHu8//P9ml5HJ
	 LYYIlmq9f7d7VXU3YdUaR5rX0ldDh1V1TSWTWdyyVF012jboMAO7WdEEMDRWlgqM+R
	 FUNBM3aAsKGGiZZ5Rc7HhvdCZ2X/cPcr9o/tM13Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/568] soc: qcom: rpmh-rsc: Ensure irqs arent disabled by rpmh_rsc_send_data() callers
Date: Tue, 30 Jul 2024 17:42:29 +0200
Message-ID: <20240730151641.482608400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit e43111f52b9ec5c2d700f89a1d61c8d10dc2d9e9 ]

Dan pointed out that Smatch is concerned about this code because it uses
spin_lock_irqsave() and then calls wait_event_lock_irq() which enables
irqs before going to sleep. The comment above the function says it
should be called with interrupts enabled, but we simply hope that's true
without really confirming that. Let's add a might_sleep() here to
confirm that interrupts and preemption aren't disabled. Once we do that,
we can change the lock to be non-saving, spin_lock_irq(), to clarify
that we don't expect irqs to be disabled. If irqs are disabled by
callers they're going to be enabled anyway in the wait_event_lock_irq()
call which would be bad.

This should make Smatch happier and find bad callers faster with the
might_sleep(). We can drop the WARN_ON() in the caller because we have
the might_sleep() now, simplifying the code.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/911181ed-c430-4592-ad26-4dc948834e08@moroto.mountain
Fixes: 2bc20f3c8487 ("soc: qcom: rpmh-rsc: Sleep waiting for tcs slots to be free")
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20240509184129.3924422-1-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 7 ++++---
 drivers/soc/qcom/rpmh.c     | 1 -
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index daf64be966fe1..dfc2d4e38fa9b 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -646,13 +646,14 @@ int rpmh_rsc_send_data(struct rsc_drv *drv, const struct tcs_request *msg)
 {
 	struct tcs_group *tcs;
 	int tcs_id;
-	unsigned long flags;
+
+	might_sleep();
 
 	tcs = get_tcs_for_msg(drv, msg);
 	if (IS_ERR(tcs))
 		return PTR_ERR(tcs);
 
-	spin_lock_irqsave(&drv->lock, flags);
+	spin_lock_irq(&drv->lock);
 
 	/* Wait forever for a free tcs. It better be there eventually! */
 	wait_event_lock_irq(drv->tcs_wait,
@@ -670,7 +671,7 @@ int rpmh_rsc_send_data(struct rsc_drv *drv, const struct tcs_request *msg)
 		write_tcs_reg_sync(drv, drv->regs[RSC_DRV_CMD_ENABLE], tcs_id, 0);
 		enable_tcs_irq(drv, tcs_id, true);
 	}
-	spin_unlock_irqrestore(&drv->lock, flags);
+	spin_unlock_irq(&drv->lock);
 
 	/*
 	 * These two can be done after the lock is released because:
diff --git a/drivers/soc/qcom/rpmh.c b/drivers/soc/qcom/rpmh.c
index 08e09642d7f55..62dfc7df93541 100644
--- a/drivers/soc/qcom/rpmh.c
+++ b/drivers/soc/qcom/rpmh.c
@@ -183,7 +183,6 @@ static int __rpmh_write(const struct device *dev, enum rpmh_state state,
 	}
 
 	if (state == RPMH_ACTIVE_ONLY_STATE) {
-		WARN_ON(irqs_disabled());
 		ret = rpmh_rsc_send_data(ctrlr_to_drv(ctrlr), &rpm_msg->msg);
 	} else {
 		/* Clean up our call by spoofing tx_done */
-- 
2.43.0




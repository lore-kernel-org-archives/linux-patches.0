Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86101BA86D;
	Tue, 30 Jul 2024 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354930; cv=none; b=HGpcd2V5BHdrT/81LiY0jl330wjmTe4SGgqO8hyAo8DsUjwpYxeWiwK8P04QuLnmEwM3YiRfokA8ggBALIWS9TsNmEBDjD9AXPT62nt1gZMHDbotA2aafBzpy/PH7u2q+0XDgg8yGJbirUSycDdDnSf4gikszLkLW4wVQH7JGDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354930; c=relaxed/simple;
	bh=gUskEjv3iwPI7V0Sc830sA2nVC4UJbHgmhvtGcLolnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWeThLutx3Z8IuNyXUzNc65SPtBlSvXQKMEj+jhxzM/7ZysWCaaR0h7SzVctmUcslLW20+HaDzD7BXYeGZgziZ/WivCGUuruIjC4upmxZhXvFR7kRWSqhb4o10bq+tmyuyZTgLMwIXx7UAS/bb24+0aqbB7pxwYVafKuvbeMcgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KR0FwjJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KR0FwjJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D0DC32782;
	Tue, 30 Jul 2024 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354930;
	bh=gUskEjv3iwPI7V0Sc830sA2nVC4UJbHgmhvtGcLolnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR0FwjJcnDgpnCBr35uI5p8NakzIJ0gwixd3TiALtnZJycGwBGue+tNU8yH81HC14
	 /fkEMeD0VbciO0y3nxMen6gEIumQc9UI67WK1vpCpd3aZGmbbxcpviLHbK05cNtdD0
	 n7ufehMn82sBg4IMG55O5W7XvXlvpirnYMrBb3H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/440] soc: qcom: rpmh-rsc: Ensure irqs arent disabled by rpmh_rsc_send_data() callers
Date: Tue, 30 Jul 2024 17:44:31 +0200
Message-ID: <20240730151617.251298574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 5e7bb6338707d..ff2b9eb9f669f 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -608,13 +608,14 @@ int rpmh_rsc_send_data(struct rsc_drv *drv, const struct tcs_request *msg)
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
@@ -632,7 +633,7 @@ int rpmh_rsc_send_data(struct rsc_drv *drv, const struct tcs_request *msg)
 		write_tcs_reg_sync(drv, RSC_DRV_CMD_ENABLE, tcs_id, 0);
 		enable_tcs_irq(drv, tcs_id, true);
 	}
-	spin_unlock_irqrestore(&drv->lock, flags);
+	spin_unlock_irq(&drv->lock);
 
 	/*
 	 * These two can be done after the lock is released because:
diff --git a/drivers/soc/qcom/rpmh.c b/drivers/soc/qcom/rpmh.c
index 01765ee9cdfb8..c6df7ac0afebc 100644
--- a/drivers/soc/qcom/rpmh.c
+++ b/drivers/soc/qcom/rpmh.c
@@ -189,7 +189,6 @@ static int __rpmh_write(const struct device *dev, enum rpmh_state state,
 	}
 
 	if (state == RPMH_ACTIVE_ONLY_STATE) {
-		WARN_ON(irqs_disabled());
 		ret = rpmh_rsc_send_data(ctrlr_to_drv(ctrlr), &rpm_msg->msg);
 	} else {
 		/* Clean up our call by spoofing tx_done */
-- 
2.43.0




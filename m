Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A337DA9E;
	Thu, 15 Aug 2024 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729197; cv=none; b=YV2/Vq8Ye3zFDuCkh2STKUp2uc5eqXIE4LaVdsgxVXKdWxokFXP/HXaIPxRZNv1AzUsMmLNixHpGG54lYobc5Dn9i2gdmUXV05uro7B7u5aw5atCY8dBD5AsD6Wrsc2hDvyVOSruNOnWXDGWCsrxk8vqGlanJ9DmNu8h0At1/80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729197; c=relaxed/simple;
	bh=CQ3+SbWz/GSPKcLbAG0sffZ1IEsg0U2Te2aasLqX2JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOYdhpXN90pUlSG6h+5LvnObKjkH5osY8cBhXsgaMXSkC+33qc0Uh0B4XUJJxyUDr3OlceIVS/EaeWJbRaiQTvYEi/0RQiy6rXirDZnZ/GQJv0lr36HK7MC5LfaAQ80bw27nP7wF+VV5RTD/A7bkqQKT4uBSoXixz+3X1GMazdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0P8A5tUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0P8A5tUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A1DC32786;
	Thu, 15 Aug 2024 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729197;
	bh=CQ3+SbWz/GSPKcLbAG0sffZ1IEsg0U2Te2aasLqX2JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0P8A5tUlfUhnQgVoFYcJAAjvji8oLvOK7QpG1dakLLLs2t2WXwi6Z7WT/sMRzPkOI
	 RyMsRIzU50QMnxBOaR07aUba2zHEg6VkVeSNW7rSEIAXD9x+cbBzKZkvzH25IOUJlm
	 izCiLkTY/5KIlLTG8w9jEB76cnnK0DLFIEXdPZvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/484] soc: qcom: rpmh-rsc: Ensure irqs arent disabled by rpmh_rsc_send_data() callers
Date: Thu, 15 Aug 2024 15:17:59 +0200
Message-ID: <20240815131942.092269364@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b722e28d9ed62..4c9400cf6686b 100644
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




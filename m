Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFC014388D;
	Tue, 23 Apr 2024 21:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908503; cv=none; b=Tuo1A5lb9h1vyh7RrMuVCF1rhEkWMRX52mwODvhOGQmwh334gOrlFHL1pcT93i/57aPx67sGre7FlVeNiEF73A+r0mQP9JfykxJMNfi6tfmqvrw+L7qQwXFjCgmYuo6EnzWN63ycZsjwpm0OcxjGfFrIUXEyixoMQQChVAvzh48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908503; c=relaxed/simple;
	bh=RWoi6TkMIzMpbkNifqAv8oi1m5n4aQ/OKdASaHusPIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwr1r2avn2578NcUHgPMw1GspAn/Z5g4zViNn7b0yzIdW76BxP38hS7XdOeJDEmDkGcUA/NrNvEnNbV+eDycekUzU7w1bieXF1LmVjdw3/GIBpaQOUywFoqSO3035Nt9qLFMZynrVogQ76yfZv4e+BKj7Siyu2FTNQsHw5GGR0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n14BeYCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n14BeYCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40155C116B1;
	Tue, 23 Apr 2024 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908503;
	bh=RWoi6TkMIzMpbkNifqAv8oi1m5n4aQ/OKdASaHusPIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n14BeYCVQr4PlGofABRbN9633lvilzva3xZp5Y4OuDWkkv89rKhd6UWDH0IO02Bn5
	 CsOZmR7sBTVQJlzoHj9CgrszT+cpCGUkenis9FpJERBaU26x2ToIQ1uxhJdR0jimDO
	 WCAirvFsTbup+OTJaKWMxeMiad+XDiX+D+yrlcVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 056/158] RDMA/cm: Print the old state when cm_destroy_id gets timeout
Date: Tue, 23 Apr 2024 14:37:58 -0700
Message-ID: <20240423213857.750661495@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit b68e1acb5834ed1a2ad42d9d002815a8bae7c0b6 ]

The old state is helpful for debugging, as the current state is always
IB_CM_IDLE when timeout happens.

Fixes: 96d9cbe2f2ff ("RDMA/cm: add timeout to cm_destroy_id wait")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/20240322112049.2022994-1-markzhang@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index bf0df6ee4f785..07fb8d3c037f0 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1026,23 +1026,26 @@ static void cm_reset_to_idle(struct cm_id_private *cm_id_priv)
 	}
 }
 
-static noinline void cm_destroy_id_wait_timeout(struct ib_cm_id *cm_id)
+static noinline void cm_destroy_id_wait_timeout(struct ib_cm_id *cm_id,
+						enum ib_cm_state old_state)
 {
 	struct cm_id_private *cm_id_priv;
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
-	pr_err("%s: cm_id=%p timed out. state=%d refcnt=%d\n", __func__,
-	       cm_id, cm_id->state, refcount_read(&cm_id_priv->refcount));
+	pr_err("%s: cm_id=%p timed out. state %d -> %d, refcnt=%d\n", __func__,
+	       cm_id, old_state, cm_id->state, refcount_read(&cm_id_priv->refcount));
 }
 
 static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 {
 	struct cm_id_private *cm_id_priv;
+	enum ib_cm_state old_state;
 	struct cm_work *work;
 	int ret;
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 	spin_lock_irq(&cm_id_priv->lock);
+	old_state = cm_id->state;
 retest:
 	switch (cm_id->state) {
 	case IB_CM_LISTEN:
@@ -1151,7 +1154,7 @@ static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 						  msecs_to_jiffies(
 						  CM_DESTROY_ID_WAIT_TIMEOUT));
 		if (!ret) /* timeout happened */
-			cm_destroy_id_wait_timeout(cm_id);
+			cm_destroy_id_wait_timeout(cm_id, old_state);
 	} while (!ret);
 
 	while ((work = cm_dequeue_work(cm_id_priv)) != NULL)
-- 
2.43.0




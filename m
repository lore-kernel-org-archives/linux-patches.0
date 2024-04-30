Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03712CD89;
	Tue, 30 Apr 2024 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474826; cv=none; b=DrGzvfH8QT4P1KIBdJe5xQ2zqkyj3xylgUdphDFi4rci13dAOYTMzfr8j2sFCxX+2n7VjVkbR+yIPIdybn/2VWBO9LOEMeDz1SVmysoE3gflxKj/VAG8qjld2m8qUNDPgMLMGUoO5Wvxx8DD94zMda4dk/tePuVJdEdVaCfPfFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474826; c=relaxed/simple;
	bh=c2iM7UdawElzJOWTItRUsiRmE2cpXgcJUl6pkyyHAvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVVrdzO1wcvFWekMnll7lFgpLP7NuMyG2YhdQ/xZmxAZwtQf+H1fb2KH5KPpZxgJ9gKOHsZhHRb3fQ8BNW0WIyH2k37QemhibVypMBSOs6Vu96hhO9lLuQ2DRFAjsaAzIssslIHjBwf9kMh9Z4JYeFffLVmVjcsCC3aXaKcvm0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xix+VeUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xix+VeUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0E7C4AF18;
	Tue, 30 Apr 2024 11:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474826;
	bh=c2iM7UdawElzJOWTItRUsiRmE2cpXgcJUl6pkyyHAvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xix+VeUKD3SUT4Rt3afxQVK+Gw7IA/wAuJ/HjFs83AJxcLqR00G4PfTGn/uzSZ3EH
	 2LBO2zbtQBiAVpmSCXHh7JcHsdk92eOaXOWZcGUM0j5Xkqw5lfpCqgxPF65Ccbdwmm
	 hiZ16k8tyxYdQd5jr1H742fOc36lFLJJ9iQVdQfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/138] RDMA/cm: Print the old state when cm_destroy_id gets timeout
Date: Tue, 30 Apr 2024 12:38:45 +0200
Message-ID: <20240430103050.612898742@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2a30b25c5e7e5..26c66685a43dd 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1057,23 +1057,26 @@ static void cm_reset_to_idle(struct cm_id_private *cm_id_priv)
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
@@ -1187,7 +1190,7 @@ static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 						  msecs_to_jiffies(
 						  CM_DESTROY_ID_WAIT_TIMEOUT));
 		if (!ret) /* timeout happened */
-			cm_destroy_id_wait_timeout(cm_id);
+			cm_destroy_id_wait_timeout(cm_id, old_state);
 	} while (!ret);
 
 	while ((work = cm_dequeue_work(cm_id_priv)) != NULL)
-- 
2.43.0




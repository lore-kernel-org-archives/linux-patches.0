Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42FC143889;
	Tue, 23 Apr 2024 21:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908597; cv=none; b=cEuSA++y848MlApAP0Nna1sBpcVjzC/2DBtyRmwq334KTSbZa43a+oIoH4NPhR0KeTIAvnh3rbZmZPUyrStfJ+h4j4VW+ypufuY65AD+DQ7T3vZ7LWCE4YYjLgFvtWpI+cKTPWg6V9ibY/C/isg1ke5gatijoHz1DQ1oEGShn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908597; c=relaxed/simple;
	bh=VxZqrOBIsctjGL+O+gvnjZaH/q8RzIQpKtjbrfpMzyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWvuYWsSy2PMvBRWMb6UwNmmZZ2di4xzySzvKyLDe/o9nKmbhtpbp5lVjgpLMwOvAghYJKdaKat6ADFBpts4M2wzO1v4oeHNahMBu69v/Ny8Qfybv/sNVDeHPhf45MFUr8rUuJGnfTYgp34QK4OUUKgM+kOJCdiNRYUiAJNa4po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ1OHd0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ1OHd0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A938BC116B1;
	Tue, 23 Apr 2024 21:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908597;
	bh=VxZqrOBIsctjGL+O+gvnjZaH/q8RzIQpKtjbrfpMzyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZ1OHd0wMOOEoWIdPAgQr/BDIuk5RTHOqA68rT7m2pDw4DTy95G1/baReMtHBF++s
	 oFKULb8xm5hmMHoLZNUiIsvhxq/Bai55SP/2f7iqGfqNhN5ts1S6Zz6SL6bLSk03Jd
	 WEO8pMD831cRo8+99tqI1A9ETmrG+xxJPto0yzz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/158] RDMA/cm: Print the old state when cm_destroy_id gets timeout
Date: Tue, 23 Apr 2024 14:38:18 -0700
Message-ID: <20240423213857.758293952@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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




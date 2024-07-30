Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC285183CDB;
	Tue, 30 Jul 2024 16:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356485; cv=none; b=MYJPqA1N8wvD4vNbNFxiTqflpw6q7Mh2sMchjYxgoGcHoTDb/icDs6j6q0AcF7YoeqexuIGWSRw59Pd1pp2rzCmMQ+9oxupNVPwcVkOb7QnCZN3vIjeZKjm80BtEe9p8HrIIrwy0oiBQRU0hAXqLmWRgXZ68WpBqYpndeyBy/EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356485; c=relaxed/simple;
	bh=Um1PxQHn4rCsHf5NiVZwr33nA5+u113Z0KHm+1WJ0Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogK/n30Z/JYdP1uRboPMAIOil2pJWL2jthcIZMvOMOj3pUaTXJincgJ7ygjxccPwcC+eY7IknyZJpy7FZlFz/I/zKSzH6Jrj7Aa7K99DJoUUuE6Tp6hBtXKUvDwJKEbFoajVYjqCwRbXYcfcNYRJ4Er2Zk/gWRbio3PNOCbeVas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IljODS2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IljODS2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C02C32782;
	Tue, 30 Jul 2024 16:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356484;
	bh=Um1PxQHn4rCsHf5NiVZwr33nA5+u113Z0KHm+1WJ0Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IljODS2ONRGwFowAh8WieRb9HldhrfwGSQNy1oDW9rhSAz2Sd8FkIIXUgOBuBqY7t
	 wrUQMG6BkrtkA+rGTpyREmqF1dBZtMu2fUnTo41m6tRDj1fmCvMoMa6i09OOY7k9za
	 8AlNgKoCqgMtnlqsbjhELN+7h4AdRlrRgSXjLEVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 154/809] wifi: ath12k: fix Smatch warnings on ath12k_core_suspend()
Date: Tue, 30 Jul 2024 17:40:30 +0200
Message-ID: <20240730151730.687428459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 33370412eced2dc7f81f4324e109d69319cafd82 ]

Smatch is throwing below warning:

Commit 692921ead832 ("wifi: ath12k: flush all packets before
suspend") leads to the following Smatch static checker warning:

	drivers/net/wireless/ath/ath12k/core.c:58 ath12k_core_suspend()
	warn: sleeping in atomic context

and also gives the reason:

drivers/net/wireless/ath/ath12k/core.c
    48         int ret, i;
    49
    50         if (!ab->hw_params->supports_suspend)
    51                 return -EOPNOTSUPP;
    52
    53         rcu_read_lock();
               ^^^^^^^^^^^^^^^
Disables preemption.

    54         for (i = 0; i < ab->num_radios; i++) {
    55                 ar = ath12k_mac_get_ar_by_pdev_id(ab, i);
    56                 if (!ar)
    57                         continue;
--> 58                 ret = ath12k_mac_wait_tx_complete(ar);
                                        ^^^^^^^
Sleeping in atomic context.

    59                 if (ret) {
    60                         ath12k_warn(ab, "failed to wait tx complete: %d\n", ret);
    61                         rcu_read_unlock();
    62                         return ret;
    63                 }
    64         }
    65         rcu_read_unlock();

But it is weird that no warning on this in run time even with
CONFIG_DEBUG_ATOMIC_SLEEP=y. With some debug it is found that this is
because: when system goes to suspend, ath12k_mac_op_stop() gets called
where then in ath12k_mac_stop() ab->pdevs_active[ar->pdev_idx] is cleared.
This results in ath12k_mac_get_ar_by_pdev_id() always returning a NULL ar,
and thereby ath12k_mac_wait_tx_complete() never gets a chance to run.

Fix it by retrieving ar directly from ab->pdevs[].ar instead of using
ath12k_mac_get_ar_by_pdev_id(). Since ab->pdevs[].ar is set at boot time
and won't get cleared when suspend, ath12k_mac_wait_tx_complete() won't
be skipped. In addition, with ath12k_mac_get_ar_by_pdev_id() removed,
rcu_read_lock()/unlock() are not needed any more, so remove them. This
also fixes the warning above.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Fixes: 692921ead832 ("wifi: ath12k: flush all packets before suspend")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/ath12k/7a96ca11-80b5-4751-8cfc-fa637f3aa63a@moroto.mountain/
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240511095045.9623-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 6663f4e1792de..527cfa3a01ad3 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -50,19 +50,16 @@ int ath12k_core_suspend(struct ath12k_base *ab)
 	if (!ab->hw_params->supports_suspend)
 		return -EOPNOTSUPP;
 
-	rcu_read_lock();
 	for (i = 0; i < ab->num_radios; i++) {
-		ar = ath12k_mac_get_ar_by_pdev_id(ab, i);
+		ar = ab->pdevs[i].ar;
 		if (!ar)
 			continue;
 		ret = ath12k_mac_wait_tx_complete(ar);
 		if (ret) {
 			ath12k_warn(ab, "failed to wait tx complete: %d\n", ret);
-			rcu_read_unlock();
 			return ret;
 		}
 	}
-	rcu_read_unlock();
 
 	/* PM framework skips suspend_late/resume_early callbacks
 	 * if other devices report errors in their suspend callbacks.
-- 
2.43.0




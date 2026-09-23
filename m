Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667F4340A6F;
	Wed, 23 Sep 2026 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174499; cv=none; b=KdrC0UaE0XEqKgfwUqjMHh5ZW26v1yqYILTANUhws7zYdD5IqvEvTAzIdOGJ4F0nm7ePzKFn0dGqPG1JD7md+Uzq3D4FoEPZVnTfRj0UPVBfpD8dONdhx+pE8dHayRK+7uEEHU1LZrfqW+hSG9ynaGoeZk8shPjYOnHOQFIbpjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174499; c=relaxed/simple;
	bh=VEuwA+8vfR3ZE1UOUI1JkMMzNEbm1z0HtIKkKDq1usU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo7k+4Gn8Ow7XGp7iUL82GyuAv8+Sflkh9bJxenVc6NEGj6Q3GAhjjd/qkhhaHW0+xzbXVznnSbnk46DjiXiSd/IyKdCHIdaIrcoJLAL16TKM2BufeHS7UQptTkSM6bdE3Y/SIM5rFegP3+VibocozOY9WOydkUpNRb4xJjQ71s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFArmKHV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFArmKHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94A61F00893;
	Wed, 23 Sep 2026 14:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174498;
	bh=rrPAvvmLVm42ffrXPxbHjgJJY4IbgcBywf5/UCIMdB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFArmKHV5EZGATTFTOkvpC3vpVL7VIYjgQobt4mMLEy5GOOIhd2th2BtqAhhJfUtR
	 Z7BTA7XQo1qU0i/MU4leF9+ZKCIFF9MzhOFEBUU/mNZ2j6qmjDfC05zbciSJFlGCrK
	 3R92b9x/5Jr/DTijcPFDStmQ9BQTGND7vbjWB3Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/398] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Date: Wed, 23 Sep 2026 16:03:27 +0200
Message-ID: <20260923140646.883787951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 621d90169cef6c8da5b6134db5c0c4e23cdd09ce ]

brcmf_txfinalize() decrements pend_8021x_cnt before a lockless
waitqueue_active() check. atomic_dec() does not order the decrement
against the check.

The waiter can therefore observe a nonzero count while the waker observes
an empty queue, losing the final wakeup and delaying key installation
until the 950 ms timeout.

Add smp_mb__after_atomic() to order the decrement before the queue
check. wait_event_timeout() provides the matching barrier. LKMM confirms
that this forbids the lost-wakeup outcome.

Fixes: 21fff75d2fb6 ("brcmfmac: use wait_event_timeout for 8021x pending count")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260811082702.44521-1-kmehltretter@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 169e62b9d7731..048b5d500215e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -555,6 +555,8 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 
 	if (type == ETH_P_PAE) {
 		atomic_dec(&ifp->pend_8021x_cnt);
+		/* Order the decrement before waitqueue_active() */
+		smp_mb__after_atomic();
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
-- 
2.53.0




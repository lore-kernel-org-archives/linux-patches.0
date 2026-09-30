Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FCC3B71B6;
	Wed, 30 Sep 2026 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791988; cv=none; b=ImQQ4eHWR7Tcfch2j1kjUji+4zQLjqVHRJ6Q299DiRaa3+AjUMsAasQH77E5VPWF4jcGg2Mnj984XqyH5XSG/goOcdcKOL4mpvF2NyWgMVgeSiQDMN37sb4i8TP7GlMw6F8F/FSLtYURWfXbQYq8QdmLhzEngbTWZ5LpuiTgtFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791988; c=relaxed/simple;
	bh=puuCs3Ua0xxD4d8k4UJi9UYrPhEoFDfga2y6j0eChEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7hTP9pUHslULQqqZq1s1lia7IUu+KIYHdHxczMu9xcH1ao7ypZNTOsSMiLcWoxqjHpwmbYjvlxtsB2pMLNK8IaiE8r8kmrsmBcLbxbvVCz3SqGKtkjINH1m+uF4impK/QHn1kFzPP5HYuekJ6hmTcVvYnKFIRONROdc9SyVcdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hz2EuM6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hz2EuM6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAB91F000FF;
	Wed, 30 Sep 2026 18:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791987;
	bh=cs/j7Y6Jl4zq8FvWXoEzm2Mek6RWhz7K3Pc6PC6ihRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hz2EuM6CaGc0EAOuK05SJMr1epBzdYEUv+pkPq2oh4E0YN4xEz5oVVh6M0NseRJZz
	 WZQSwTxHu1ZjL4VpKILYx5EUHC69Wol3ql29NXS6YCyKJmTSNBsjuT3riUq+nQKOqF
	 leVegVLCIJWWtNUOXOFBOwFakUwXcOfvmZiG/E/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 495/752] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Date: Wed, 30 Sep 2026 17:26:05 +0200
Message-ID: <20260930152408.976007893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 109c13189206e..860376037265b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -560,6 +560,8 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 
 	if (type == ETH_P_PAE) {
 		atomic_dec(&ifp->pend_8021x_cnt);
+		/* Order the decrement before waitqueue_active() */
+		smp_mb__after_atomic();
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
-- 
2.53.0




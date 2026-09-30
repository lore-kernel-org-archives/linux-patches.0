Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86AF5172F5;
	Wed, 30 Sep 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788429; cv=none; b=CwUwr8jjzJRFitUjMT54Xmv1Q92d3wqPnmnCnKPNx0BzRHLzdPW27cY2MKIjtDwLGE4KmtdEatr0CzfQlsXb9/sjOBkKgpTKrV/vJkzDlGfQYW6JDbdXhzfMf/3F8P1at8QkTkyNyK3iQD0c1TlrUX0STgvyPaIcdqKDPsiQzGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788429; c=relaxed/simple;
	bh=eDYJ/LguUj3m8kg/HzwYVnjPz3+rVMsOVgHpaMu1gsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhyUxZgPtEYqKcjMNuhVORs5dPsu/Z0N7GE/DuhiV3qkVzJOZPi0dzoOWUM0VvuK0RbZ09E3ZudmvoyvV1f+m8MBCVONZpmEX0VrLB74BWYl7/kBrR3TlLW/ntWqm9UorSiOftT6zmAg9qhtjTKekOrhK8TOuJPBtLykv7yw5A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm/25JL5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm/25JL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3C01F000FF;
	Wed, 30 Sep 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788427;
	bh=JO0g1DOGDl9IFwd0xYxP7XU48YcW56AaxnGdC1xos8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sm/25JL5BaW4E93Ii4quEINPsiaFIJxVhydztypfIwzPhM3j+vhnS2Pnx/FPWNZ5l
	 bTQVCz90eAnTACZbhOeCswt84JV39w2Wexrv6xI5X8IqE5lsPAlfBh7cePwRs3B5HO
	 0v0h7v+j+EfgNVInVw1Gh+Fcwm317zzYJgKOSTtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/877] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Date: Wed, 30 Sep 2026 17:17:13 +0200
Message-ID: <20260930152417.370593186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 58eaf08a147b6..f99accc34a36e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -550,6 +550,8 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 
 	if (type == ETH_P_PAE) {
 		atomic_dec(&ifp->pend_8021x_cnt);
+		/* Order the decrement before waitqueue_active() */
+		smp_mb__after_atomic();
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCBD3E0082;
	Wed, 30 Sep 2026 19:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796118; cv=none; b=daAqo5hA7VAiTp4J8VsIQz1wBoyrlv4VtmWeHFUaEu8gjDLqJAUWx2M+xlvdTo0CwS8YxDK/9C3KtBXkq1ahby/UjxBbY5zsH+X1kmq48h6oMPEBEqWVFwAzw+eqfwbnMps/A6kKx6I4m6o2u9tkCNO0Mz51jBWmDx8U80JVD44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796118; c=relaxed/simple;
	bh=Iv66WsBpI9fRU4ZjpK+ZPHoG1GRCF5pOWK6KW9AIUNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLpjbIdD0fzYDsbVY8Y3Ae8bMNH1LzhbgNDxBgkoA0eCGuuLfUYwkX8UYfx1W23jQqcgM8bXIul/HZZiQ4oRsdnm2JFsgtpB33HGaRHpfowvAcKOM99wB/8fAXU/rlh793Jeg+o8dPneM+glZVsA1QygIdh/ngkiCly7tYur9nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHYtGtSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHYtGtSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F461F000FF;
	Wed, 30 Sep 2026 19:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796117;
	bh=/TC2AmwRvij7cmLADi75EydAlFN7YEzn1D6kTv4WDmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHYtGtSFFTkf3NU/BV1BoY0VhgtizLEtxA9TPqaR9JjrISn0OeHGgx6UJv9mBBAGA
	 KLqnzXSOx+4x/Mkbm+qh0vSJnbWWmY8xjBNtdyKwDviBS4FJAs2r6Q3l8IKW2Tjlu3
	 hm+PNU5f/dyKl+YNXXaUkiaLm/IXNE/pZuzrFrbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0798/1193] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Date: Wed, 30 Sep 2026 17:24:42 +0200
Message-ID: <20260930152451.975732424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fff7a3ace5c45..17be8fcb5ab14 100644
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




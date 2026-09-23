Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74524189DD;
	Wed, 23 Sep 2026 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173160; cv=none; b=EfZIF101GdP+BUumTjzRCDtCYibMHTDUMWrHPGZWG2jnCy1zQtpyNWvschQBvsBtJLcxm40O52MrPAgmd+1Hfwei0Ay748xVFXWEGGjdsCGErjU9lxuS4IMsb5ZJJwVStoR0U3wlXNK7HgzSc1zh8S9uLYt12F3buteYYOSsnvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173160; c=relaxed/simple;
	bh=TgMkk4Yg/j822cnaulaCtK/DzQ02CCcYmXvueAJ5V8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gG84QavJBaoPjcPC961Pt0KYz5tvKeWaV2p9ZFtqVN53aWKX6ku18yzeqHwxB5hoxfkiSpikPlN+LYx+/Cfjx3WOlsVmte8pI2Ed89nLu/4pyDLYWZo+dlpakiQ50qqKhDGx5OD5Oz4XrVJ1GyHTL17T4VBeThinzpiL13sDHys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNVnNRBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNVnNRBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272CE1F000FF;
	Wed, 23 Sep 2026 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173159;
	bh=EbaUMlYuVu8bXCitawkjjvLyiLwBF14U65KmqTnmZ6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNVnNRBC4TEgw2XzrtT4ZOf3Wxfb1O935YvG9V+UbtHYjAlwNjJtHw3AOA3xM4BP2
	 ekTlWBpy4q1RPe/ovVLRVOYFfbLUO+xVB+NCHdAzQNEk8maPYf0jJJVymFPooUUf66
	 cPX7zezPCqZM1jSBscULNm7icDQ9vxFg8V6cBW7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 160/438] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Date: Wed, 23 Sep 2026 16:03:01 +0200
Message-ID: <20260923140648.917787642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index dad6f4563d146..d2ae679856067 100644
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




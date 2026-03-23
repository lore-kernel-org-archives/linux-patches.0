Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727433A960E;
	Mon, 23 Mar 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282344; cv=none; b=BMQv6DjujExGFCIq8lcu1ekbH4eDBuTq33Cyvbnms5ixLfiHFfCPl2l1QAREcvcg003dWo0VQorinrQjB8Rvq752Iq2Qcf63LhGO1jzdi5wPharACu/S49wmNwVCj6UbcP1eIVZxGG5E9xvojBvQA/7jbyqYlj4Kq16+mocAgwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282344; c=relaxed/simple;
	bh=/5iDdpVPIauM17IZjqhcRSJb4mOzuhgqVhTRt7AZ6pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhhrV6STS2OKpYCOKI15tfwnPI5K9/OeCOqhk90BJcvfa3gnUlEjaJBdN2Uwn7TufmnjO7aXoCaUkjq6TOEs1RHkfYWn9475Zk58Zwbs96lB5YGlu+nAcgYQhkOHziIq/XtN9SblGhxSVq7LTuRYNfB5UEgfAu80mDlAQdpREwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJH+oGYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJH+oGYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D7AC4CEF7;
	Mon, 23 Mar 2026 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282344;
	bh=/5iDdpVPIauM17IZjqhcRSJb4mOzuhgqVhTRt7AZ6pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJH+oGYtg0+JV/MRxG5D5XPJcjEPkckkSB8PqzYgOC6fKrKSVoHh/uj7/Q2eYgyjR
	 eBTCSR74i9/+lmv1x9t1mslGAS9uz+MR1Xa9cClH+vDjX4zxqO5IVVE8x9lCZyTNyY
	 3NZa7QEQw2BEyuCA4fbjn6so4jSmQdXFVxnx4Moc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/481] wifi: cw1200: Fix locking in error paths
Date: Mon, 23 Mar 2026 14:41:43 +0100
Message-ID: <20260323134528.232015992@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d98c24617a831e92e7224a07dcaed2dd0b02af96 ]

cw1200_wow_suspend() must only return with priv->conf_mutex locked if it
returns zero. This mutex must be unlocked if an error is returned. Add
mutex_unlock() calls to the error paths from which that call is missing.
This has been detected by the Clang thread-safety analyzer.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223220102.2158611-25-bart.vanassche@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/pm.c b/drivers/net/wireless/st/cw1200/pm.c
index a20ab577a3644..212b6f2af8de4 100644
--- a/drivers/net/wireless/st/cw1200/pm.c
+++ b/drivers/net/wireless/st/cw1200/pm.c
@@ -264,12 +264,14 @@ int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		wiphy_err(priv->hw->wiphy,
 			  "PM request failed: %d. WoW is disabled.\n", ret);
 		cw1200_wow_resume(hw);
+		mutex_unlock(&priv->conf_mutex);
 		return -EBUSY;
 	}
 
 	/* Force resume if event is coming from the device. */
 	if (atomic_read(&priv->bh_rx)) {
 		cw1200_wow_resume(hw);
+		mutex_unlock(&priv->conf_mutex);
 		return -EAGAIN;
 	}
 
-- 
2.51.0




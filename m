Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2143313298;
	Mon, 13 Apr 2026 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098746; cv=none; b=s+6oard+YkUU9vk18ozV5tqlUDU/AEFZrjM+8yQ+q5cSO3UWQgIEsNLTtIYTzwJlOtWzgqFmPVMvdrdXpABdHfmmTThYHTu5EzRWqA8/lvfbGfZ4ORDQrs9c84DpQtBWdL+02cBKQ3UAusgw4pnwMlF7y46uaHfj0oGu03nrgL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098746; c=relaxed/simple;
	bh=dFOI6iDAXTIrPlsbLIDcvanXidpMofsXaC7rz8n/IL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7NoF/tAQfwpXFSfplJvwllbtP+VIetaATMpkz17f1eQpDRKZ9t4JWHf3e6Gb9mEScaLCrMsWXy37HW5DT7bZaL9F8Leo2/x12yDek7fCk4jFKbp+HibQrIRxqXOxVjZ81j/bR7HijIoiBR9RX4i/yvJJGzAZc9UXhq2PziVbZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdzkDXe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdzkDXe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B01C2BCAF;
	Mon, 13 Apr 2026 16:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098745;
	bh=dFOI6iDAXTIrPlsbLIDcvanXidpMofsXaC7rz8n/IL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdzkDXe9XrdcpTxhsUdClqMwBdU8m11TeBPnB7S15emZ4YnRDgemzLoIYQqvR6TmW
	 qWSjzGlVbmPCFTxGp8YInxv0QAfyGLd2VmR+S5TxjeAp1o9Xb/5Ss4JWmj/u/VS4Qr
	 WJ8EqHOobyFhAYLt7Z3k9i9sKRwH5Thsh4aS+cF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/491] wifi: cw1200: Fix locking in error paths
Date: Mon, 13 Apr 2026 17:54:45 +0200
Message-ID: <20260413155820.553917826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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




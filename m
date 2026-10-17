Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C83939A4;
	Sat, 17 Oct 2026 18:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260123; cv=none; b=U61bYKqolvjMPcjP61pFlRKQewK6uFH05rTJJY4T2E1j4S9WxO3xUrNMUWp3y9pro/cnSB1jIhJlmzRLb3zoTb9dVuIwHBAAYVsVXjhN9qoi5yzahMoGND4sV7zwWQOJHc8qUXhdENmm/17Gc7gwpFQ1RfWttke+MD68wVZ5EBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260123; c=relaxed/simple;
	bh=UCfcFIemXbsCs0/nT0AFbyza1OvJXMMFVVMbTkwJstg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltBQcd1naUbLOqrmAUq+nM7PcLCL/UITpq6lHQmQsdb3ApVNty3lgbYRbwaGUXeGeWzINV0X56/4OlyKzoZg9lJf1bADPav9bfeQQgp89v5iXlpZMCofXW5B0Q0H2r0C2zQcaj23mIHQEzMSG9Pta/7gFkE3Tsyz7w5WyGc5+nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgJp5ZY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgJp5ZY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FBB1F000C4;
	Sat, 17 Oct 2026 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260122;
	bh=rjv9EOupQeK6JgbgHGXcbxsclWWXG6Xoo0SAlafUmcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgJp5ZY/rp12x2bAIbG21pbNV7KQ05xJrPIeaaUQlBazrTEqnPJ78AR2IV5x1GX9M
	 jYCi9BSv2bjYw7eUh0iGt+AMp23WGDqnbjf8Li7IBfiKkOxNYGaMZTeD3elshVK237
	 Tg8i6aTVeMQiO6NDB4TC8ibd3WANwiPqpvumKVs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1440/1674] wifi: cfg80211: stop PMSR before P2P and NAN teardown
Date: Sat, 17 Oct 2026 18:01:52 +0200
Message-ID: <20261017160508.142709500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 6c5fc504d0d6934132637aa3db4b9b58148eaa78 ]

PMSR request teardown must abort active measurements while the
wireless_dev is still present in the driver. cfg80211_leave_locked() and
cfg80211_stop_pd() already do this before invoking the driver's stop
callback, but cfg80211_stop_p2p_device() and cfg80211_stop_nan() do not.

Those helpers are also called directly by nl80211, rfkill shutdown, and
wireless_dev unregister paths. If one of these paths stops a P2P device
or NAN interface with a pending request, it removes the mac80211
subinterface from the driver first. Subsequent request cleanup cannot
reach the lower driver's abort callback, but cfg80211 frees the request
regardless. Driver state can then retain a stale request and use it when
it later reports a result.

Call cfg80211_pmsr_wdev_down() before stopping the P2P device or NAN
interface. This keeps lower-driver request state and cfg80211 request
ownership in sync for all of the helpers' callers.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260731071103.73563-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 622192eeb7834..164277e81234b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -237,6 +237,9 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	wdev_lock(wdev);
+	cfg80211_pmsr_wdev_down(wdev);
+	wdev_unlock(wdev);
 	rdev_stop_p2p_device(rdev, wdev);
 	wdev->is_running = false;
 
@@ -262,6 +265,10 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	wdev_lock(wdev);
+	cfg80211_pmsr_wdev_down(wdev);
+	wdev_unlock(wdev);
+
 	rdev_stop_nan(rdev, wdev);
 	wdev->is_running = false;
 
-- 
2.53.0




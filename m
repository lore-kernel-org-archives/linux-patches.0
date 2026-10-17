Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CEA3A0E85;
	Sat, 17 Oct 2026 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255110; cv=none; b=Hxs/hfPygYtmZRAy9i/ALZyWsx7vGIXrRiUkusZNv68jpalqOUE+N/Vk+MxLhoa7H16/4JOhGWXqvDic4zBPTTjfyJNfD02K8Y3JHEplfF6MEN8NQvkSv4+E5B1XclqcmcpEqypuckZYf3zYTVu92L+dDt5BVUQ2ynCVjMhcQGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255110; c=relaxed/simple;
	bh=07uDVWhmSdjiqewjfgqPuSF4oYmdYf4BEhQu1ptfZhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie/myeHLmRQ01AKrmkVHme2x9vo8AbY/9bzS93Upv9Uyh9S3WlgdRX02+wzEzGFLLq2eFqnaLrlvvK7OWsYntJLGAi3t61MPoY6avCZjKtLoQuHCOny4w+QiibgbePGhx1d8B/jHF//J5HZ2Q+jL+vYrVKI3+7qPXX2k61Mnej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YYIFdmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YYIFdmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BCE1F000C4;
	Sat, 17 Oct 2026 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255109;
	bh=DU5cynr2IsYJLuLBpbX8oMQg3+UIOA1yS+x/wg8Q9gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YYIFdmPQ+IAShVXMzBBuAiLUN0GounQKQjn+dtbMCo0WkyRmp7x3cdav6RbVgvxM
	 +UuATmQqAuKcAj3DV10hmsHBsTHLc9SMSH0+mIXTTdeOSn4FOMnRlxBOYtNQQ8Jagf
	 giobS5PXU5q5Xzu4a5RqAHa+g2sRKvuKc+7+zHB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 669/869] wifi: cfg80211: stop PMSR before P2P and NAN teardown
Date: Sat, 17 Oct 2026 17:58:30 +0200
Message-ID: <20261017160054.142414982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 net/wireless/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index e4b7917455fb4..c485cd6fbc825 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -237,6 +237,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
 	rdev_stop_p2p_device(rdev, wdev);
 	wdev->is_running = false;
 
@@ -262,6 +263,8 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
+
 	rdev_stop_nan(rdev, wdev);
 	wdev->is_running = false;
 
-- 
2.53.0




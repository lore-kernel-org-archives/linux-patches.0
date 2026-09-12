Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B49374169;
	Sat, 12 Sep 2026 08:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201310; cv=none; b=qf6zRE9uPqfKoX5SGm308/Qu/LEAKBWOIxnY64Or33+pyjlBNcXYAlehzf1IK2Qv49LGbQb1PM6y/5Lo3VBe14rQyG9Afrd4axFRq+VJ30dLGCL8sovSRnAINd0J5L+BbNysMY2rcvjLT9EnxS80g+2+aJRBFc5vkv2ZnCB3ASw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201310; c=relaxed/simple;
	bh=dw3YZqmr3EEb7gPL4zh/lg7oGas7g1XMjBNBXAad8po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTTPHAoltAohA+toSOZumtvlKPUSZpSWU7f6UNx2rxxxQ+aVaYDo7XHuErC3AM0Oa2yVY4JNFyCrl4UCCOKFKnUHUJyA9CMikqQqKKl8ZIGaI9Hwi69bw5jITD33ZgkHaBESkY2KdxNSnvr+1hx+nNnRVkFWWUeQ3p7QNSDhU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a78fSpl2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a78fSpl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890BE1F000FF;
	Sat, 12 Sep 2026 08:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201309;
	bh=+2iAHcs9vcvSoSf06FQ0n4oa04j+pc0rTvUGtlIGO8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a78fSpl20j0Ga3vo1mJFEqWPvoodddBRIH/y6T+ZhpNm/fS+5hqmW61kXsfjQa+aJ
	 Z4mQ4aCXRS9geAgoDcMWe/FnpqfEo0AVIhJcPj5XXdEjb6nnFiSr5eZVZVdTVI6fxL
	 8HpVKmMTpi3snwcRfy3TPeY/43ZxtQNavE8PXzn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0971/1815] wifi: cfg80211: stop PMSR before P2P and NAN teardown
Date: Sat, 12 Sep 2026 08:45:21 +0200
Message-ID: <20260912065711.771488013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 610238d723fff..d13310fef691a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -237,6 +237,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
 	rdev_stop_p2p_device(rdev, wdev);
 	wdev->is_running = false;
 
@@ -264,6 +265,8 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
+
 	/*
 	 * If there is a scheduled update pending, mark it as canceled, so the
 	 * empty schedule will be accepted
-- 
2.53.0




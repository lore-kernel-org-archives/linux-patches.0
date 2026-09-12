Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7122E427A04;
	Sat, 12 Sep 2026 10:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209471; cv=none; b=IfFtQjX1d/pN4YBNHKHtZEQQRJqoJH98Fuci+0Dr9B6ECJf/guUV+vAnXvQdFUT3vCP4L8Be6zG1s7IegP62cim1c2zUHLfWmB8RSa10EJ/9Deq88hQ1K1dvlHyhQQPd02+107SQw58BLydk26KvaV12xcVDF2lrJq2ZHjGti00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209471; c=relaxed/simple;
	bh=JpFA30usgsEVV6aY1JTsmzbyWqPYcVyqrMsZm8nyhrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sz5kBIhSeFHYVg+Gq5TWBj2mCYMPvEHYzes/23EozLWiZPTEQbhZVJkKrA45Zpi/CJ7cMvFml+47M7ZfxdVu09RmGlqjs+4lX30DffSHuo2zkq4OFsz+7mAfULDegp3AYH8x0oROJhaNMJA7uIBOA0EwrxkpXTN5ywwbD2yqaYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRoiseJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRoiseJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE7D1F000FF;
	Sat, 12 Sep 2026 10:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209468;
	bh=nhEq8ExrO53vosMLUZr0eFSTa2n10vuVDAnxxFWD8ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRoiseJSyNXi/MKWTiPFLZDtZmoKLrqNPDQiflCLaGuuQdoGSv9WbG4+PgfwYds1f
	 bMYJSMLtOqcswR5waq/dWpVXI2SgKh5wqupOjEiZS+iOwO/1HEwRnf434tncOS0hk/
	 7rLizotmI9lK7OnCVCyCfwH3eXKlgkvlZJI7cLKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0825/1518] wifi: cfg80211: stop PMSR before P2P and NAN teardown
Date: Sat, 12 Sep 2026 08:49:54 +0200
Message-ID: <20260912065642.102540954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 4d4c42db732e9..6a9ba151b09fe 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -234,6 +234,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
 	rdev_stop_p2p_device(rdev, wdev);
 	wdev->is_running = false;
 
@@ -261,6 +262,8 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	cfg80211_pmsr_wdev_down(wdev);
+
 	/*
 	 * If there is a scheduled update pending, mark it as canceled, so the
 	 * empty schedule will be accepted
-- 
2.53.0




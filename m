Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D558286416;
	Thu, 27 Nov 2025 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255046; cv=none; b=rmyYAQrx11gMT+FXxZ6BXPJi2cOn9t0u414sLydtHFuzyvnpaWFOToIAV3gVtfWUaiZVhys4GBRqPvsQ4U7xF32dMCgntlN+IhYQ42vCr+InHvesJMRsNhu9h1lANCBPfhw2TgevD5xJPJ9YiOcUlqU+RjqGFQ+5iiOSXnu+W8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255046; c=relaxed/simple;
	bh=mdzEY10yOLChqDl6eWQ5CSpWxh3PRAUCDIuYGHj4Xeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT+YN+/1rHqdctnhAVmOXKf7KrCTbTIKif7qgShCRhuw/D2E1/vegoRReX+pBV+QGAVLtGZrqpMH6JISXFcMf15CHvMJ4nh+58FW1k6OD02BA6Pbs2asPAixXGu2s4z1eLsvTycIMBC7Ax9yP5EDkFpb3DNPyzlWZecfaAFxRtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INeVCx3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INeVCx3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2816EC4CEF8;
	Thu, 27 Nov 2025 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255046;
	bh=mdzEY10yOLChqDl6eWQ5CSpWxh3PRAUCDIuYGHj4Xeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INeVCx3i1nJ2VsNtqwggR5oH4whOQ2yo+c6/+eumCGMXsKo+28Pwp+GPnplGlDvrs
	 7IF8wyOoqLLVvj0+MsgGUn6AZXCSly/ZjWL7iXi5klifY7KYJiovLi8y5WxTxTYjtm
	 3UyTDo7Y/OT83pu0FCaURxHGZlv116frX4PXxe3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6 76/86] wifi: cfg80211: Add missing lock in cfg80211_check_and_end_cac()
Date: Thu, 27 Nov 2025 15:46:32 +0100
Message-ID: <20251127144030.605824387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Alexander Wetzel <Alexander@wetzel-home.de>

commit 2c5dee15239f3f3e31aa5c8808f18996c039e2c1 upstream.

Callers of wdev_chandef() must hold the wiphy mutex.

But the worker cfg80211_propagate_cac_done_wk() never takes the lock.
Which triggers the warning below with the mesh_peer_connected_dfs
test from hostapd and not (yet) released mac80211 code changes:

WARNING: CPU: 0 PID: 495 at net/wireless/chan.c:1552 wdev_chandef+0x60/0x165
Modules linked in:
CPU: 0 UID: 0 PID: 495 Comm: kworker/u4:2 Not tainted 6.14.0-rc5-wt-g03960e6f9d47 #33 13c287eeabfe1efea01c0bcc863723ab082e17cf
Workqueue: cfg80211 cfg80211_propagate_cac_done_wk
Stack:
 00000000 00000001 ffffff00 6093267c
 00000000 6002ec30 6d577c50 60037608
 00000000 67e8d108 6063717b 00000000
Call Trace:
 [<6002ec30>] ? _printk+0x0/0x98
 [<6003c2b3>] show_stack+0x10e/0x11a
 [<6002ec30>] ? _printk+0x0/0x98
 [<60037608>] dump_stack_lvl+0x71/0xb8
 [<6063717b>] ? wdev_chandef+0x60/0x165
 [<6003766d>] dump_stack+0x1e/0x20
 [<6005d1b7>] __warn+0x101/0x20f
 [<6005d3a8>] warn_slowpath_fmt+0xe3/0x15d
 [<600b0c5c>] ? mark_lock.part.0+0x0/0x4ec
 [<60751191>] ? __this_cpu_preempt_check+0x0/0x16
 [<600b11a2>] ? mark_held_locks+0x5a/0x6e
 [<6005d2c5>] ? warn_slowpath_fmt+0x0/0x15d
 [<60052e53>] ? unblock_signals+0x3a/0xe7
 [<60052f2d>] ? um_set_signals+0x2d/0x43
 [<60751191>] ? __this_cpu_preempt_check+0x0/0x16
 [<607508b2>] ? lock_is_held_type+0x207/0x21f
 [<6063717b>] wdev_chandef+0x60/0x165
 [<605f89b4>] regulatory_propagate_dfs_state+0x247/0x43f
 [<60052f00>] ? um_set_signals+0x0/0x43
 [<605e6bfd>] cfg80211_propagate_cac_done_wk+0x3a/0x4a
 [<6007e460>] process_scheduled_works+0x3bc/0x60e
 [<6007d0ec>] ? move_linked_works+0x4d/0x81
 [<6007d120>] ? assign_work+0x0/0xaa
 [<6007f81f>] worker_thread+0x220/0x2dc
 [<600786ef>] ? set_pf_worker+0x0/0x57
 [<60087c96>] ? to_kthread+0x0/0x43
 [<6008ab3c>] kthread+0x2d3/0x2e2
 [<6007f5ff>] ? worker_thread+0x0/0x2dc
 [<6006c05b>] ? calculate_sigpending+0x0/0x56
 [<6003b37d>] new_thread_handler+0x4a/0x64
irq event stamp: 614611
hardirqs last  enabled at (614621): [<00000000600bc96b>] __up_console_sem+0x82/0xaf
hardirqs last disabled at (614630): [<00000000600bc92c>] __up_console_sem+0x43/0xaf
softirqs last  enabled at (614268): [<00000000606c55c6>] __ieee80211_wake_queue+0x933/0x985
softirqs last disabled at (614266): [<00000000606c52d6>] __ieee80211_wake_queue+0x643/0x985

Fixes: 26ec17a1dc5e ("cfg80211: Fix radar event during another phy CAC")
Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Link: https://patch.msgid.link/20250717162547.94582-1-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ The author recommends that when porting to older kernels, we should use wiphy_lock()
and wiphy_unlock() instead of guard(). ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/reg.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -4208,6 +4208,9 @@ EXPORT_SYMBOL(regulatory_pre_cac_allowed
 static void cfg80211_check_and_end_cac(struct cfg80211_registered_device *rdev)
 {
 	struct wireless_dev *wdev;
+
+	wiphy_lock(&rdev->wiphy);
+
 	/* If we finished CAC or received radar, we should end any
 	 * CAC running on the same channels.
 	 * the check !cfg80211_chandef_dfs_usable contain 2 options:
@@ -4231,6 +4234,8 @@ static void cfg80211_check_and_end_cac(s
 		if (!cfg80211_chandef_dfs_usable(&rdev->wiphy, chandef))
 			rdev_end_cac(rdev, wdev->netdev);
 	}
+
+	wiphy_unlock(&rdev->wiphy);
 }
 
 void regulatory_propagate_dfs_state(struct wiphy *wiphy,



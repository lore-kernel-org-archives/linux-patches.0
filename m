Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563A734252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301761; cv=none; b=CH4HIR9PDK9WArIXd4JZx5CxyWaiTehcF9ftJnuVfTrSK83TO9wH40tOBT7C9cpZ7ClZHdvmTTqFdGkjH1m1LI601pCFWp0KdIaTqN9z4S2l+9GW+vr9AIOGVum8EtYL2uesOWMR+zwDfiFbMz1pHtE6fY1vFGklG9PAIIy6Hh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301761; c=relaxed/simple;
	bh=UCU+Gy8rfzAW8xNkS+hISUNeGE3F53jxUfLxWgSQJWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvRAy6jYc0dG0CAET007ZjDfAXAUs7VcNE77mP102x6awzyPt7Cs7HpjxgjFXREyvgns87P1YPkNxIyUtRNWxOwg4szD4/qf+xERt7WVlpjUk6tGKBJkFT+qZ2akXkQ2WYs4Z5YTd8JaXwgswXpIGpWT4w9sZo8+rBwj91eUC0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MP+Wf/zQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP+Wf/zQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2C3C19424;
	Sat, 28 Feb 2026 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301761;
	bh=UCU+Gy8rfzAW8xNkS+hISUNeGE3F53jxUfLxWgSQJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP+Wf/zQNPYUMPycROGGPClxLGF8+EYjDmFPhBls3961KtIqZJGC6ZC51nJVnIpIl
	 iVDPCW6nGCM4DftzWjt/rBxWNi4JIXT3YL/th1AVtXNITGMWLgLV4ZfU4CiJCXi0V0
	 mNM9kElKFBqlKaOD2k13oBrYlMjOzCh1slPlGzqyImZ+3B0X6vqWrHrX4a+BPqDy1m
	 s0mdeEp7Hb6EuqCHNW/WhFaeq03dNallaPiY3UAzviY1r4z0sVVguO06uE2pGoK7QA
	 NOenM171ITkzPe+C59hL7d4zUORaoQ6DTAZRwNzs34yEFTo7m0yFjeiwrGQW50r4Zu
	 zUj/1LraD0xDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ryan Lin <ryan.lin@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/385] HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients
Date: Sat, 28 Feb 2026 12:56:28 -0500
Message-ID: <20260228180011.1568201-166-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ryan Lin <ryan.lin@intel.com>

[ Upstream commit 56f7db581ee73af53cd512e00a6261a025bf1d58 ]

During a warm reset flow, the cl->device pointer may be NULL if the
reset occurs while clients are still being enumerated. Accessing
cl->device->reference_count without a NULL check leads to a kernel panic.

This issue was identified during multi-unit warm reboot stress clycles.
Add a defensive NULL check for cl->device to ensure stability under
such intensive testing conditions.

KASAN: null-ptr-deref in range [0000000000000000-0000000000000007]
Workqueue: ish_fw_update_wq fw_reset_work_fn

Call Trace:
 ishtp_bus_remove_all_clients+0xbe/0x130 [intel_ishtp]
 ishtp_reset_handler+0x85/0x1a0 [intel_ishtp]
 fw_reset_work_fn+0x8a/0xc0 [intel_ish_ipc]

Fixes: 3703f53b99e4a ("HID: intel_ish-hid: ISH Transport layer")
Signed-off-by: Ryan Lin <ryan.lin@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index fddc1c4b6cedb..03c68fe40925b 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -730,7 +730,7 @@ void ishtp_bus_remove_all_clients(struct ishtp_device *ishtp_dev,
 	spin_lock_irqsave(&ishtp_dev->cl_list_lock, flags);
 	list_for_each_entry(cl, &ishtp_dev->cl_list, link) {
 		cl->state = ISHTP_CL_DISCONNECTED;
-		if (warm_reset && cl->device->reference_count)
+		if (warm_reset && cl->device && cl->device->reference_count)
 			continue;
 
 		/*
-- 
2.51.0


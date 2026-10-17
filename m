Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6681617BED0;
	Sat, 17 Oct 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258628; cv=none; b=efXbMQZZ38SV1EQ+Kzx19mU8wxjsCoeQIbX3fQ7ml/+Z5FqjOqAigz/xTEEDhks6di73JrkdJ/9MgTKJFNeKVHBegOkQQ+igYVmTmui1wLueDUB+FKJwlPheSpam/uHE0DbnltsXf0QJhII4Ax6uDMWtOiQKAaCxG4/dwtjXzgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258628; c=relaxed/simple;
	bh=g7UJpycJTSa/lEjrC5n5MfLtxqPDjEEjAcf0c2eaysI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hn8E4FOa60iIjyGsS5j1VajTlfuBXH0TOfbxzEnmKOYlFNt4KoGTJ8vCkxtpWT9QsOgSVotoXTYWyzgf6UJl621pBxdVGkkSdhNNmOvMmvIdGIrpX2zMo8loOpEHo2zKxlsoANWTkZPBT+yIJJ5jViHUx9qvEOTh6zQ/s6vdDBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OR7pKXTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR7pKXTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527451F000C4;
	Sat, 17 Oct 2026 17:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258626;
	bh=UfZIXFYFI2olp1y8crKDhJxL1s5E+YkZekTRTx7BqMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR7pKXTnE+nuqayf8qDzUj7TAZlpZr8fncNqv9j7HljRmclcADY7o8HJfIM5nFLwz
	 vwVtVZDj/LnwVHs0pLtuFxOakmSlXp+4D1q9KP+OdKRP7sz5tl7o9r9JvT5+PRFkkG
	 Cxe85ERUE8IsQCrvT6r1OeEZLwPvYKqtW1H87WrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lin <ryan.lin@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0947/1674] HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients
Date: Sat, 17 Oct 2026 17:53:39 +0200
Message-ID: <20261017160455.441391016@linuxfoundation.org>
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
index 465c419a1854d..8d00b2816c81f 100644
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
2.53.0




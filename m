Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1957C3B27C5;
	Mon, 23 Mar 2026 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279184; cv=none; b=pp/7herqg1UkFWZqTxxydtb3DUv2Ctsft7dgdzKkhVjP0IZ0H4OOKfMWwk96ty+skh7TCeGOx83NQ5VRUzBmhZHl9xl+v6txRvBc/MPQEiqH1Qfzj58djtwp0n8VbAEKMMDlYQyZygaRuQRpIs8RdM7vYzlPv56CLbMBR36FdSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279184; c=relaxed/simple;
	bh=yoi5MY8NK5ODONtnO2k5oBNLRdVT688KhTaC5xdItxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEtRhtyQDM3iJz5Yc9nxDKgf2CpBab0778V9IPnjkU9xJ8wd1AF1tmLGXnJxt/6yfc/P2LFiksxmjIMLJ+ZinTWGDhMWXFE8lsyIJMgXJPvG4ar0aERkwTaNihH78xBiOsY8hLm7nLYg0+N4/junjikyX7GfOCTBqGgR+Q3S34M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eb1+OGZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eb1+OGZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5992CC4CEF7;
	Mon, 23 Mar 2026 15:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279183;
	bh=yoi5MY8NK5ODONtnO2k5oBNLRdVT688KhTaC5xdItxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eb1+OGZBBb/gZ6brVMLmiNwFm1SUTRj/FEJMvrWMrPtICQhSOjDaQV1GXAMKw3a+u
	 ppQHZzNWt6L32khGmiMt1rn4d9NJ9JwpRLDp1rmNgYO7KIih8tl8iiuA+Pvim30Reg
	 d0+SL9PnBout3W9n4hfqglqX0xXijojbtvjddxtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 501/567] wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down
Date: Mon, 23 Mar 2026 14:47:01 +0100
Message-ID: <20260323134546.417852041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>

[ Upstream commit 6dccbc9f3e1d38565dff7730d2b7d1e8b16c9b09 ]

When the nl80211 socket that originated a PMSR request is
closed, cfg80211_release_pmsr() sets the request's nl_portid
to zero and schedules pmsr_free_wk to process the abort
asynchronously. If the interface is concurrently torn down
before that work runs, cfg80211_pmsr_wdev_down() calls
cfg80211_pmsr_process_abort() directly. However, the already-
scheduled pmsr_free_wk work item remains pending and may run
after the interface has been removed from the driver. This
could cause the driver's abort_pmsr callback to operate on a
torn-down interface, leading to undefined behavior and
potential crashes.

Cancel pmsr_free_wk synchronously in cfg80211_pmsr_wdev_down()
before calling cfg80211_pmsr_process_abort(). This ensures any
pending or in-progress work is drained before interface teardown
proceeds, preventing the work from invoking the driver abort
callback after the interface is gone.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
Link: https://patch.msgid.link/20260305160712.1263829-3-peddolla.reddy@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 841a4516793b1..77cb1de9fc13b 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -641,6 +641,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
 
+	cancel_work_sync(&wdev->pmsr_free_wk);
 	if (found)
 		cfg80211_pmsr_process_abort(wdev);
 
-- 
2.51.0




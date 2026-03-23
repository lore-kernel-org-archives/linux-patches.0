Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BD63B4E94;
	Mon, 23 Mar 2026 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274798; cv=none; b=Kv8lqFX1Un8Www/loMTtDTycy8NHm0mpE/jfOzf+ZqliWscI3dklYA5meL0T/75jJak2UHBj9LN6QqM+qTL0XkeOEPvcmLCAU93errK/w6IG7CUr5Qyi4j706UN3Ju0728WzQE4gCBeSnolSsJpjTiks278HI0hzw0CFUZocvS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274798; c=relaxed/simple;
	bh=c5Rv5wd888Klt2kl39JMNmZ+M+LGj1e3y224hpfCg5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKKrdQ7LX9854zDF44S5p9VuPzmb6vYu2vwmFX/o+hEm5+JvVg3HvfF1zAcEEQIzJz4O5LLzCjxZFwLYmDRB9sC12A0fPUfd+JaD8ePxs+HX4LR0LbkY2r71BCiD0yhfMdcvRznFmZqMulFhtg/hjwZrOV0Od2u+fZ8SFlF1GTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mF5HgvPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mF5HgvPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F014C2BC9E;
	Mon, 23 Mar 2026 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274798;
	bh=c5Rv5wd888Klt2kl39JMNmZ+M+LGj1e3y224hpfCg5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF5HgvPshqCfsERAnRCtkXaakzp5sdqkJhOKZytOBXcnIceNx2g6xnuf8/P6G5Fcg
	 XtxL8SdezHGfQC1PeCotBLwizwLJUS17a9/An2QdEwgGXWmw5ZqHzGYQFkkCQ8cjD6
	 8IK1bU+VGNZZLG+AH36DdXGVzeCs5WkKKVDkHSCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/212] wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down
Date: Mon, 23 Mar 2026 14:45:32 +0100
Message-ID: <20260323134507.286654154@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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
index a117f5093ca29..13801cf35e9fc 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -647,6 +647,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
 
+	cancel_work_sync(&wdev->pmsr_free_wk);
 	if (found)
 		cfg80211_pmsr_process_abort(wdev);
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC1B3168EE;
	Mon, 13 Apr 2026 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099073; cv=none; b=QjZbNhZg3kNHnDhpUVDiQuRALP+0BiwKPXKxe31VGOd95bZ1boPbZi8yOBLbfCh0v6w2IMtM+RSo2d88fl7e9GTG55sp1mQ0eEnzNNrK330+zYrukI/yWaHcgNqU8FgFzBov4a6TwkY9YtsRS+D/s3iVKtBpk0G3RnY9aOUVxhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099073; c=relaxed/simple;
	bh=LvL4eqvOnMFDWP5spvH8hXXlQZi8/GXCEoXtEG5Pf4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLlkh5q36YAdkNsM5g70iS/lc18wh8KHOmVlS/xFWe9Nb7ODlK2w8Ok79NZTma3W8AqeTw6V0OX1BTU1O5WQ36abP4PE2V88h89vylE8D6L9oCl6EDNCGY6Jtt/vR2KFdf/YpFEOBLx0cL/+nT5LNHTYatls4AG5IURXuPogKQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEtbhAgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEtbhAgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64D5C2BCAF;
	Mon, 13 Apr 2026 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099073;
	bh=LvL4eqvOnMFDWP5spvH8hXXlQZi8/GXCEoXtEG5Pf4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEtbhAgQgu6amST4nNfjvA0VcM65tA243XX6Aa45mZWySxbCBrNbWK1Hho6r0oma0
	 ePNP7aODS+uA9cwnKBf6TefkDIySdDelDRGGn2R/nxOLSIzAPFxcub/of/a7jzlY0C
	 7E4FcrIwqKQsxCoYF/XZ5iGmFNgSnrWWxVKAaPvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/491] wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down
Date: Mon, 13 Apr 2026 17:57:24 +0200
Message-ID: <20260413155826.522907380@linuxfoundation.org>
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
index 7503c7dd71ab5..32cea07b98fd1 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -620,6 +620,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
 
+	cancel_work_sync(&wdev->pmsr_free_wk);
 	if (found)
 		cfg80211_pmsr_process_abort(wdev);
 
-- 
2.51.0




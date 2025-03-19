Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9544620551C;
	Wed, 19 Mar 2025 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395212; cv=none; b=DtRcCcBuW/qHiZnoxvbia5UdfiMpqmFrBXcUp/6+axiw2sGbBTR0YSrC7pwLv1QNjPW7oRRywLy+tvmONFNtWGCHiwFDOFj4RVBvh0RIuOUG7ozw52GokKZJi+8S7+c9f2Oun4zzyweocSIL8/8CTxedGTMA2TMRwCQSGaaU7ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395212; c=relaxed/simple;
	bh=MBdD/VPA1UmmDCHW4l6sZU7LM7yfGy8RrvkwJok6qEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOG1AULaVFlF2ctaC/0ZN2nXnQyS9cWkfPhNXDauuc1MLOsl1DaPaTGChW0IviSdORHWrkLkBPJEdMc/SWd2adMYV5TXPKUWt6PMWohxkG67PxjIl7uV9Riy9ZZOtnjl6RSU/iTbzHtY5bfo9n48lbs7QVbXGPxdxSghwZcd5io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xFY68W4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xFY68W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC7FC4CEE4;
	Wed, 19 Mar 2025 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395212;
	bh=MBdD/VPA1UmmDCHW4l6sZU7LM7yfGy8RrvkwJok6qEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xFY68W43lYm81BodOv0Xcy7i/9d7ljCXKpxglRMxEpcPfMBge9ZgMx86AGkI2h83
	 1NIJYw6G6IWjjodGokahtO5LWkgp9H/rv73ZAbNNk8yV0imBYBi/6bFoLPPTVMF2bz
	 iTiE6uw/BdY+H2LZDbE+vWTcPsbKqKHnAvljFxz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/166] nvme: only allow entering LIVE from CONNECTING state
Date: Wed, 19 Mar 2025 07:30:53 -0700
Message-ID: <20250319143022.237990129@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit d2fe192348f93fe3a0cb1e33e4aba58e646397f4 ]

The fabric transports and also the PCI transport are not entering the
LIVE state from NEW or RESETTING. This makes the state machine more
restrictive and allows to catch not supported state transitions, e.g.
directly switching from RESETTING to LIVE.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8a200931bc297..f00665ad0c11a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -503,8 +503,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 	switch (new_state) {
 	case NVME_CTRL_LIVE:
 		switch (old_state) {
-		case NVME_CTRL_NEW:
-		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
 			fallthrough;
-- 
2.39.5




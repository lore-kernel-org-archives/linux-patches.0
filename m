Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D4E1D88D7;
	Wed, 19 Mar 2025 14:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395088; cv=none; b=IFElkZwvH0beW2p4aRx10SV4WXyKa+6X3HSozEYwo5RKuvkRzA8QozPj7icZNgSt+Nr2sQeCw94ZCixuGrhIYpC5k369MqIPM3OGtqoSMZEEAPkuvWwbHM5k9KlCaa19o0LGTL1u6Ex0FfAyhMdA3gDd8/l9/tTTpp4XLEPcLHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395088; c=relaxed/simple;
	bh=MJiRsF28hFZrAFyddBr0XRw8iYjGJbM240VXVdm9pQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmZ5uZzMdRxxWuIdctH6oFdbx35f+cMkzW4sTFnFzc0U8eXtlMvLNpD48eeRGky9QMtYEeLhaUkR97haCFc1MVVgo8+gf+gR4mYiuJr8d1eTDYPGyyDatOIiwlEjNirk3jqcpng69uOPf+nLodR9j1PbRpCVLEAs5nhnDJCuccA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlHU4QEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlHU4QEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04B9C4CEE4;
	Wed, 19 Mar 2025 14:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395088;
	bh=MJiRsF28hFZrAFyddBr0XRw8iYjGJbM240VXVdm9pQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlHU4QELM5T7noSeYNNLw5ZKqVi4uj1DhezIJltD39dUEPQi0XFB92RoapRbk2Gxy
	 80G7JKa1c4V00NHQcylXYUUtZM1ZJkrqpXP8leMe7gH+plXuOM+f+6AUEiT16HF2Lo
	 0KwKfK19xPiZ9iYZmHRCXQl32Yp95xCMjMocxAgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/231] nvme: only allow entering LIVE from CONNECTING state
Date: Wed, 19 Mar 2025 07:30:19 -0700
Message-ID: <20250319143029.952093848@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8da50df56b079..a950aa780d1f6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -562,8 +562,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
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




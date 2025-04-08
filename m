Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078C6264627;
	Tue,  8 Apr 2025 12:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113927; cv=none; b=hQwUar953vA9JB6h760K1dPkz3mRSHCMmi/VYOC+ff3cYzqrE4TrLWKg5rZc0xWi1Z3jPNlzYfx8e2tdtg0kqc0c6PKwIt45cYCzeFky+vC2pFk7cP5sB2zbQY84X3w1hk5M+UCPp2ilfr8l3vzGRHCn9MpDXUx+Va319pW5IWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113927; c=relaxed/simple;
	bh=pOUMuggcxYlogc9cx5eHoYPXxO3Tzp0JgA4wRNMiEz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwJcEguS/PwFDENS7oO7lXefecPDKNpThItKQbj0VqSvQGBJI83HZz82SC3bYDq7abKwZPT4wAL2u7UDil+TQHGXH3XG+VgeUkeDYUiNQ6ImOLN1qgQfWYWtVU2S+hhow1SoZdtVlTv/Fk6hnI5WcZGtzXynO/80hGDQCRejqSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2gmUz0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2gmUz0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD0CC4CEE7;
	Tue,  8 Apr 2025 12:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113926;
	bh=pOUMuggcxYlogc9cx5eHoYPXxO3Tzp0JgA4wRNMiEz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2gmUz0x/uNOaB/yJIlXIDO/z+MKjbG0CkXLx6wFoKckaKgY5qO11oEiQFN/Y5L1X
	 /RtmpMnK6DcJtJ/TDGZQa6KuOv0WdhCAEySfneer1dEMM5f6G44vWXTVnb43WWe3gX
	 //4PCWX8sqeW9b2xXwG92P8rmbV1iQVyUwe7ndVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/154] nvme: only allow entering LIVE from CONNECTING state
Date: Tue,  8 Apr 2025 12:49:34 +0200
Message-ID: <20250408104816.319430763@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index dd4b99ea956ac..9816debe5cb51 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -351,8 +351,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 	switch (new_state) {
 	case NVME_CTRL_LIVE:
 		switch (old_state) {
-		case NVME_CTRL_NEW:
-		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
 			/* FALLTHRU */
-- 
2.39.5




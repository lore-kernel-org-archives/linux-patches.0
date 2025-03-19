Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C1C1C5F2D;
	Wed, 19 Mar 2025 14:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394921; cv=none; b=Rm5RE7M+abYe25LxNvi+GMleWm4LYGqeF3LFYcV6UphD7FImbeIXOqYnh3xCQGRj3LKRkLxl0ygJXoyIe17Wf26EBmqmxBjdufqYp7Sx0bIMAYk2YDmX5P9c1OJtjlqX9oTpHmMqakfxaxu6BFtR+VwzyH9qvz8+eTGPsgoO8J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394921; c=relaxed/simple;
	bh=xLQVTX/sHmQ+X7Dz7xkaJjpLqJdbd3/MZqppkUwEGgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoV0GPBeGj3xLgFNZe7auzoZ2w0HiSZcGhOgfYWqxCQLoaSIhbgNNAu7TuyvHWif6UQVmcH4wexF4TiN5fKZX+1Y76FeEuhBsbxR+DZLOPXQ72IZTCZWq+xrTlxxXZZh9ppgbyKkEfDZSIh9b+BPWKeroAYk+6RjBdpuPMmNFDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3mXynBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3mXynBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4985DC4CEE4;
	Wed, 19 Mar 2025 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394921;
	bh=xLQVTX/sHmQ+X7Dz7xkaJjpLqJdbd3/MZqppkUwEGgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3mXynBjvxZ0qzYQSblZSQV1GaFPt8xo0g3Kp64t+eQ9UQ/sc+kMlwCgvxiOKJoKS
	 UBZpQHcIkx3IZrQeDe0e3NeYJw+u7Z4BJxdmDZ36e13iqk+JgJ+VQo1SlqgXDNHsS0
	 Cca1tmluBZcFOyB0ydQmGoqKUTryR4Vx3R6hlC8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 132/241] nvme: only allow entering LIVE from CONNECTING state
Date: Wed, 19 Mar 2025 07:30:02 -0700
Message-ID: <20250319143030.993134678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 46e04b30f6425..cf0e7c6d5502b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -564,8 +564,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
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




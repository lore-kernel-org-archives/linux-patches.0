Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF520C488;
	Tue, 29 Apr 2025 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950114; cv=none; b=EqJcymj6Eec9Iu23BXVqLpDu/ZBvezINDZNCYO3NJxeSt/gpuJPjot7cpY+ujuv08rMwPCz0J4sggSvra/2WaNUvO3uRieVLY4iNvAsVm3SS+43cxAWA/YDEaSbh2A1viVyZYh9qqxVhyJecwZkwgjAhF+jK6sD1OslWj9ytmJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950114; c=relaxed/simple;
	bh=ERH0opYwzKEH53Cj6oZ72sQF2nJvlu6S7hGYFwIs9Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiBnczMS0kQlc7fezrjVdHPnher2HSiLo5aHx7QQ+yxU+91VjhPjIWdblmPfLMH2R6ziOG9Dl0jVkOo4DXH0wdvVDbGTHVaDAODTU3iVUASIVTIDvpGPJ7HPJWrj4ccwivZr8SppZPQhx86cnz0jHrKkrH96NHP+nQN1Gcsg0Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+MPl5nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+MPl5nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3541AC4CEE3;
	Tue, 29 Apr 2025 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950114;
	bh=ERH0opYwzKEH53Cj6oZ72sQF2nJvlu6S7hGYFwIs9Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+MPl5nbWmWawQtzXYgh1zd93I7LoVN76tLEnBUR/HlaBDJRx5FKIj8AyiIYh84cq
	 ee3lO952WNnbhay1PpqzcONWF3iPlAXgrDJyIP/WWI9vxgGf8rNL7XwH3L/XJJhB5q
	 HGY/Jjez+LrO3dc/BF84oFY8qn8UJuDjdKd0q4tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/167] nvme: re-read ANA log page after ns scan completes
Date: Tue, 29 Apr 2025 18:43:59 +0200
Message-ID: <20250429161057.037685278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 62baf70c327444338c34703c71aa8cc8e4189bd6 ]

When scanning for new namespaces we might have missed an ANA AEN.

The NVMe base spec (NVMe Base Specification v2.1, Figure 151 'Asynchonous
Event Information - Notice': Asymmetric Namespace Access Change) states:

  A controller shall not send this even if an Attached Namespace
  Attribute Changed asynchronous event [...] is sent for the same event.

so we need to re-read the ANA log page after we rescanned the namespace
list to update the ANA states of the new namespaces.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ec73ec1cf0ff5..e199321086f28 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4708,6 +4708,11 @@ static void nvme_scan_work(struct work_struct *work)
 	/* Requeue if we have missed AENs */
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
+#ifdef CONFIG_NVME_MULTIPATH
+	else
+		/* Re-read the ANA log page to not miss updates */
+		queue_work(nvme_wq, &ctrl->ana_work);
+#endif
 }
 
 /*
-- 
2.39.5




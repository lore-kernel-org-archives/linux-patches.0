Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9197B1C6B4;
	Tue, 29 Apr 2025 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946485; cv=none; b=g9jMWpZYdY/kSXMjH+CHGjJhz+49LKcEDNRUWOw9+tKTTQGYdWd7hdFm2405YUE8uUx8lWhk4PL47gNZj6yY9YhfXwVev8M1zowmK8fhZTVor3wxbw+25w4XbWVAf8/yKnJmPLUJwF6H6rYB6GzBxLQOGKTriyMUyJb6sWU1I/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946485; c=relaxed/simple;
	bh=hIdnii2xa/jNIc98Zc+H9QSZlGSzddjbenvVJPIiKYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2p3J41uwp/0yh/Xd/h8V1U+rrNJ4opO7CgQUP0zSlcJGUZltodj9gJmdk+QV+L0gq+B6YKfYZHB98410OP81jpPbEPoT5drJfrEn5MUmhWcfYLwil0qr7XdHPi4QjkagdNOaH7TKqicAUEcVKy5oIPw1SOr9uOwyg7AQHifKs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqmXmKy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqmXmKy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0170FC4CEE9;
	Tue, 29 Apr 2025 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946485;
	bh=hIdnii2xa/jNIc98Zc+H9QSZlGSzddjbenvVJPIiKYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqmXmKy4Xl4IuP8kcBUHmgka8bWuv+5PaP6yTCcsnUzSNXJGke/V7TzhTmYKU1Hq7
	 +s20mDA5+0FWByJ/iCrCWB/vD3eIWy1VPn5dxAGmWF+VwYi6tc9d8KFL2BOI13WUsO
	 PohLxHxHqSk3Vo9+r1BPtg9RFuJ4px4HfCFENptk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 253/311] nvme: re-read ANA log page after ns scan completes
Date: Tue, 29 Apr 2025 18:41:30 +0200
Message-ID: <20250429161131.390366290@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 70f9c2d2b1130..edee1ec3d4780 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4296,6 +4296,11 @@ static void nvme_scan_work(struct work_struct *work)
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




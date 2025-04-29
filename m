Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12B622172E;
	Tue, 29 Apr 2025 17:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948265; cv=none; b=TTcEk1DUVwW6PE+lUgIn6FtpW1X0rHbjmHXc+W9M50EYP5vI8L3qAFUKiqbu0l7d+vJqwJ3NCM7xe0ZkkCfjQlziA35kIDrHG8YtvnUUiasB9BRcU/g03wBjCcjrvD4QX2pNrWHolfp0dFTY+xwFeu3KlpRSo3JwvhjyDYQvcy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948265; c=relaxed/simple;
	bh=Aa8jP6Bv/iEZQ4u0TU6dFp8fFiJqJV5i5VAgUPqYOi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdzjtID2RMcALzC1Ph6FFMSGUD0rN0iKgmU3GhQqDmQ7y4qiavIG5Rgm4hZeLiXCmS6lut5qOVITjkEI4XQi6evxXgoPfIFMWEBIcuUoDGqAQTPmzH6//5iLKFwn9/rwq0V/QIdbZZMi+rphq25ExWjk2IOUof9SL0/WMMZD69A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVEa/BTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVEa/BTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A6BC4CEE3;
	Tue, 29 Apr 2025 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948264;
	bh=Aa8jP6Bv/iEZQ4u0TU6dFp8fFiJqJV5i5VAgUPqYOi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVEa/BTYk5Wp/MpwFVx2xpnGe9wAKjDLZlubPWW8bWpTaZTczFzkppEIMaVf+QHgL
	 tzdTAciQd7YYjmI8+D2snHUlomcZZ5WQedZfGYqOJADVkxWy5JAISTMqA9SWrfAEAO
	 1v+xx1CA/8si9I1QSFGYu3pVj6X6XeZWRiME9Cu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/280] nvme: requeue namespace scan on missed AENs
Date: Tue, 29 Apr 2025 18:42:28 +0200
Message-ID: <20250429161123.600823696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 9546ad1a9bda7362492114f5866b95b0ac4a100e ]

Scanning for namespaces can take some time, so if the target is
reconfigured while the scan is running we may miss a Attached Namespace
Attribute Changed AEN.

Check if the NVME_AER_NOTICE_NS_CHANGED bit is set once the scan has
finished, and requeue scanning to pick up any missed change.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9bdf6fc53697c..587385b59b865 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4273,6 +4273,10 @@ static void nvme_scan_work(struct work_struct *work)
 			nvme_scan_ns_sequential(ctrl);
 	}
 	mutex_unlock(&ctrl->scan_lock);
+
+	/* Requeue if we have missed AENs */
+	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
+		nvme_queue_scan(ctrl);
 }
 
 /*
-- 
2.39.5




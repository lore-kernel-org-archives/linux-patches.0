Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B75B2472B6;
	Mon, 13 Apr 2026 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097927; cv=none; b=Q1X01FqZc7hRyNTKihsVqq8gtgim+eAoW9B106Sx35chUKji+QnZPeawlDjLa4uIyZTs/mffrJCrfC94pYxbgc+DSLPuJNiTUQYbfhCfrgC99r8Iaj37uZ0XObZblpMCoknWNIllkMRLtqwQDi1bmH7AjDdnt04s4/uqn+QBPA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097927; c=relaxed/simple;
	bh=qeKZBoHuWdo80oECOXDMrN/4a7TQo+2w7JtWdz6x7ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPf+0Z9qAcdovxByDtj+Sp5HTnVK1N7zP3/VnJKdyl26y6xL94Q2/Dzh55GmQxgxXCxD7c4C9nsPEna0vVt6C8YAizW0DGj+RCoFlwq6SY5v2iq3m7BIV/yyiGx71kvFEhpkZyt8fmniJCmKOLqkGl13BiNUehhoHQHE6aHg83s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQbzCIfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQbzCIfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63DDC2BCAF;
	Mon, 13 Apr 2026 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097927;
	bh=qeKZBoHuWdo80oECOXDMrN/4a7TQo+2w7JtWdz6x7ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQbzCIfeuTQ4KkRN2cXiYpvRvqCtUuJRsRLKOvPNdjUSsfP2qrSzepz3UMEtK1V/U
	 Cj7t6pgGt7Unl+tPnLtVQuINJEzRztmwNjIGjVpKrMXgornxNJfxxB4bicgYD+NhmF
	 1ERE7ZZd+XqVDZznohrmS928f1pFhdjpP1euvmRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/570] nvme-pci: cap queue creation to used queues
Date: Mon, 13 Apr 2026 17:57:10 +0200
Message-ID: <20260413155841.702597166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 4735b510a00fb2d4ac9e8d21a8c9552cb281f585 ]

If the user reduces the special queue count at runtime and resets the
controller, we need to reduce the number of queues and interrupts
requested accordingly rather than start with the pre-allocated queue
count.

Tested-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 04cccbb05372a..c4a33e9d2c717 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2306,7 +2306,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
 
-	nr_io_queues = dev->nr_allocated_queues - 1;
+	/*
+	 * The initial number of allocated queue slots may be too large if the
+	 * user reduced the special queue parameters. Cap the value to the
+	 * number we need for this round.
+	 */
+	nr_io_queues = min(nvme_max_io_queues(dev),
+			   dev->nr_allocated_queues - 1);
 	result = nvme_set_queue_count(&dev->ctrl, &nr_io_queues);
 	if (result < 0)
 		return result;
-- 
2.51.0




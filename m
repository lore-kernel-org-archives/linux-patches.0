Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790EE3E3C5C;
	Tue, 31 Mar 2026 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974333; cv=none; b=qGJAfXktJEMOxQ9w69mZsRYqYVoznPmrcI/XEJt5DQD9Aar7hGJ6zQdZnOz87z/pP63OCIso0aIMN0rKdhjNLdS4Qq6P06oitdKS7nic9ywysz3wf4TMH4OkUMhiEObnPHKTGkmJn287BVSj/iLhJIQW4e9mcsCz8/qGHwK+yRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974333; c=relaxed/simple;
	bh=Gr0uf2NX7fL37C+7ERHTpO7hjkem5e/CwEYmNfO3g1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+8GgSqmUjrx0OTPsMQRiZx66fQyYDE2aI/YXrcRJ9YznHqWAjxWf5dBI86G4ilAUqR3mdK2Hs8kANV98RpNI+YMGud6pEOIztSeJrekB8t81+WGtJ3A2FSr6j80GtLrFlacsG/s3wPHR12Gp1BhdQrUx/CtC5uDyZaDF98rscE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjWmckL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjWmckL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0566C19423;
	Tue, 31 Mar 2026 16:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974333;
	bh=Gr0uf2NX7fL37C+7ERHTpO7hjkem5e/CwEYmNfO3g1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjWmckL88GPnS22E/u2eB4nYhpSqf3IC8Pjw4ipwe8xcTget3JzvplQgZ6haKNcoh
	 Ay4gegWiTqyuQrYBFOXeZjJxdOAyj5cvKGcoAMWexMfMW5bGDIS5ja4Pu3m7wRvjZ7
	 xiR6G0T/bun5JkqDQM2BNWs3prEVkCvxDOVwqgXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/175] nvme-pci: cap queue creation to used queues
Date: Tue, 31 Mar 2026 18:19:56 +0200
Message-ID: <20260331161730.233425873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 03a2ca3edb9c3..820e211feded2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2355,7 +2355,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
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




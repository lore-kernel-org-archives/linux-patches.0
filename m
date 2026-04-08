Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B13F3D4134;
	Wed,  8 Apr 2026 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671654; cv=none; b=tjfgMke82MH9nt6r70f6IEoH+FussVqRSIY3WReTgm7Q0rFlZHinwgO/oARFlZKaBkyAl4qRkOuA5qqfw3Khq8O8hCSdzO/2wRorZ4KP0lnsRPfoz80tN2xZEUQnfBJe20MT3wvDK2b0Swj41xQ+mbSBKc6LLfslQDT1m8CmntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671654; c=relaxed/simple;
	bh=tgJowrcjQIpIPTae5RTVUv+ZQFv90unrbWPtFzhm7VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJyq2J8mxtyecBhYMNM51E2m5LbKfWs4+NkwSi0QFe+ESyx02NOLpD/r0jRIwsUih3JAZfmxan3XqBsgZovK+KjbkOtL0xe8S5NvKMCMdLLcVRdZ/pvoLubAKTz4Obx/bepvRKWFTnskYSJGxqwNhJBQcTu0rlKdYMyOzrzP25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZGzKGwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZGzKGwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC42BC19421;
	Wed,  8 Apr 2026 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671654;
	bh=tgJowrcjQIpIPTae5RTVUv+ZQFv90unrbWPtFzhm7VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZGzKGwKtYxYRaf7NyOW2YQqisGXEnBLKsEXY/UhSNxGEIv4ubacnHMKsWOGpFUAh
	 uuK+VScXDLubLU5uFMz6kPMhXEfVWAELpQlrlw6hbQwzQT0kFMLsicbnmtj+O4U2JG
	 gSkUPTcDinQvXr2lgm53TW9v4sOKXHPWYvfvUDuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/312] nvme-pci: cap queue creation to used queues
Date: Wed,  8 Apr 2026 19:58:42 +0200
Message-ID: <20260408175933.924612098@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 518f8c5012bdf..509a788cc7350 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2402,7 +2402,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
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




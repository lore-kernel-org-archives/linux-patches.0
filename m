Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA3C402435;
	Tue, 31 Mar 2026 16:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974825; cv=none; b=nwXF83zYKxxugHRzlY1WfNc/6fiUcs2ySGT43vYSsSG8QvrQ7K8X7U82+I260K0EkDMtGfEQbJKxDW+bU6mNYYgLMbJX6AKZeKOmkI/rfChgaDsmxoXwvY7PdEPl4tseS9VYFXRo0sdv+ZDIJsSGBZ0O+61/EC08PpaUZ8Yloh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974825; c=relaxed/simple;
	bh=YvKhJttd4YIW89+6qId9e6CnMUh+6mAkLKs8SFC+2hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXFJNTCVa/LQJe7cbISF2Eh3jpKdZTAaP5S74OKdKcT2OFvt2CpnwIF/Y+Cd6B5vKGk80SNmCkcwYy1OeLKgKBURg/S8jMgYI0pCe5MXWHhjtG6PU9BPy+x39u7A4hml0eira4x6IbEF1i5JI58JtXg5Y6rXLF0ebSp/h/nw468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFauzZBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFauzZBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E82C19423;
	Tue, 31 Mar 2026 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974825;
	bh=YvKhJttd4YIW89+6qId9e6CnMUh+6mAkLKs8SFC+2hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFauzZBPn6hGBerQeK7CW0sSyj7fBSi9Cm966Ma5NS/exrgWpH+3NRczrkXLRgrVD
	 MEAzkcINYkqebxfdgsZTkxbWitJva0CH/VHQCzGJBOny3IvDgRZxY2DnpSmPtlCtIi
	 rHw0kKplldUXnlS4Gqb9M3Vg/WtxMt92wQLtJkX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 025/342] nvme-pci: cap queue creation to used queues
Date: Tue, 31 Mar 2026 18:17:38 +0200
Message-ID: <20260331161759.837315785@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3c83076a57e57..a5eab31c1bb7a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2778,7 +2778,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
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




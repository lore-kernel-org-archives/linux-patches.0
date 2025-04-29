Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FC92AE96;
	Tue, 29 Apr 2025 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949541; cv=none; b=t25GLDRXE9kjVRDvfqIGkVdGgGEvqbhjXEJ+dN4gR2scL29K0BXR17F7l+/cemp08MMSqy+agzj4AFJFnFh6TSApY8HP4EElImnpaqr6TVgW8x2R/qHRSqqiPeSEI4KKRbQUtAxD2kpKdnrTGOPZw1D8xr/CHlpc17uXGoNXSuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949541; c=relaxed/simple;
	bh=dU9fsw8+iVQv92k0of37Cr0C3KpHm/ElnoDVCEUJVt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzriClG9LiCJz5V8lBzczo74vBJ868iMmwM5jpjlNBDbV54Xptv2K1F8Oi5cOJa2H5tnDIJdcZybYi7OcQNEOazPvRHNUrqrogZQtHJxQitv/vL86pRUwKb//Xs86Ot1PYbP1he4OmKuf3QDVjnJDg/NL7Yi5jEZOgetiyKhOKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/mkgMAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/mkgMAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573A0C4CEE9;
	Tue, 29 Apr 2025 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949540;
	bh=dU9fsw8+iVQv92k0of37Cr0C3KpHm/ElnoDVCEUJVt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/mkgMALHiCLrDeCVOL/y8Wiien74NX60TDddpYV+z6ZnZeampdiy3FpEGk5N4mXv
	 iEwcs8x9X29e6TS/TAv4sBLUuMrc60wQaXMgA4gzvJoJrrfAGTZMYSDk7Dtr4GpUSH
	 ZXIY+nSq0mtWCLLHjtWwAdzmn1L0sfaE/iaGKW9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 344/373] nvme: requeue namespace scan on missed AENs
Date: Tue, 29 Apr 2025 18:43:41 +0200
Message-ID: <20250429161137.286448628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6748532c776b8..85d965fe8838c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4221,6 +4221,10 @@ static void nvme_scan_work(struct work_struct *work)
 	if (nvme_scan_ns_list(ctrl) != 0)
 		nvme_scan_ns_sequential(ctrl);
 	mutex_unlock(&ctrl->scan_lock);
+
+	/* Requeue if we have missed AENs */
+	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
+		nvme_queue_scan(ctrl);
 }
 
 /*
-- 
2.39.5




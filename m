Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621A3248866;
	Tue, 29 Apr 2025 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950105; cv=none; b=XEoo75Oy0DK48xv3ozG5Mr33+Iq/A3JypdNDbr61mwBSUUsvw7PayZ/NiDEuFnkGKrhIS3x2MbjMmh6IT5Qs9o+iFvDJUGqWx5MdaSNsjFbGUibCUsMPZ6DV1nbD4Q8byKn5zSwGffLzZ2gKEmndD2K8WU3Qt0A77vEF1jmz2jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950105; c=relaxed/simple;
	bh=+594PLiFX/k3bGHeCi4Eqi9cPeiKLk8ki+iESGDXq5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+ZV8SLn3C80wTJ3piU0jqSJIgqPPgBjNLFj0LHt6ALrDDqG2XaeG6dNN0N7jKvnSGBxs3rfo9UfPA/OoIArYzzM6JzKa3RbWop/LsI3K3cXqFtWPy2um7QQHfjquKssAc9oBaqz0WwC5t46TesJLDnFo7m8aGemtyq9Uyg9IOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BnFsFlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BnFsFlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CB9C4CEE3;
	Tue, 29 Apr 2025 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950105;
	bh=+594PLiFX/k3bGHeCi4Eqi9cPeiKLk8ki+iESGDXq5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BnFsFlA22JriNTLvnHNwdBsO1tPVyQT4dmuVksHX0RZ7MJT6Uvivn0uxgpdKfq0Q
	 O3uE/dKm7Gro/MQgBXJQmijzh4blydLP6Ey7obkAKHFo+Hno3H7b4x1HZZek9sXAIf
	 W+U7nc78VnYBrEQm05ZuKLEPuvQR+T0XxlWh7iJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/167] nvme: requeue namespace scan on missed AENs
Date: Tue, 29 Apr 2025 18:43:56 +0200
Message-ID: <20250429161056.919413517@linuxfoundation.org>
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
index 6a636fe6506b4..ec73ec1cf0ff5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4704,6 +4704,10 @@ static void nvme_scan_work(struct work_struct *work)
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




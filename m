Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF52512E8;
	Tue, 29 Apr 2025 17:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947400; cv=none; b=OZ0ECqtSrGeGEnjVrs5cGer1TSoEufz/UZflY/Kjfgf9Y0D3p0ahRkLNqNOB9zcXwnBwxdoC15dCJy5bPplTnuOMBMypLlPSRMbW7IF9JcoNOSLlFuKy5ERu6Kr9ZqWh9lrTMwmR1Iz7oDbeCPoBnFfp+NEq6PrMEMScK89IFyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947400; c=relaxed/simple;
	bh=NNVR1LrHEUiwrPY5UJHyIT/+EcFSqr4KjuFmg2trLF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmVvweb94MMAJSR5d+mUdXEoxI7icpEuKVJTlao+K4eShAYnKrbWiEgo2Mr8vh7CF6e79dzEXCW+YErJlIe8XPBqKwkIujM4Eb0Lpy3NmZG7i68BnrJVNGGdrEp0Gp8gYQO56GOEv78pEJhwrS3BK2uRWqK1Zn4Mth9mZSoxvck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMQAYkE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMQAYkE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EB6C4CEE3;
	Tue, 29 Apr 2025 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947399;
	bh=NNVR1LrHEUiwrPY5UJHyIT/+EcFSqr4KjuFmg2trLF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMQAYkE0Pb6IrpsOYJhAMZW6PQAzvYLSDd7q7tZvqgB8PwU1M243zR0TQm+J5/heQ
	 bhqkPABvAcaU6hEUoLtzCZxJftEeXqMH5bB1NeNSVSQsvcif363z2Y5w+RuQqm70fy
	 07JIKy5oazxzTE1oBWB1bYBuOLTFuPqJVSgNqdao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/286] nvme: re-read ANA log page after ns scan completes
Date: Tue, 29 Apr 2025 18:42:53 +0200
Message-ID: <20250429161118.986607596@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 94225ffd4643d..5f22f8e8dce7c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4270,6 +4270,11 @@ static void nvme_scan_work(struct work_struct *work)
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




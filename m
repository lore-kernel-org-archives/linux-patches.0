Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF4424397A;
	Tue, 29 Apr 2025 17:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947477; cv=none; b=QtwzIanoly+8d+tmjre5PaRxSGFeofy7Ai8qL4nC/S7orBfWx31PzfulLeTTJa8OJllhx6NiWZ25bLC8Wdrzrk3g31FwjrRCYyXck7hphQtwAxczjScQSt0LFMsaVQuLad2H85DExOc0nk1DiCLp6yEmUzizxnm2BY/DAjM5LpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947477; c=relaxed/simple;
	bh=wRjgICUUekpwjiLYNvpuf6HanP1HMzyVch1pQGO9WZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIMTiiZpyeUwPc7dsHgIpMJN2M9RXYn9jeaVH+QMMEOzFYBdmbwAbCcqOxAykvCXmEb01ok/tLDTmNMns3Hu+InPE2sl6PFfxIwx3PxsGD90HvMm7ljXTpyzdBhE8NV17t+hhIFAG/iqSE1CadPnSbwa5dtfumPIvLEtHy+iDlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsMc4uEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsMc4uEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A801C4CEE3;
	Tue, 29 Apr 2025 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947477;
	bh=wRjgICUUekpwjiLYNvpuf6HanP1HMzyVch1pQGO9WZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsMc4uEjOP+fMB8u/NK0poO46DOWeEdb1s68ZVWcA6AKPk4LWUIm9W1B2YYIAhFQh
	 LgvWmq7fnLugrubWr+q+4eikfmcpwn9A3YMdnAXCGJ3AxiWapOHGW9QNfP1N1qXIM+
	 FjsDWF2B/WPJsz/vjoocqLceaY/iaPIpFY6sKSmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/286] nvme: requeue namespace scan on missed AENs
Date: Tue, 29 Apr 2025 18:42:51 +0200
Message-ID: <20250429161118.904920995@linuxfoundation.org>
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
index e63d3ca11cc9a..94225ffd4643d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4266,6 +4266,10 @@ static void nvme_scan_work(struct work_struct *work)
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




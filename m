Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E854D13A26F;
	Tue, 27 Feb 2024 14:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044001; cv=none; b=pkLLJOt5m5tev4zTaLQDtLFKSaUr/1ph5OT5vQxA1BkvtB6S24/7G9wVt+UumdHToqYpKJYLTKYC4yFmWHtbk2xtr/JvRQGIlIXfc+J05Qe1qgBjzl+8n7dnPUmejLkGAjZTmst2ePpR/50IJcxs2vPSoPocF92D0V7VpyiGAQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044001; c=relaxed/simple;
	bh=2AfRF4EeyYvAphuBA8TRtJC2T1WhMMSk6+4/diOi9cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koBTBjd2H9P1NIqhweQIs3oH2rscjy4dXrFFDBFm0X2Xd4ZmLetk/GAABRZixRtYlFkQMUQ0i0B7izRrjrRB2n2nonIB/hMr1QgsUfskpLVgTlYTmpjadUIgLRKsvbkyhY503xxoq4vfnThGgdPcWRvw3phwtlF+POw+wAijaHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nE8JKgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nE8JKgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EBBC433F1;
	Tue, 27 Feb 2024 14:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044000;
	bh=2AfRF4EeyYvAphuBA8TRtJC2T1WhMMSk6+4/diOi9cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nE8JKgMhlXIQjpkNeP948Q8TJCUT6WIrq5Rp6XmuA+7A27LuE4gZVUAiOui3LjfW
	 ccviZBtu8UaqeSFkIIKll+o90B4YXTzMbfbDDZBmTcHc9NWduyoKHbiPH3Uy+LzlWw
	 V4dkO5zUo5Tr4CO1Qsal0u8Nm/vJrocancEIgJSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/122] nvmet-tcp: fix nvme tcp ida memory leak
Date: Tue, 27 Feb 2024 14:26:27 +0100
Message-ID: <20240227131559.563211976@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 47c5dd66c1840524572dcdd956f4af2bdb6fbdff ]

The nvmet_tcp_queue_ida should be destroy when the nvmet-tcp module
exit.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 116ae6fd35e2d..d70a2fa4ba45f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1852,6 +1852,7 @@ static void __exit nvmet_tcp_exit(void)
 	flush_scheduled_work();
 
 	destroy_workqueue(nvmet_tcp_wq);
+	ida_destroy(&nvmet_tcp_queue_ida);
 }
 
 module_init(nvmet_tcp_init);
-- 
2.43.0




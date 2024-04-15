Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8773838DFB;
	Mon, 15 Apr 2024 14:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191607; cv=none; b=g8kFMBCKfGLTVN1g1jFGiBDVSQGMcGSWCzBRYIa4kIRyrmPMegr/XIsZt/fNlwgw5Iyl4064oXdT3c/htHUw/J8W2qz4CD5a3vBf4/WkTal/c05kPxO6YoRdKoXsgymPDQklSvK2lQHGwMwlwoXALQTMPbC/iNqECEBmf07h0PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191607; c=relaxed/simple;
	bh=a+79QvTPsqSgIokgl2/e2KSkNkWE+uK6J4k31ZUQmjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyo5j1AEW2VoTIv64fNs+S0onS/DDFEV287mezeu/9hp+usamxnY3TBfY6B42dAcwB0I7HTvTjKx1SJjX4x3G5c4R5ImtnKdqDBhG3x9GynEhKEHaod1/NHFzApE3xCUetMK1jvjzCEJTlsffj9g9p5rHV+skQTh0BuSJwTYQk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYs6ZApa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYs6ZApa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B80C113CC;
	Mon, 15 Apr 2024 14:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191607;
	bh=a+79QvTPsqSgIokgl2/e2KSkNkWE+uK6J4k31ZUQmjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYs6ZApasB3uCfIz03eBLIFJIoImZsN7dNK7wOyMV7O0sFmax9lwZnAWv5UCfIDgE
	 gICKQAIBd1QIGZT2yttcPuxM4YOOkXCPCLPXBTYFhulQDY5o0FPngHZ8PpHNvH0ttD
	 IBwcYQteQ8MrBq47OVjY0tWWukB+qcPt4+E6RqGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Kwangjin Ko <kwangjin.ko@sk.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/122] cxl/core: Fix initialization of mbox_cmd.size_out in get event
Date: Mon, 15 Apr 2024 16:19:51 +0200
Message-ID: <20240415141954.158408073@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kwangjin Ko <kwangjin.ko@sk.com>

[ Upstream commit f7c52345ccc96343c0a05bdea3121c8ac7b67d5f ]

Since mbox_cmd.size_out is overwritten with the actual output size in
the function below, it needs to be initialized every time.

cxl_internal_send_cmd -> __cxl_pci_mbox_send_cmd

Problem scenario:

1) The size_out variable is initially set to the size of the mailbox.
2) Read an event.
   - size_out is set to 160 bytes(header 32B + one event 128B).
   - Two event are created while reading.
3) Read the new *two* events.
   - size_out is still set to 160 bytes.
   - Although the value of out_len is 288 bytes, only 160 bytes are
     copied from the mailbox register to the local variable.
   - record_count is set to 2.
   - Accessing records[1] will result in reading incorrect data.

Fixes: 6ebe28f9ec72 ("cxl/mem: Read, trace, and clear events on driver load")
Tested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Kwangjin Ko <kwangjin.ko@sk.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index e5f3592e54191..4b4c15e943380 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -971,13 +971,14 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 		.payload_in = &log_type,
 		.size_in = sizeof(log_type),
 		.payload_out = payload,
-		.size_out = mds->payload_size,
 		.min_out = struct_size(payload, records, 0),
 	};
 
 	do {
 		int rc, i;
 
+		mbox_cmd.size_out = mds->payload_size;
+
 		rc = cxl_internal_send_cmd(mds, &mbox_cmd);
 		if (rc) {
 			dev_err_ratelimited(dev,
-- 
2.43.0




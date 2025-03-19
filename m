Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FF71C9EAA;
	Wed, 19 Mar 2025 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394978; cv=none; b=tXdpmnuqnALMqNU9BI3Lh1klLSd94MwoD5srimbEusoNXynRLL6UfiKQxp/Ippxu6h9EzGpihmlDkWLnXEff6KOE90zU/ZVfbkUvv0/CsYF/D7+tlVYaw1p/mEEXb3K4fDeY1WoI3iAH/b+t/rniWj6FDS0inoGtP8TmqXdfaPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394978; c=relaxed/simple;
	bh=/JeC3BJOtsZupxtO2USn206giP/g7VQ2r/ZOGYiGJWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5vaKLcMx4mjFDdNke5wvWRUaX6XHsV1yWlsKtkcU4TU3soR1w62wHV+oS1xySH4nrNqM3gURoIoi838cLMdY3Yh0L2iYMcbF9rJj7GaF02Dxh8yQZIlsXHhHOkTVcC7BbK0H5zeP2nUMgrQbr2TsnGkzX04gAfO3geX7o54G5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1U7oZVNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1U7oZVNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2ABC4CEE4;
	Wed, 19 Mar 2025 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394978;
	bh=/JeC3BJOtsZupxtO2USn206giP/g7VQ2r/ZOGYiGJWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1U7oZVNPPkP6w/+rU1EDbHYbsxOFZsnx3oQEsrFEgaVDEmDMJDBD3dIBn5FNto4/N
	 y3LV6BMlEWrVYQAJ1yh6/sAONsVACEMouup5ErRtTRuocCrizg9SVtWVWY1KearhL2
	 2YnrbbAYHwmk5y5KY3z3fbQkWZuuuU0kjIYmP5AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 216/241] nvme: move error logging from nvme_end_req() to __nvme_end_req()
Date: Wed, 19 Mar 2025 07:31:26 -0700
Message-ID: <20250319143033.093821683@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit e5c2bcc0cd47321d78bb4e865d7857304139f95d ]

Before the Commit 1f47ed294a2b ("block: cleanup and fix batch completion
adding conditions"), blk_mq_add_to_batch() did not add failed
passthrough requests to batch, and returned false. After the commit,
blk_mq_add_to_batch() always adds passthrough requests to batch
regardless of whether the request failed or not, and returns true. This
affected error logging feature in the NVME driver.

Before the commit, the call chain of failed passthrough request was as
follows:

nvme_handle_cqe()
 blk_mq_add_to_batch() .. false is returned, then call nvme_pci_complete_rq()
 nvme_pci_complete_rq()
  nvme_complete_rq()
   nvme_end_req()
    nvme_log_err_passthru() .. error logging
    __nvme_end_req()        .. end of the rqeuest

After the commit, the call chain is as follows:

nvme_handle_cqe()
 blk_mq_add_to_batch() .. true is returned, then set nvme_pci_complete_batch()
 ..
 nvme_pci_complete_batch()
  nvme_complete_batch()
   nvme_complete_batch_req()
    __nvme_end_req() .. end of the request, without error logging

To make the error logging feature work again for passthrough requests, move the
nvme_log_err_passthru() call from nvme_end_req() to __nvme_end_req().

While at it, move nvme_log_error() call for non-passthrough requests together
with nvme_log_err_passthru(). Even though the trigger commit does not affect
non-passthrough requests, move it together for code simplicity.

Fixes: 1f47ed294a2b ("block: cleanup and fix batch completion adding conditions")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250311104359.1767728-2-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index cf0e7c6d5502b..e4034cec59237 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -431,6 +431,12 @@ static inline void nvme_end_req_zoned(struct request *req)
 
 static inline void __nvme_end_req(struct request *req)
 {
+	if (unlikely(nvme_req(req)->status && !(req->rq_flags & RQF_QUIET))) {
+		if (blk_rq_is_passthrough(req))
+			nvme_log_err_passthru(req);
+		else
+			nvme_log_error(req);
+	}
 	nvme_end_req_zoned(req);
 	nvme_trace_bio_complete(req);
 	if (req->cmd_flags & REQ_NVME_MPATH)
@@ -441,12 +447,6 @@ void nvme_end_req(struct request *req)
 {
 	blk_status_t status = nvme_error_status(nvme_req(req)->status);
 
-	if (unlikely(nvme_req(req)->status && !(req->rq_flags & RQF_QUIET))) {
-		if (blk_rq_is_passthrough(req))
-			nvme_log_err_passthru(req);
-		else
-			nvme_log_error(req);
-	}
 	__nvme_end_req(req);
 	blk_mq_end_request(req, status);
 }
-- 
2.39.5




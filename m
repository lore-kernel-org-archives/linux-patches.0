Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEBB268C60;
	Tue,  8 Apr 2025 11:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111911; cv=none; b=FasZXJbfCtIkIL+pW7Gm+IV/dnCTAxjriIo6RfcJiFAfAIcMSBxSCv/kmMEqaGNFLhMni8k6FtZRAeLnfSw6gLaTcgWR4/O4Qu9pU9fAe0V/C9XCLoFv6WKnfMQbqjBxVfq4/xXrxk49UCmixnWEGO0w8TlhZNstC80EcjeQyoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111911; c=relaxed/simple;
	bh=0kcyTKjIscb6n5Lt2IhePNaYoh4jQ2FdAdRj/CExt6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abGPa4suNBYjjd4dH2Uq7/Xta5F9EcqTcr7cCJviG8+2FhI3FMyUnVtJfliVF1OT3HsTGhsb74Ox2lfQREyId13HeG02TUqxmFboaw+J5JRXZApQ0GZqBUuesZX0/zDMy4bmST3ItK5TaNe6x1DVJd6CyYeQQArctXY8xiUcydw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUlCfK7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUlCfK7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0602C4CEE5;
	Tue,  8 Apr 2025 11:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111911;
	bh=0kcyTKjIscb6n5Lt2IhePNaYoh4jQ2FdAdRj/CExt6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUlCfK7r1/z8a3XorQBafmGwLwJYMmNAj7JfCn/IqOQOj3iNy+KpbgLYHsvSDSSPg
	 6PS13Sb8Ce0cMHh77L+DEth7Is2Ja4R2E7CK0xjFtYwgvOXfJfVkWCRntRor6iEATh
	 XiINPB4lzHuhYUvBcWCRB+jWkMTS2mv9/A8lTG5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 606/731] nvme-pci: skip nvme_write_sq_db on empty rqlist
Date: Tue,  8 Apr 2025 12:48:23 +0200
Message-ID: <20250408104928.368986674@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 288ff0d10beb069355036355d5f7612579dc869c ]

nvme_submit_cmds() should check the rqlist before calling
nvme_write_sq_db(); if the list is empty, it must return immediately.

Fixes: beadf0088501 ("nvme-pci: reverse request order in nvme_queue_rqs")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3ad7f197c8087..1dc12784efafc 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -989,6 +989,9 @@ static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct rq_list *rqlist)
 {
 	struct request *req;
 
+	if (rq_list_empty(rqlist))
+		return;
+
 	spin_lock(&nvmeq->sq_lock);
 	while ((req = rq_list_pop(rqlist))) {
 		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-- 
2.39.5




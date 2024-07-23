Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9382813D896;
	Tue, 23 Jul 2024 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759557; cv=none; b=cdhmuSRPJUj2CFsZ6Ll5Klekpg5rJJCe05lcxgsXOzcZqYD1bwzY4WxfAWbxy6sc7wiJV16JM2AMUEZQcY1EK/EfayFA4FEV/1hK6qZVw6v7rLXaf2ALThhwDt11A73bA7AATBY69j6WzrAPtKGBJCHoQNhiOWykGPX1A4D/2s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759557; c=relaxed/simple;
	bh=b0MGz9hz+IFCeYVlRrboKE/C0N4hSw6cQ+bTQRZamTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXrFYC7CE64qo2CXsgC1nxuBZ8BblQ2Z1+lhyCqaIkR4wwRKrMWQ2EzGAXIM+e07+IKLh18K+Mp7kUMGEullGVyTMAkpI8wUN2rjcvp/xCvf2XZD0QuQsuIeIFpZV/5pWgNWTAZNdLuIzEikVlPuA2iy9pal4lJJXDHAcUgG6Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYc4EFvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYc4EFvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1548AC4AF09;
	Tue, 23 Jul 2024 18:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759557;
	bh=b0MGz9hz+IFCeYVlRrboKE/C0N4hSw6cQ+bTQRZamTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYc4EFvdvr3zJDqMCRplYprLmCIXG1Ieq7bmtav52lBy4lpR5fyVcWdOU6N1zD+GA
	 hIr3lX/vh7b0gzZB/jV/1yQCrZzfPYs4NSV7edjIaSeV0rz9JOPFTW2/FNxttetDK2
	 4AFYIb3r0PobMcEDc/VgHI9DkqBJO9TmeZ/AzM+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/129] nvmet: always initialize cqe.result
Date: Tue, 23 Jul 2024 20:23:18 +0200
Message-ID: <20240723180406.722346489@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit cd0c1b8e045a8d2785342b385cb2684d9b48e426 ]

The spec doesn't mandate that the first two double words (aka results)
for the command queue entry need to be set to 0 when they are not
used (not specified). Though, the target implemention returns 0 for TCP
and FC but not for RDMA.

Let's make RDMA behave the same and thus explicitly initializing the
result field. This prevents leaking any data from the stack.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c             | 1 +
 drivers/nvme/target/fabrics-cmd-auth.c | 3 ---
 drivers/nvme/target/fabrics-cmd.c      | 6 ------
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index cfba3ec7add84..1cf6dfac18361 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -945,6 +945,7 @@ bool nvmet_req_init(struct nvmet_req *req, struct nvmet_cq *cq,
 	req->metadata_sg_cnt = 0;
 	req->transfer_len = 0;
 	req->metadata_len = 0;
+	req->cqe->result.u64 = 0;
 	req->cqe->status = 0;
 	req->cqe->sq_head = 0;
 	req->ns = NULL;
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 1d9854484e2e8..c103eba96350e 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -332,7 +332,6 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 		pr_debug("%s: ctrl %d qid %d nvme status %x error loc %d\n",
 			 __func__, ctrl->cntlid, req->sq->qid,
 			 status, req->error_loc);
-	req->cqe->result.u64 = 0;
 	if (req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2 &&
 	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
 		unsigned long auth_expire_secs = ctrl->kato ? ctrl->kato : 120;
@@ -515,8 +514,6 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 	status = nvmet_copy_to_sgl(req, 0, d, al);
 	kfree(d);
 done:
-	req->cqe->result.u64 = 0;
-
 	if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2)
 		nvmet_auth_sq_free(req->sq);
 	else if (req->sq->dhchap_step == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index d8da840a1c0ed..fa9e8dc921539 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -225,9 +225,6 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 	if (status)
 		goto out;
 
-	/* zero out initial completion result, assign values as needed */
-	req->cqe->result.u32 = 0;
-
 	if (c->recfmt != 0) {
 		pr_warn("invalid connect version (%d).\n",
 			le16_to_cpu(c->recfmt));
@@ -305,9 +302,6 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 	if (status)
 		goto out;
 
-	/* zero out initial completion result, assign values as needed */
-	req->cqe->result.u32 = 0;
-
 	if (c->recfmt != 0) {
 		pr_warn("invalid connect version (%d).\n",
 			le16_to_cpu(c->recfmt));
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BAA1944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L79r1oSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3155C433CA;
	Mon, 16 Oct 2023 08:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445837;
	bh=ccDAiy6tSYOlmUjcBGi3yuwIAAAzO01paigHvvnLsTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L79r1oSsGTVGSvI46c/0aIYBMcurPwuu+yxqnad9/tbZowY7pIvi6XRe06VyTeD8R
	 k3i1iB642IuvcaTMc6N/IH5bSYDh17voqjwImMmgOnCgpDRC7goO1O0hrJ9uEq2jQo
	 K7bvfhwikzyeVvQ6656DMrYrRw1I23x4RquFnF6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/102] scsi: ib_srp: Call scsi_done() directly
Date: Mon, 16 Oct 2023 10:40:03 +0200
Message-ID: <20231016083953.807221451@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 5f9ae9eecb15ef00d89a5884add1117a8e634e7f ]

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Link: https://lore.kernel.org/r/20211007202923.2174984-6-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: e193b7955dfa ("RDMA/srp: Do not call scsi_done() from srp_abort()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7701204fe5423..df7c740e26338 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1266,7 +1266,7 @@ static void srp_finish_req(struct srp_rdma_ch *ch, struct srp_request *req,
 	if (scmnd) {
 		srp_free_req(ch, req, scmnd, 0);
 		scmnd->result = result;
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 	}
 }
 
@@ -1984,7 +1984,7 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
 		srp_free_req(ch, req, scmnd,
 			     be32_to_cpu(rsp->req_lim_delta));
 
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 	}
 }
 
@@ -2236,7 +2236,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 err:
 	if (scmnd->result) {
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 		ret = 0;
 	} else {
 		ret = SCSI_MLQUEUE_HOST_BUSY;
@@ -2806,7 +2806,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	if (ret == SUCCESS) {
 		srp_free_req(ch, req, scmnd, 0);
 		scmnd->result = DID_ABORT << 16;
-		scmnd->scsi_done(scmnd);
+		scsi_done(scmnd);
 	}
 
 	return ret;
-- 
2.40.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335F819AD5C;
	Thu,  6 Jun 2024 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683051; cv=none; b=MH52iPDq5q7yAji3TZG874B1jpEYLe7C8H/xkK/xo2gTtbAGLvcgcIXe7/nUnF7klrw3UWx6IjplqVNnAB2amCHU5S3CMx4Z/YBZYpy6KvaajvYPU18MNHRzxEyOMc1039AkXSN/jj9uyJHaE8yQymf/9VPgXih1pE24IkvPMuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683051; c=relaxed/simple;
	bh=FRQbEnUe7wq1pnU3McKDQ1/tKsy/Yp3MUDckYSerQY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxmTJl3z8lzr8t6R866yyU8T2AnYQThDWp9PhenNZtUV+TFdwGWiHKwd3TEpm/LoOhfLuuOlc7BxThxacRRSpBxcMKIwzDfd3CXi98noJYy/TQ0FeCPNUa8GjKsTiODEMVg5GVV4R7NgCNsUy7biVzWeMO6VR99PRFXxXUxe7wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytDwkJ3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytDwkJ3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1430BC4AF0F;
	Thu,  6 Jun 2024 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683051;
	bh=FRQbEnUe7wq1pnU3McKDQ1/tKsy/Yp3MUDckYSerQY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytDwkJ3zrP5rkHj305jcNAh8+jkhtz2mpQrkiAFxLrOg3BPCgP/Sx+zpnHM/FUzXH
	 OtiKnRtvq/lcCOkgE37vYvtm/X7hAcjezfDF/VfrBNrwBV+uuvFJYwDJ2H40g+qasp
	 O/heDDhY7egq5Ptmy6C+BefVEqjlktCDq/yJlKo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 291/374] nvme: fix multipath batched completion accounting
Date: Thu,  6 Jun 2024 16:04:30 +0200
Message-ID: <20240606131701.633649007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 2fe7b422460d14b33027d8770f7be8d26bcb2639 ]

Batched completions were missing the io stats accounting and bio trace
events. Move the common code to a helper and call it from the batched
and non-batched functions.

Fixes: d4d957b53d91ee ("nvme-multipath: support io stats on the mpath device")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 095f59e7aa937..5008964f3ebe8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -414,6 +414,14 @@ static inline void nvme_end_req_zoned(struct request *req)
 	}
 }
 
+static inline void __nvme_end_req(struct request *req)
+{
+	nvme_end_req_zoned(req);
+	nvme_trace_bio_complete(req);
+	if (req->cmd_flags & REQ_NVME_MPATH)
+		nvme_mpath_end_request(req);
+}
+
 static inline void nvme_end_req(struct request *req)
 {
 	blk_status_t status = nvme_error_status(nvme_req(req)->status);
@@ -424,10 +432,7 @@ static inline void nvme_end_req(struct request *req)
 		else
 			nvme_log_error(req);
 	}
-	nvme_end_req_zoned(req);
-	nvme_trace_bio_complete(req);
-	if (req->cmd_flags & REQ_NVME_MPATH)
-		nvme_mpath_end_request(req);
+	__nvme_end_req(req);
 	blk_mq_end_request(req, status);
 }
 
@@ -476,7 +481,7 @@ void nvme_complete_batch_req(struct request *req)
 {
 	trace_nvme_complete_rq(req);
 	nvme_cleanup_cmd(req);
-	nvme_end_req_zoned(req);
+	__nvme_end_req(req);
 }
 EXPORT_SYMBOL_GPL(nvme_complete_batch_req);
 
-- 
2.43.0




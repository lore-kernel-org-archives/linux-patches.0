Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368051C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 14:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1C3C433EF;
	Mon, 20 Mar 2023 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324392;
	bh=HyviNjq//34wBxG5N3f5FgDFvfP9P+Nw5QyuklFae0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nu1ihJLQ082I5sZ7cfY3LcqPmEwQKxPgphlfdG+LjtIU5AT4pXFr4KFMa9xQILcdN
	 Z2dDMOTKQd5qva4awSEMwlIEbinGsu6HIVriQ86U16CyVvhtmb3E/KIXWyyrjwb25v
	 /5D/6wjQ3zxMtcDkYF9ux4YBBuQ5/QSRL2XtXAPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/36] nvmet: avoid potential UAF in nvmet_req_complete()
Date: Mon, 20 Mar 2023 15:54:37 +0100
Message-Id: <20230320145424.669564721@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 6173a77b7e9d3e202bdb9897b23f2a8afe7bf286 ]

An nvme target ->queue_response() operation implementation may free the
request passed as argument. Such implementation potentially could result
in a use after free of the request pointer when percpu_ref_put() is
called in nvmet_req_complete().

Avoid such problem by using a local variable to save the sq pointer
before calling __nvmet_req_complete(), thus avoiding dereferencing the
req pointer after that function call.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 80b5aae1bdc9b..aff18a3f002f9 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -528,8 +528,10 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_sq *sq = req->sq;
+
 	__nvmet_req_complete(req, status);
-	percpu_ref_put(&req->sq->ref);
+	percpu_ref_put(&sq->ref);
 }
 EXPORT_SYMBOL_GPL(nvmet_req_complete);
 
-- 
2.39.2




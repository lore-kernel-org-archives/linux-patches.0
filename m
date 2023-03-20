Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843121C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0361AC4339B;
	Mon, 20 Mar 2023 15:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324445;
	bh=tFz0OmXFy/F5X3/97+Pjr0LL8IRvbKfgCWbsIC9jsbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyPz9S/mwrAwdlF5+sM9PF8dJIrr3s0z1ncnU9Wp7L6izT76L4DVSpePL4AUyLKH4
	 2Lqzwr2+RfickwovFLus/5fwcChixaap7ZzUlhe9ZHUwbQXWu92qj8UD17iNYFO80l
	 TizVvSRu6xVIX3hE0UFAsWAK1zPYa6TZsVD9N1ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/60] nvmet: avoid potential UAF in nvmet_req_complete()
Date: Mon, 20 Mar 2023 15:54:35 +0100
Message-Id: <20230320145432.004209856@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
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
index ff206faae775c..d109333b95b81 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -728,8 +728,10 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
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




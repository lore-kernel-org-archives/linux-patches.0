Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01E75103A;
	Mon, 11 Dec 2023 18:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIUTq+K5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F41C433C7;
	Mon, 11 Dec 2023 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319405;
	bh=8JEKHP+VW7HEC1S8X0skHglUomzEuM1SRJmcwUUeRcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIUTq+K5Y5YuT1uUBc/CLPD5yAGgPPjdPhEKU6om2JGaZeWNpy8eQuwA/SnZtlHxA
	 8VllkGvru59PO6s3gN/5Z745ILSiXbP0mDvC/Ao00at+nuGb7+VTad7BmeSaM9qzpo
	 3TBCuljEyr0DcDDQ9xNde8aZ9h42IUympMG8zm0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/244] RDMA/rtrs-clt: Remove the warnings for req in_use check
Date: Mon, 11 Dec 2023 19:19:45 +0100
Message-ID: <20231211182049.910158031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 0c8bb6eb70ca41031f663b4481aac9ac78b53bc6 ]

As we chain the WR during write request: memory registration,
rdma write, local invalidate, if only the last WR fail to send due
to send queue overrun, the server can send back the reply, while
client mark the req->in_use to false in case of error in rtrs_clt_req
when error out from rtrs_post_rdma_write_sg.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://lore.kernel.org/r/20231120154146.920486-8-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index b020b97dbe679..1aee62aa1515d 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -384,7 +384,7 @@ static void complete_rdma_req(struct rtrs_clt_io_req *req, int errno,
 	struct rtrs_clt_path *clt_path;
 	int err;
 
-	if (WARN_ON(!req->in_use))
+	if (!req->in_use)
 		return;
 	if (WARN_ON(!req->con))
 		return;
-- 
2.42.0




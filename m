Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5AA63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4727EC433D2;
	Mon, 20 Feb 2023 13:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900382;
	bh=6fehiWq6QXlwSCfCT8uYtT4+jjYXcGDp6xddiift3uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMAaiZFkXBCDMaV/Wwlm6UEBTUGI28ngWoW/iETAcb5+huP0CeSqrHF9jUH8OmGm9
	 B/nR+zlLBoe6O9yyTzfNNfml8qZdXsX3syrtAfwuvxY8xHDQ9hKBAlEYq0BskYL8Sg
	 M6cl08qL+wUsaPJI1WZRuIKLlr0gcEPbw4CAhkfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Engel <Amit.Engel@dell.com>,
	James Smart <jsmart2021@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/53] nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association
Date: Mon, 20 Feb 2023 14:36:02 +0100
Message-Id: <20230220133549.457962642@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amit Engel <Amit.Engel@dell.com>

[ Upstream commit 0cab4404874f2de52617de8400c844891c6ea1ce ]

As part of nvmet_fc_ls_create_association there is a case where
nvmet_fc_alloc_target_queue fails right after a new association with an
admin queue is created. In this case, no one releases the get taken in
nvmet_fc_alloc_target_assoc.  This fix is adding the missing put.

Signed-off-by: Amit Engel <Amit.Engel@dell.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index df1c6dee255bf..b702bdc589551 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1301,8 +1301,10 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 		else {
 			queue = nvmet_fc_alloc_target_queue(iod->assoc, 0,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
-			if (!queue)
+			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
+				nvmet_fc_tgt_a_put(iod->assoc);
+			}
 		}
 	}
 
-- 
2.39.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26121D6A1
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd8Gf9N7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FD5C433C7;
	Wed,  4 Oct 2023 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443412;
	bh=h7vIKCIBGv+4k/APfsTCw1MdSwQX//aC1t8/vtuGX3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wd8Gf9N7gtFiMuQXR9HejnoUf8EnVOEonDACIvS7vsLxCRot1FRM1IkKZBLTqoy+t
	 +pqqgSoiWIIrlWyT82KohoS51HOf+7qamapQecVyJqEIsU/6p5rdwCMUPwU0Oou9DG
	 PmOTq3WRfvyGZtbKutFEd/1/ibUEDuGiUEmfu+I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nigel Kirkland <nkirkland2304@gmail.com>,
	James Smart <jsmart2021@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/259] nvme-fc: Prevent null pointer dereference in nvme_fc_io_getuuid()
Date: Wed,  4 Oct 2023 19:55:20 +0200
Message-ID: <20231004175224.054815931@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nigel Kirkland <nkirkland2304@gmail.com>

[ Upstream commit 8ae5b3a685dc59a8cf7ccfe0e850999ba9727a3c ]

The nvme_fc_fcp_op structure describing an AEN operation is initialized with a
null request structure pointer. An FC LLDD may make a call to
nvme_fc_io_getuuid passing a pointer to an nvmefc_fcp_req for an AEN operation.

Add validation of the request structure pointer before dereference.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 6c3d469eed7e3..177a365b8ec55 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1911,7 +1911,7 @@ char *nvme_fc_io_getuuid(struct nvmefc_fcp_req *req)
 	struct nvme_fc_fcp_op *op = fcp_req_to_fcp_op(req);
 	struct request *rq = op->rq;
 
-	if (!IS_ENABLED(CONFIG_BLK_CGROUP_FC_APPID) || !rq->bio)
+	if (!IS_ENABLED(CONFIG_BLK_CGROUP_FC_APPID) || !rq || !rq->bio)
 		return NULL;
 	return blkcg_get_fc_appid(rq->bio);
 }
-- 
2.40.1




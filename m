Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB0C8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8395DC433C8;
	Sun, 16 Jul 2023 20:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538397;
	bh=OG+o7ENvenI1LO8yawpHtl1zafpz8T71YyI6z7Ho7rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xU7pQ+CVl+WgE8iXR8+AQQLv5tiLca3Z5ppgrhb0DE2rc/fp2tpdAeTduZv4IBTaf
	 rDxa3tLL1mJHTECLfrPwvkqTZbOKMLVTz+ZhZ125JLIMHAIS/bvkU4gTI6emXM6YwC
	 Gqg5akD9GuJCyBtOS9fb2dIAj1AQtMfQ+95COCJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhong Zhu <jinhongzhu@hust.edu.cn>,
	Dan Carpenter <error27@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 437/800] scsi: qedf: Fix NULL dereference in error handling
Date: Sun, 16 Jul 2023 21:44:50 +0200
Message-ID: <20230716194959.234261598@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jinhong Zhu <jinhongzhu@hust.edu.cn>

[ Upstream commit f025312b089474a54e4859f3453771314d9e3d4f ]

Smatch reported:

drivers/scsi/qedf/qedf_main.c:3056 qedf_alloc_global_queues()
warn: missing unwind goto?

At this point in the function, nothing has been allocated so we can return
directly. In particular the "qedf->global_queues" have not been allocated
so calling qedf_free_global_queues() will lead to a NULL dereference when
we check if (!gl[i]) and "gl" is NULL.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Jinhong Zhu <jinhongzhu@hust.edu.cn>
Link: https://lore.kernel.org/r/20230502140022.2852-1-jinhongzhu@hust.edu.cn
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 3b64de81ea0d3..2a31ddc99dde5 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3041,9 +3041,8 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 	 * addresses of our queues
 	 */
 	if (!qedf->p_cpuq) {
-		status = -EINVAL;
 		QEDF_ERR(&qedf->dbg_ctx, "p_cpuq is NULL.\n");
-		goto mem_alloc_failure;
+		return -EINVAL;
 	}
 
 	qedf->global_queues = kzalloc((sizeof(struct global_queue *)
-- 
2.39.2




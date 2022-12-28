Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C862C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFC1C433EF;
	Wed, 28 Dec 2022 15:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242437;
	bh=Hthdvw14v9qSmVBBX3dDmP4uqAL9X1pCznsOzIT+F3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Q3Y0u/TdwzUPc7+eQoIQTWbZScbTRnjjE2DE1qsg+Aoj1EzjR4LOGiBqhAnqWmvF
	 UkB7gXze6D6sz6m+DuPVJ3zVykeaLykD/kU2c+U3Q5a//m6U+ygcL8LpnnCJUqfGv8
	 gmJBsViIJ8se7BYUD4JKE2BsuhsE7Tvfk7almuxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0395/1073] media: amphion: cancel vpu before release instance
Date: Wed, 28 Dec 2022 15:33:03 +0100
Message-Id: <20221228144338.746691753@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit b3dd974af9de342c733492565ad02d7e23372876 ]

Revert "media: amphion: release m2m ctx when releasing vpu instance"
This reverts commit d91d7bc85062309aae6d8064563ddf17947cb6bc.

Call v4l2_m2m_ctx_release() to cancel vpu,
afterwards release the vpu instance.

Fixes: d91d7bc85062 ("media: amphion: release m2m ctx when releasing vpu instance")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 4b714fab4c6b..a24e2d0e9542 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -596,10 +596,6 @@ static int vpu_v4l2_release(struct vpu_inst *inst)
 		inst->workqueue = NULL;
 	}
 
-	if (inst->fh.m2m_ctx) {
-		v4l2_m2m_ctx_release(inst->fh.m2m_ctx);
-		inst->fh.m2m_ctx = NULL;
-	}
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
@@ -682,6 +678,13 @@ int vpu_v4l2_close(struct file *file)
 
 	vpu_trace(vpu->dev, "tgid = %d, pid = %d, inst = %p\n", inst->tgid, inst->pid, inst);
 
+	vpu_inst_lock(inst);
+	if (inst->fh.m2m_ctx) {
+		v4l2_m2m_ctx_release(inst->fh.m2m_ctx);
+		inst->fh.m2m_ctx = NULL;
+	}
+	vpu_inst_unlock(inst);
+
 	call_void_vop(inst, release);
 	vpu_inst_unregister(inst);
 	vpu_inst_put(inst);
-- 
2.35.1




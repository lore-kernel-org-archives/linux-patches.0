Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E417E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CDCC433D6;
	Wed,  2 Nov 2022 02:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357081;
	bh=0AsrD2YuKL/Q74x8z+X4BeocUb/adJ/a/32CeWhVIHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1aj587J98a3A5YeTrPG1yMgZc20R6zkGwavRd+w6DELlVa+WO2DpQFnys2u0E+bF
	 vfcXg4LtYTf8HdzlxxzO5oisPGYqkKnmEffuckHB5lxNwKiXyI40kyB3vNJ5Yb8I+K
	 rvGboGiXcSlWo/PojYOYoYRABpgSD7u/QUcdVGc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Tommaso Merciai <tommaso.merciai@amarulasolutions.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/240] media: amphion: release m2m ctx when releasing vpu instance
Date: Wed,  2 Nov 2022 03:31:24 +0100
Message-Id: <20221102022113.854213898@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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

[ Upstream commit d91d7bc85062309aae6d8064563ddf17947cb6bc ]

release m2m ctx in the callback function that
release the vpu instance, then there is no need
to add lock around releasing m2m ctx.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 8a3eed957ae6..b779e0ba916c 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -603,6 +603,10 @@ static int vpu_v4l2_release(struct vpu_inst *inst)
 		inst->workqueue = NULL;
 	}
 
+	if (inst->fh.m2m_ctx) {
+		v4l2_m2m_ctx_release(inst->fh.m2m_ctx);
+		inst->fh.m2m_ctx = NULL;
+	}
 	v4l2_ctrl_handler_free(&inst->ctrl_handler);
 	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
@@ -685,13 +689,6 @@ int vpu_v4l2_close(struct file *file)
 
 	vpu_trace(vpu->dev, "tgid = %d, pid = %d, inst = %p\n", inst->tgid, inst->pid, inst);
 
-	vpu_inst_lock(inst);
-	if (inst->fh.m2m_ctx) {
-		v4l2_m2m_ctx_release(inst->fh.m2m_ctx);
-		inst->fh.m2m_ctx = NULL;
-	}
-	vpu_inst_unlock(inst);
-
 	call_void_vop(inst, release);
 	vpu_inst_unregister(inst);
 	vpu_inst_put(inst);
-- 
2.35.1




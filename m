Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ADE126C18;
	Wed,  5 Feb 2025 13:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763285; cv=none; b=pdP3OYzUfQtEWSiU6jk3RMgoYPWHaH5ItSWj1XSst7lh4OOmjpWvziv24oZlAoHBIV2DzKjtURvhiW1Ly9wdHi0cry8PEq6MJUycgKSr8zDEHn3gMUpvgBUBLrl6DRfvhmM9QwOKbNmL1BetUTbkYEcXmocztZDZmSh6FArnVfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763285; c=relaxed/simple;
	bh=TdJ+B+aihFquNfVAxxxgrEp2EpuOvqXv77zJp1Aty/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RePICxWgCqystDnUNo0U/KjeDxS0ga6zOeXrzBqu0+EuQDeVL1Unz8wEvLd3peoS1IHKV1o9033guGjTkTzdCdh9cHfGroQ2n24XsAXh59Be7uoYSWdHDfsD3RBD3HI9F+dbThovxnTqxucuVhdMlmjMePhFv/qbJD1a560n8gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgboZKj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgboZKj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32F8C4CED1;
	Wed,  5 Feb 2025 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763285;
	bh=TdJ+B+aihFquNfVAxxxgrEp2EpuOvqXv77zJp1Aty/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgboZKj4k1qM6jcSTsULsK8zqNf80ZrYFUc4uUNljMJJjz0HwK34EtTzuhYuKPBRf
	 sQL4bY7Eq2fwndKmGFEuzPFPUuWfAOZItqPybXOV7T8ROBmPxTCKLraQCFNoJSxnm7
	 c4O3OzXlxTqlPgMfBbM5+k4R8FPIGQaPPjID8FXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/393] nvme: Add error path for xa_store in nvme_init_effects
Date: Wed,  5 Feb 2025 14:38:51 +0100
Message-ID: <20250205134420.766260041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit d4a95adeabc6b5a39405e49c6d5ed14dd83682c4 ]

The xa_store() may fail due to memory allocation failure because there
is no guarantee that the index NVME_CSI_NVM is already used. This fix
introduces a new function to handle the error path.

Fixes: cc115cbe12d9 ("nvme: always initialize known command effects")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 37485b8cc1281..75ea4795188f2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2945,6 +2945,25 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
 	return ret;
 }
 
+static int nvme_init_effects_log(struct nvme_ctrl *ctrl,
+		u8 csi, struct nvme_effects_log **log)
+{
+	struct nvme_effects_log *effects, *old;
+
+	effects = kzalloc(sizeof(*effects), GFP_KERNEL);
+	if (effects)
+		return -ENOMEM;
+
+	old = xa_store(&ctrl->cels, csi, effects, GFP_KERNEL);
+	if (xa_is_err(old)) {
+		kfree(effects);
+		return xa_err(old);
+	}
+
+	*log = effects;
+	return 0;
+}
+
 static void nvme_init_known_nvm_effects(struct nvme_ctrl *ctrl)
 {
 	struct nvme_effects_log	*log = ctrl->effects;
@@ -2991,10 +3010,9 @@ static int nvme_init_effects(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	}
 
 	if (!ctrl->effects) {
-		ctrl->effects = kzalloc(sizeof(*ctrl->effects), GFP_KERNEL);
-		if (!ctrl->effects)
-			return -ENOMEM;
-		xa_store(&ctrl->cels, NVME_CSI_NVM, ctrl->effects, GFP_KERNEL);
+		ret = nvme_init_effects_log(ctrl, NVME_CSI_NVM, &ctrl->effects);
+		if (ret < 0)
+			return ret;
 	}
 
 	nvme_init_known_nvm_effects(ctrl);
-- 
2.39.5




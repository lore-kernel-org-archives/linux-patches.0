Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9162813C9C4;
	Wed,  5 Feb 2025 13:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763486; cv=none; b=KsIt07cn8OAWaXIuuKW0ZD1b4EDCplhFk4HYK09z4kf6OJL25RzvB42cKB7hCIgnY8aZcSZeed7a7vpPF/tcqWClUYBjDOwy0eatnKlZGW2yDoLWU58HPtuwi9iYBpwqDc+C9NEH+hllT/wiJZN/FHUR4BckJzsFFcNUQqloznc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763486; c=relaxed/simple;
	bh=013J7+HmBCk2CHJ7qV3Ula25Iq1ltbJfGUzKRmojUAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXl8mZkm6fSeXR4oSUjIXOK3y3fA+AN5aRsciGudJQjjCGqRYrYOtfd+EcpxwaL7v8ukhap90wzjPpGqyb+5HovIo9q5AWAMk5mBYBqHOSwBB5yIC2ClM+hvNC+ifUMs4kKn8NfATrkK8iMv51M1rBdBaY0M1d0TdmT4g6cgEQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoExasnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoExasnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83C5C4CED6;
	Wed,  5 Feb 2025 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763486;
	bh=013J7+HmBCk2CHJ7qV3Ula25Iq1ltbJfGUzKRmojUAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoExasnM9LHIq/SB/H7K2zI9cM7pbPTEGkVs4dAenrdvMgDP8yb9D8PXW9lD/UnD9
	 e2vocMcOyYs9K2Al+ztH6onv21kCnMlSrxpIa0kLzNgyQHmKr4jyFNWoFcYSWras+5
	 o8vxj7Cq/VcuEGGykM3RKD2ATxH+FYsGyOujdNhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/590] nvme: Add error path for xa_store in nvme_init_effects
Date: Wed,  5 Feb 2025 14:36:15 +0100
Message-ID: <20250205134456.015004369@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f5ea15bfe6feb..23137fcd335b0 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3168,6 +3168,25 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
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
@@ -3214,10 +3233,9 @@ static int nvme_init_effects(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
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




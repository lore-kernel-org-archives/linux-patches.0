Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7B114A4E9;
	Wed,  5 Feb 2025 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763819; cv=none; b=KNuc6LBLm4MDS2YCnqDRJJlmyMyYJ3Xy2Hdsnade2TT2m4Tbn0uBEX0mYfL/HgNF+baNpjxNdy0Z2w9VAxEwozdz/tnF+6ZfG4mRYDz1QiiuZeXyO6yorpAm8YmRCKcGYB5NMVO6NOhlIwxjCo8Ia9NFzb+v5JAKGXtm2JuUIyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763819; c=relaxed/simple;
	bh=92j3FbzGWaSMCBS2WYE13ze11pJx4f3w9MkmfFQ4/fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXQM/Q1I6jTLh6byD5M0Z+UC+wEM3bIwdfHiUmNKpPf0rdVyW8E0Z5HdVIkiKAisHALHkr5IhIwDrlNR74dD/ftIlm2+MwrOL3Lm0G0+mYHkTDpt8xXSYMVrRMkDrpc5W5cR5Dc4AstQkMGhcNtK+cqoHEB+ZkWSA742Z6VfQhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4Cv77h4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4Cv77h4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8E2C4CED1;
	Wed,  5 Feb 2025 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763819;
	bh=92j3FbzGWaSMCBS2WYE13ze11pJx4f3w9MkmfFQ4/fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4Cv77h4rNj1eehGUH2oMNYOSs9dbTgZraQE9AhnIKjkqtJOO74XkZFS/JV5T0XPs
	 s8pU5NEju6wtBWTeh7nT0fAaTQXLa06wcj56ujtInOCfpItnlusvLQBAXQOxiwqnlS
	 +F4BmJVimbarh81D/B6UqPZ3qqKnDnxdDZ6489P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 021/623] nvme: Add error check for xa_store in nvme_get_effects_log
Date: Wed,  5 Feb 2025 14:36:03 +0100
Message-ID: <20250205134457.039126755@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit ac32057acc7f3d7a238dafaa9b2aa2bc9750080e ]

The xa_store() may fail due to memory allocation failure because there
is no guarantee that the index csi is already used. This fix adds an
error check of the return value of xa_store() in nvme_get_effects_log().

Fixes: 1cf7a12e09aa ("nvme: use an xarray to lookup the Commands Supported and Effects log")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a970168a3014e..315692cb2e614 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3092,7 +3092,7 @@ int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
 static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 				struct nvme_effects_log **log)
 {
-	struct nvme_effects_log	*cel = xa_load(&ctrl->cels, csi);
+	struct nvme_effects_log *old, *cel = xa_load(&ctrl->cels, csi);
 	int ret;
 
 	if (cel)
@@ -3109,7 +3109,11 @@ static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 		return ret;
 	}
 
-	xa_store(&ctrl->cels, csi, cel, GFP_KERNEL);
+	old = xa_store(&ctrl->cels, csi, cel, GFP_KERNEL);
+	if (xa_is_err(old)) {
+		kfree(cel);
+		return xa_err(old);
+	}
 out:
 	*log = cel;
 	return 0;
-- 
2.39.5




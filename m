Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7013C146A63;
	Wed,  5 Feb 2025 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763524; cv=none; b=bNMI7KluoXbfIqtwnOKXLr4aJtdk4DhQgr6R+F/ic5JhIezJT9VpaPnPNXmUnbpJcU+dIuT4vBTyvxynI2CeVDcN0qmnB4LsjYBTLSRm3X6dIwTQk48yjjKdrOv+AzBy5uc6woBZvdx4s9EfT6P4Af91/GIcTurZEs9hHC5ObQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763524; c=relaxed/simple;
	bh=8oKZY+l8wrQMiEygp/1VBqUMklCoIq33LWVLiSNJTpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PybJXW5f7X68zk4dHH+Y9f0uwrq3vqRO8o59n9rfZGpZn3sphShoa+YomqMeMYk9/nSqKT+iC9ImQTBPFPNhzh2SUcO0ZOWrQKgUAatyFcANsu2mWQJQmfX5G/8t96HX3KWQaxvcAARfQJtQoautRajG7AJogOl5IHJBnM/vizg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O783SazZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O783SazZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3CC4CED1;
	Wed,  5 Feb 2025 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763524;
	bh=8oKZY+l8wrQMiEygp/1VBqUMklCoIq33LWVLiSNJTpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O783SazZJux4aPq4MVKO4m/MsCSR74T2pIjwnPW4lGl/ZDZJkGketQAJ3TQSDQsaJ
	 0j1DsEuJkpXNy+VajWX/TE9RSO35j0yR5sbdrfU+nePPBkxfrIgrR6SDbe10vqAerg
	 F9R8S2mv55lNAnh+JxiD7b/JbJy5sGXQf4FopwyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/590] nvme: fix bogus kzalloc() return check in nvme_init_effects_log()
Date: Wed,  5 Feb 2025 14:36:20 +0100
Message-ID: <20250205134456.208611817@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 170e086ad3997f816d1f551f178a03a626a130b7 ]

nvme_init_effects_log() returns failure when kzalloc() is successful,
which is obviously wrong and causes failures to boot. Correct the
check.

Fixes: d4a95adeabc6 ("nvme: Add error path for xa_store in nvme_init_effects")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 23137fcd335b0..4c409efd8cec1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3174,7 +3174,7 @@ static int nvme_init_effects_log(struct nvme_ctrl *ctrl,
 	struct nvme_effects_log *effects, *old;
 
 	effects = kzalloc(sizeof(*effects), GFP_KERNEL);
-	if (effects)
+	if (!effects)
 		return -ENOMEM;
 
 	old = xa_store(&ctrl->cels, csi, effects, GFP_KERNEL);
-- 
2.39.5




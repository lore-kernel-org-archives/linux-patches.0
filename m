Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C7023372C;
	Mon, 10 Mar 2025 17:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628717; cv=none; b=BxzHlJspaslNULJB8cNI/zZGy2hqNJcVcc05UebJ1e15cTHxWkqG+hQKSdG0UqDf1l4GJy+60DfNuj7pgXjQZlhLqHCRBsXBVRHYG1yNn3s2x3iUJXphuZKF4XbPnc2YjYzOgKCBOuYFzKzDTHjH81fcN84KZIgMtihg8G4ozJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628717; c=relaxed/simple;
	bh=CjTMD5hyA0yu+sgmcYD6rRpjUckEIJsefjs8YXK61Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqKpqeG17LUklzH1E+Q/++OMnktq0niSTCvHDNwxtmm7dkAl08LB0SQ+r7VOk1i+zrRw9eOU3W4wHePXB6ErdlZ0D4EURcH8AZBrzpzRQ/0TrydSap/bmK4e2ZWHeIc1AOT6JrYF4mlcaLYpdg07eemNFow9Fd86UVWuJcWPzPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1K7YW2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1K7YW2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E669BC4CEE5;
	Mon, 10 Mar 2025 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628717;
	bh=CjTMD5hyA0yu+sgmcYD6rRpjUckEIJsefjs8YXK61Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1K7YW2IR5bt15mFQGgP7GEeNJNWuIx98K4PCDN5fyceRxI8RCtVb8ArOelnPxviM
	 gaNZFa+BpuxheP7fDF5CwQ3/WLjqKACC6Kn27EPyamecm/gLzBYYFNUR085PTKLn/k
	 kISOyZ9eU1OB5kAfRJfxSwftq6eNlbx++1X8Sxg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/620] nvme: Add error check for xa_store in nvme_get_effects_log
Date: Mon, 10 Mar 2025 17:57:39 +0100
Message-ID: <20250310170546.101821811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93a19588ae92a..17ba2e59fce26 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2861,7 +2861,7 @@ int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
 static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 				struct nvme_effects_log **log)
 {
-	struct nvme_effects_log	*cel = xa_load(&ctrl->cels, csi);
+	struct nvme_effects_log *old, *cel = xa_load(&ctrl->cels, csi);
 	int ret;
 
 	if (cel)
@@ -2878,7 +2878,11 @@ static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2131CAA86;
	Wed, 19 Feb 2025 09:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956012; cv=none; b=XM6ms5tH0Z0yZ3oErr8HpVxzLYuYgW+HPoQRRgwh/8/M5a7C0P+JMHkBVegbVmDUqjGk7qLEl9+qZXjvrb1b1gb9dXK4sAoiJgx0Gb2BQsmE3SYrv+4HjZjTlVo6vp+MJdXNl06+Ey2HMVNbO2taZASFZR0MIErb9w2ijtiw+EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956012; c=relaxed/simple;
	bh=wetrCDqJGvIH92Pvp8JjuaGrJyHanP/jlxl573ziXoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EarGCxGPVnwOuKETN1U4HyS83QKnlhyV2Nw/ljAb5t7dGTxBQx+A6mVSPtGvFFINzA7xK8zWD4tdb5ERkmaxhydfaIPaYd4BdlA0U1IC5DZ8h4TDGOFyR0e3fVvt8ATpxi/sk5Va2KQXFZDSTNJZ544YsKN7mWajmdqzf9PmgQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCYXnt9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCYXnt9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32F8C4CED1;
	Wed, 19 Feb 2025 09:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956012;
	bh=wetrCDqJGvIH92Pvp8JjuaGrJyHanP/jlxl573ziXoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCYXnt9yqbHbsRwXRP4d+DBDlwvM11+DulczKJHOZnrFFuzJLUoNZ+D8aB/WOEZH5
	 KsjcQSenCXaSuIpLSS93PJwfuafIO1fvpcSAPT0jqissw2Epo2kToh7kPhDcrEwgcw
	 DAIPQd+DH1aMEXy7a8oyobl6wx9ZvA/j8m4++7p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/578] nvme: Add error check for xa_store in nvme_get_effects_log
Date: Wed, 19 Feb 2025 09:20:12 +0100
Message-ID: <20250219082653.224654434@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 92ffeb6605618..abca395385b2e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3099,7 +3099,7 @@ int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
 static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
 				struct nvme_effects_log **log)
 {
-	struct nvme_effects_log	*cel = xa_load(&ctrl->cels, csi);
+	struct nvme_effects_log *old, *cel = xa_load(&ctrl->cels, csi);
 	int ret;
 
 	if (cel)
@@ -3116,7 +3116,11 @@ static int nvme_get_effects_log(struct nvme_ctrl *ctrl, u8 csi,
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




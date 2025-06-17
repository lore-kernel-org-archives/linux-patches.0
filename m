Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0418E025;
	Tue, 17 Jun 2025 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178952; cv=none; b=htA1crvovLZuRv1Pk8CBdGPfERyciAPKAlKAb8OOTzJ3owqI/U79seIfOqEW5HMNA2SZo1BoLFKv8fbNbxNYGWQY3nTXNEEdVj9XJ3ymGnerU208yZoNeyrgUdoTm/2H78x27FbrzlJJaGm00SFGd+w6DE1q7rf2Kd3fQxEIrXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178952; c=relaxed/simple;
	bh=kepEoy9E993nXqtKQAsVm9XL1VETSQUHvsH1685tp7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMUJfBjcpm8+8XUBFdEcYPdO/HtaOdAh6ae8OCM/oOVksXtRKi/7kOGT/QzJ2zwb9tgSNiO/HFS1ncTm6yR6m1fqHwdyCs+G88N2A0Fm5K26HQRvsxTSi/3mdYg+M1hEIBRHV9Oa+FOfVAGEbUiaFLfcd7SIHirR0VAOnSU1840=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORzDF8aJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORzDF8aJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E42C4CEE3;
	Tue, 17 Jun 2025 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178951;
	bh=kepEoy9E993nXqtKQAsVm9XL1VETSQUHvsH1685tp7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORzDF8aJN5w9XQnwLTk8UVP6DI9UMfYxSrhg1O5RkDs981cm1jJeJ3IQ4RnytRhRi
	 AU26JOh/LT7hgNjxjwM10ENCoUV51vBnxiAB5SAB61SVeVQ6CU9iOMW2Q9yrazZv47
	 up14Fxq+T42FZ1D9jFf9BtkEkX0OvDzwrUHehL+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 602/780] nvme: fix implicit bool to flags conversion
Date: Tue, 17 Jun 2025 17:25:10 +0200
Message-ID: <20250617152515.997655202@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit c4b680ac2863821e19d360fca62f78b68b1c8ece ]

nvme_map_user_request() takes flags as the last argument, but
nvme_uring_cmd_io() shoves a bool "vec" into it. It behaves as
expected because bool is converted to 0/1 and NVME_IOCTL_VEC is
defined as 1, but it's better to pass flags explicitly.

Fixes: 7b7fdb8e2dbc1 ("nvme: replace the "bool vec" arguments with flags in the ioctl path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index ca86d3bf7ea49..f29107d95ff26 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -521,7 +521,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	if (d.data_len) {
 		ret = nvme_map_user_request(req, d.addr, d.data_len,
 			nvme_to_user_ptr(d.metadata), d.metadata_len,
-			map_iter, vec);
+			map_iter, vec ? NVME_IOCTL_VEC : 0);
 		if (ret)
 			goto out_free_req;
 	}
-- 
2.39.5




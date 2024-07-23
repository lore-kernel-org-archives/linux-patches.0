Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBFB13D600;
	Tue, 23 Jul 2024 18:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759554; cv=none; b=dtCJ8Ke8/PA7rkeCsXE1qdpHJzaRYG9C1FdT/3e8hBGVhSh52G+IDC1eGBeobSEP/iZtXeudyVpEtbBwHMDyXI4pLXAagM8DE5kNDv6iAzWwMfAal8cGYPMcrAuw6Lb1Ktwx/Crh6Drrt5PXBTgdbjqqo7DDcz8ldvGeFdUsaOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759554; c=relaxed/simple;
	bh=J39qEzhrXDvGTZEkxRLVSGkCj1T7bJyM7NT4XP+4WxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXk/VGI8l16jXoztlEyayNLLtj2HXKc1ebMbWvhz2NNp8iy1nqcbapkC0mJMHCHnTZnZjwhEMA9stECP0bGwYj4r/0/YXps/wDgbfSlGWLYtWQrhgmWXSvkXNrSHgVWUbTxYXDnEwP3JwlxpfRQN5AU9WknKnoub9btV/ekw4bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiIR80kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiIR80kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D00C4AF0A;
	Tue, 23 Jul 2024 18:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759554;
	bh=J39qEzhrXDvGTZEkxRLVSGkCj1T7bJyM7NT4XP+4WxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiIR80kdHj4abh2eldEtBc/yxp+Zu/jg4pt390udr35egy4UegYZtpvVncuZMQ4RK
	 MuIamF57jZSqJZsNRcIPazrFhmuck0Q9f9aLaErJ1FsBa4KujKB05uDWhDryr6hYoy
	 8eMp5b0XfZfvkvtnBJLiS7ok248/JKrvj7EgCfvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunguang Xu <chunguang.xu@shopee.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/129] nvme: avoid double free special payload
Date: Tue, 23 Jul 2024 20:23:17 +0200
Message-ID: <20240723180406.684484057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chunguang Xu <chunguang.xu@shopee.com>

[ Upstream commit e5d574ab37f5f2e7937405613d9b1a724811e5ad ]

If a discard request needs to be retried, and that retry may fail before
a new special payload is added, a double free will result. Clear the
RQF_SPECIAL_LOAD when the request is cleaned.

Signed-off-by: Chunguang Xu <chunguang.xu@shopee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 94a0916f9cb78..e969da0a681b4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -938,6 +938,7 @@ void nvme_cleanup_cmd(struct request *req)
 			clear_bit_unlock(0, &ctrl->discard_page_busy);
 		else
 			kfree(bvec_virt(&req->special_vec));
+		req->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
-- 
2.43.0




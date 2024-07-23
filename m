Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4296C13D896;
	Tue, 23 Jul 2024 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759980; cv=none; b=D097LEeU/TciCOajRXvt/s7L583bkCtg7x7ATHfEB8xEa/maXfXLwN4kC+02EKnlJSgAyCzEmo5dIOnbs55BTmvF3Nn3P+F0E0WN0WVOhVVHmxJGQjPV4G0roxcIM6vHW3GmIk9vT06wEndXERwaTlMYRl+kLpJoaTBdpn897f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759980; c=relaxed/simple;
	bh=f+jVCPyOCkJNNsBrHi0rzJvgBLgMKmNg7zY9bX8ijCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwtO7d4Z4xfFHPLvQCgCnpxaa9A4Ns39p9WY9YrkfqYuxfSArs3S7TIOkqa+JnLB+l4pNWRvmYHGD4ubGuBEB+tMtfKV5J9l76U8PWnBH1hp8veXxm+HJgSPZoBZphpy7LGpIUtecPhwYQNy7MG6fOpvI8Y5lCBX6mEpdJoI0rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3PIqnHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3PIqnHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92E3C4AF0A;
	Tue, 23 Jul 2024 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759980;
	bh=f+jVCPyOCkJNNsBrHi0rzJvgBLgMKmNg7zY9bX8ijCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3PIqnHsyGpPheGsj6sdYUYkD28s6IZ8EsstQk7khGhk+pVY/z6rFBlOoap8Vo06j
	 IxsMEGQity1ikRjLEAmWaqi8SYSt53HuRVDN1gWJMnfmk7jBuYW2o2LfzlhORvfB0w
	 5jR3M8SnW04pA/PeiwZi0NbpXAyC8cVBBmqwehng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunguang Xu <chunguang.xu@shopee.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 062/163] nvme: avoid double free special payload
Date: Tue, 23 Jul 2024 20:23:11 +0200
Message-ID: <20240723180145.867468404@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index d513fd27589df..36f30594b671f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -998,6 +998,7 @@ void nvme_cleanup_cmd(struct request *req)
 			clear_bit_unlock(0, &ctrl->discard_page_busy);
 		else
 			kfree(bvec_virt(&req->special_vec));
+		req->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
-- 
2.43.0




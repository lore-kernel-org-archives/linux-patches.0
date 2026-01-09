Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B60359F98;
	Fri,  9 Jan 2026 12:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960081; cv=none; b=M5zIkWCxhdztX2rnbHNGAR8Q5lR78vVgNXX9YGIihoFCI0Q+ysT0keOsH99FS/hCfod620TsmHTnQ8WMGJNTgVYF+YRnv/hUK4eMxYN74O6A8MQDF9xFSdJFwoeuqxY3pNd7MKKkkEnKIoMeYvRkNmQws6FCKB/MTqwg87AJx00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960081; c=relaxed/simple;
	bh=wybHX70yiGLBPHze8xthcSXHx5VCkZaHu/5twCwJFEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOts+8uOrKohRaOzy5yoRunYrh5Oy96Eng7PALPdetFzz0CicnefT+V2WGyOzkRkOMAU+eTGwdWBBYppsUbmarff+IlmMgiS2iqPv5ZSngJ5weYMyd8hLooyhbqrXgXziuNpyoHFk1VUn6l5kb0mlyePUrw+SKYfRBTEct5HVEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1T/I5eai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1T/I5eai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1283FC4CEF1;
	Fri,  9 Jan 2026 12:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960081;
	bh=wybHX70yiGLBPHze8xthcSXHx5VCkZaHu/5twCwJFEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1T/I5eai/qTRkvi1x+BoLBCFvuiv8kGvoxW+haXQi/cL7fGAxspAI4YXAvf658dQZ
	 HkEoE7P/Nn3wKcnIXUtQX9kRZV9lEBlKH5hVJiNN5Lkyb+wCrYu6asrD/9zLXBv0p+
	 rt0NBXUJxso6jAwpdCPwCfnYkZu5T3g8wlPd8VJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Israel Rukshin <israelr@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/737] nvme-auth: use kvfree() for memory allocated with kvcalloc()
Date: Fri,  9 Jan 2026 12:36:56 +0100
Message-ID: <20260109112144.428629229@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit bb9f4cca7c031de6f0e85f7ba24abf0172829f85 ]

Memory allocated by kvcalloc() may come from vmalloc or kmalloc,
so use kvfree() instead of kfree() for proper deallocation.

Fixes: aa36d711e945 ("nvme-auth: convert dhchap_auth_list to an array")
Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 811541ce206bf..f1b0a8e7af896 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -997,7 +997,7 @@ void nvme_auth_free(struct nvme_ctrl *ctrl)
 	if (ctrl->dhchap_ctxs) {
 		for (i = 0; i < ctrl_max_dhchaps(ctrl); i++)
 			nvme_auth_free_dhchap(&ctrl->dhchap_ctxs[i]);
-		kfree(ctrl->dhchap_ctxs);
+		kvfree(ctrl->dhchap_ctxs);
 	}
 	if (ctrl->host_key) {
 		nvme_auth_free_key(ctrl->host_key);
-- 
2.51.0




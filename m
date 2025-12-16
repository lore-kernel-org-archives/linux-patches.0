Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BD3358D03;
	Tue, 16 Dec 2025 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886639; cv=none; b=GGmnB9LDgzt0ZTRSuWU9/KqVgGxU5SYutnSAiKO9Jufi061Lq40B7Sk++RhdEtKSICm/WEiF4OO2Kq2bIcK+MAUKniBNqytNNR7lIpQuGIlR9UWt04jAbnNDby+oEg84Ya8+GlAK8BLQPVRpdV265ZE+Ulb35Tth3PdxfIbFC8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886639; c=relaxed/simple;
	bh=1axajyM28XnPRYQLBVbhJFtDiSUc1GtgZrAy8z1yI4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyOp1RZovZjHTkQIZs1665gk9XmI5sCxsGZAyrJ2BPWthsE2uY3dhyvKyc/Kih7424KDXL4YTHx46iCeT1+l/tm6VlXCVNwo/N6hy8AMfAjBRhwGc6RKMeMUF6o3U2+PSe1fp0RGFUW5W/m9KbIwWuKbQqv6WO2ysumCPdl0iWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYZockUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYZockUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DDEC4CEF1;
	Tue, 16 Dec 2025 12:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886639;
	bh=1axajyM28XnPRYQLBVbhJFtDiSUc1GtgZrAy8z1yI4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYZockUaMU0vznqFAaNIgBrNLRLCN4XXAHmLofLxWLCZxeZZZIqX+KnWtt+jts5zq
	 zt49o6ssed6QLdfmRZn85kCsr6T+W0y4weNyhprXAG0eeOuvpbqtc4Z5mRrg+lpYE3
	 aC2Ez1JhLpoYUZLfm2p1b8whjKo88LgVK27pxJ34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Israel Rukshin <israelr@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 463/507] nvme-auth: use kvfree() for memory allocated with kvcalloc()
Date: Tue, 16 Dec 2025 12:15:04 +0100
Message-ID: <20251216111402.220337361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a01178caf15bb..8f3ccb317e4de 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -1122,7 +1122,7 @@ void nvme_auth_free(struct nvme_ctrl *ctrl)
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




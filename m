Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F6019D09A;
	Thu, 25 Jul 2024 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919144; cv=none; b=Wru+VGrFzgB9eZQGt5er4rMr11k6ei+kV5Gu8a3BvO/kUrZCxjp95fqoj3roZIYbLXo4xzGmRkBsK0otU5o9VO4kdzVoKpaY0QTAYunvYVUwkwR/8dXmo0xddCDHQNz4vFIiRoaCK2bS4ih6OLw72awjKZ9P4XSQHG+eF6C4blc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919144; c=relaxed/simple;
	bh=EuQZc7g/kOYxbgp1CEUwuFKGqIXj5DUXmDSS1AalG9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COh7HoFrFIZrn4jhejOWWTKUnbHWzdPTO68/eodt7E0mL4WVM/DhcXAQ2uGIBftoqkH5w4m6FQfahCNPumX6AN0IctvEeCvpY3lyICRAlJG7dUjaX97LelXjcTztPGoo2l4Xu24bepkaGZnyvSiNX9KEgckvBIy0MbI9D6FGQvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oU84Us4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oU84Us4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0701DC116B1;
	Thu, 25 Jul 2024 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919144;
	bh=EuQZc7g/kOYxbgp1CEUwuFKGqIXj5DUXmDSS1AalG9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oU84Us4X59+u/KtZZjk81gL21YNDKz7thb0GPM1LSPB3UCTKfC+YAucK7m40XQV1C
	 9eg089tKsF+Vmpa+EbkCjnmVX9gVnGbBf/YlH3shyEyCsRl+ArzDUyBLJDBlWMwfID
	 dzwZoxBcMNK5KDitmXexMSUmcfkmTxajOBoDyM8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunguang Xu <chunguang.xu@shopee.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/87] nvme: avoid double free special payload
Date: Thu, 25 Jul 2024 16:37:03 +0200
Message-ID: <20240725142739.571759418@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 960a31e3307a2..93a19588ae92a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -981,6 +981,7 @@ void nvme_cleanup_cmd(struct request *req)
 			clear_bit_unlock(0, &ctrl->discard_page_busy);
 		else
 			kfree(bvec_virt(&req->special_vec));
+		req->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
-- 
2.43.0




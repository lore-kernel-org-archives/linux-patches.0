Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E3D426EDA;
	Tue, 31 Mar 2026 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975138; cv=none; b=CB2iCS1IjWtUxyUfKjp6nUt3ReqJmK2U4nvzf0uk/FAG3wMJLJTPQ5rgrKRlLn84D1mlbuGz+c5pn8t3UInADSv1RcoIYdxaq6XUQ49ZsE5LhUPgG0oBu6FfYIz1tFKFBiMfVbM9ZWNn5HMiFr8si+f6UIIMVRsvq7oi1W4peJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975138; c=relaxed/simple;
	bh=irtckMe+GC/QrHtQpFNYrUGXcYlCf9mFGTJnBLm0dMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEyTNbzcKcRuctVfZ6MyP7hYFFyaSYRUGSGRv+ru2a9YGs5ZK1VvD8lPWwYkeUzc1v1a9f8JFGYK0J+eoxANQMbm1XWCprTNP2gC/Wk1nT/beYH1AHgQ449Ixe069ldg1ib0sNpmx5QW+SN/RxIlghKa1p4eEZbsn+Ah1W2FJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/YlK1qC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/YlK1qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C328CC19423;
	Tue, 31 Mar 2026 16:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975138;
	bh=irtckMe+GC/QrHtQpFNYrUGXcYlCf9mFGTJnBLm0dMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/YlK1qCc87leU/oLs5Mb1V/Qyu1TS/EFWixTic2YwVKt7BMOp0y9tr82vvPb+xyS
	 QtklqnnaxqJvBPldCrDobAsM20EIEuuOxAPraVjZz5cxJ/RTGXSbIs4y2uuPjky6Ma
	 ClwbK2MIaF3TGtctPsOfU3XleOnUp+pxP6OJ9C04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Samal <anil.samal@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 161/342] RDMA/irdma: Fix deadlock during netdev reset with active connections
Date: Tue, 31 Mar 2026 18:19:54 +0200
Message-ID: <20260331161804.934659750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Samal <anil.samal@intel.com>

[ Upstream commit 6f52370970ac07d352a7af4089e55e0e6425f827 ]

Resolve deadlock that occurs when user executes netdev reset while RDMA
applications (e.g., rping) are active. The netdev reset causes ice
driver to remove irdma auxiliary driver, triggering device_delete and
subsequent client removal. During client removal, uverbs_client waits
for QP reference count to reach zero while cma_client holds the final
reference, creating circular dependency and indefinite wait in iWARP
mode. Skip QP reference count wait during device reset to prevent
deadlock.

Fixes: c8f304d75f6c ("RDMA/irdma: Prevent QP use after free")
Signed-off-by: Anil Samal <anil.samal@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index ac3a8f3f95b7f..c454a006c78e0 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -558,7 +558,8 @@ static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	}
 
 	irdma_qp_rem_ref(&iwqp->ibqp);
-	wait_for_completion(&iwqp->free_qp);
+	if (!iwdev->rf->reset)
+		wait_for_completion(&iwqp->free_qp);
 	irdma_free_lsmm_rsrc(iwqp);
 	irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
 
-- 
2.53.0




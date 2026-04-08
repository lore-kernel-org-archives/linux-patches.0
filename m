Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF23D4134;
	Wed,  8 Apr 2026 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671796; cv=none; b=lTKDSC9Dg0/P/Bw4h20Ctxq3ZYX3Hk9YgKxqZL5gK7URGblu5yW1/cIGUwc6n5W2vE603FU0EUxMuo5rRqz9UDs2yDXCpzhtuBoe2mlnEB1XrwWIvUbLWiSnljRC4PRxB2jMwRyEZdvB+6e/XDEbqZ/unAGcrwRmLvYWIqP7Q0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671796; c=relaxed/simple;
	bh=y+bHvTpQAmKj5Y1PAbRdnQmt+Y+QgKTS7X0eSGgK2QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HD2XAVuXnN3lKWiuQDg+1qwEXxx6w38RwTb/UTDU311Vy7Q7hD4yqTCKYB4T0WlwTHSNSuHnU9Wg0/OxKp8I9whp+zTvdpu4y3gPqQrlPJEJ826yeJS3T8F3Jh6esy8yEumCaA/JlLIyUjKzs3nKbb0Gtb04BQ1jrhveTI4LGbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qA5VSAF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qA5VSAF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B40C19421;
	Wed,  8 Apr 2026 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671796;
	bh=y+bHvTpQAmKj5Y1PAbRdnQmt+Y+QgKTS7X0eSGgK2QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qA5VSAF4zlyT7vbNrszuwDeSTHoKgPoYkG+ZjJ770fuwmD7VIAD5fhz7cGbmhjUy3
	 yia7EUyVu6lNcAl/cKmYI92fFU2/Is5B8mR3I0pigEjZ8O8fslcdXIeYKciY7sxmZn
	 ZctKpzCsRN6ljTuczdyukPywIhmbU6wGTUG0krLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Samal <anil.samal@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/312] RDMA/irdma: Fix deadlock during netdev reset with active connections
Date: Wed,  8 Apr 2026 19:59:48 +0200
Message-ID: <20260408175936.393127896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6d1ca8a1717c4..1eb219fa0d453 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -534,7 +534,8 @@ static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	}
 
 	irdma_qp_rem_ref(&iwqp->ibqp);
-	wait_for_completion(&iwqp->free_qp);
+	if (!iwdev->rf->reset)
+		wait_for_completion(&iwqp->free_qp);
 	irdma_free_lsmm_rsrc(iwqp);
 	irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
 
-- 
2.53.0




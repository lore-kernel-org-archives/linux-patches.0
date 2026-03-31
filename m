Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C547426EB6;
	Tue, 31 Mar 2026 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975855; cv=none; b=QeDyuoeCIjbomGy/D2ahv+T26yWS+lqqm6wwKcQ9wyrxakUQCFaphREmQ9h0tP+GGsRboMQmGcwksfkzyjKlLHwebUEBBpasphZ5mGmLNGM6l6NdDE4sjvoOl8Bhdr+notYTYDUrTZKfPmy9F2CzFTaDoq2LZEvafbiyZxCXA1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975855; c=relaxed/simple;
	bh=zy4Jf9kX88NvmL94zomEnUzuzE1b1Va9zhO8g7Hk17c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv98XYoFAIZSBYL6oWR/34xI7qzFZsJKGU7eF5I5YHdkDcilDnkz3DQfQhPj2wxyBMkEiF2DeI80kUk3eJTZFEhhpYe5PUhSAg63rrxtWc3cH3vUBZ7r2832g5GZe0APDm4Ro3oLLZ+/7rqvDc791t7WQ7lIk3KaSCe0GKRH5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5Yg+ixH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5Yg+ixH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A849EC2BCB5;
	Tue, 31 Mar 2026 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975855;
	bh=zy4Jf9kX88NvmL94zomEnUzuzE1b1Va9zhO8g7Hk17c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5Yg+ixHdnmKEHOnjIQv3zgycVJ3fBUXUQjTHOiS08+LxDZZuordfP7JC3sfOhJiP
	 dapKaaUY82exoaWCujXrEeUuTFDnUnZtaK5DN95gc9QPkIQwsQIKapZLMd9tuoh3cx
	 iq7rsntjJRzM9LmAnApCRZIV6UUX/JMzFX4EVvH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Samal <anil.samal@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/244] RDMA/irdma: Fix deadlock during netdev reset with active connections
Date: Tue, 31 Mar 2026 18:21:03 +0200
Message-ID: <20260331161745.837974269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5db64fae45515..1f267dea6460e 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -536,7 +536,8 @@ static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	}
 
 	irdma_qp_rem_ref(&iwqp->ibqp);
-	wait_for_completion(&iwqp->free_qp);
+	if (!iwdev->rf->reset)
+		wait_for_completion(&iwqp->free_qp);
 	irdma_free_lsmm_rsrc(iwqp);
 	irdma_cqp_qp_destroy_cmd(&iwdev->rf->sc_dev, &iwqp->sc_qp);
 
-- 
2.53.0




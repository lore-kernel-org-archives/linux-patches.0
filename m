Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456F3E559E;
	Tue, 31 Mar 2026 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975083; cv=none; b=VkVKbhSjg3cy6HBH6M9gBu+u+UDDwAr/XCNbA1/dLkLdNNYvntuWXu6MoHZVYY630iF78pxgQOSJX1Hsp0ml3dlPWJpvDZFpvOIUQR2jJLvIzqePfYKsGs2PMlGL8dnKv7k2ugZihcPNU4vpDnE60o/JOPLAhMfvVbJUqNBvDj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975083; c=relaxed/simple;
	bh=pgUxXCHQUuUk0aBdCvEXAR3c8I8Yy3gbIdKJyYb7n2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6n0m7e2sIGHh3PkJDMqoqpAdbx5atm6mvL+XA+/N7gMmKWi0+tFOBegYYmwBMtHyUeB8oaQpa5ij3BbD47+HJaLF7ounIaWvkeflgKzoAVWlCjyFaiungqn26JjBqCC0NxZwZx1qketKp5t2NjPovPE1PFwT/lF0hFWX92MCso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL+OViNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL+OViNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A20C19423;
	Tue, 31 Mar 2026 16:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975083;
	bh=pgUxXCHQUuUk0aBdCvEXAR3c8I8Yy3gbIdKJyYb7n2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bL+OViNjs/GRzsQAF6xYMU0FjyM7FpmBjheyq3OHGH1UdLIEgzSjegydIe63vH22H
	 IsiLPDFSYpjpEBPye5lMnCK93kbjxGJEbFFZpOcqqsq4AN71Zax6rdLC2P0th7h9Qa
	 NEgL1dJsSd/3Xz9qKcXwRtzESBiGoe1H0MAMUqfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 156/342] RDMA/irdma: Initialize free_qp completion before using it
Date: Tue, 31 Mar 2026 18:19:49 +0200
Message-ID: <20260331161804.750056925@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 11a95521fb93c91e2d4ef9d53dc80ef0a755549b ]

In irdma_create_qp, if ib_copy_to_udata fails, it will call
irdma_destroy_qp to clean up which will attempt to wait on
the free_qp completion, which is not initialized yet. Fix this
by initializing the completion before the ib_copy_to_udata call.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 68fb81b7bd221..d279a015094be 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1105,6 +1105,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 	spin_lock_init(&iwqp->sc_qp.pfpdu.lock);
 	iwqp->sig_all = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
 	rf->qp_table[qp_num] = iwqp;
+	init_completion(&iwqp->free_qp);
 
 	if (udata) {
 		/* GEN_1 legacy support with libi40iw does not have expanded uresp struct */
@@ -1129,7 +1130,6 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 		}
 	}
 
-	init_completion(&iwqp->free_qp);
 	return 0;
 
 error:
-- 
2.53.0




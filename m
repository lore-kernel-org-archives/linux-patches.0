Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293FC2E1C7C;
	Tue, 31 Mar 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976562; cv=none; b=ompPyCi0h0glW+ZHcFrz9MuJRhhoJbRfBLHUzMvUtrIx3xdXh8JxdFB9LM4FObkVvZ26hWBs5920Sv827hHXiAkOnfu+kdtp5/LSusvDeZzawtQUdb6gRJOlHEOJtBduHN9mI4o6avMcrER4VqGL1Z6QGJOZpnrZS+/ig5cZ084=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976562; c=relaxed/simple;
	bh=h8kHVF6NVB/hROKPM5hFSn19A67G//oTRuh/qI6JIwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGFKCiRTORiFDq4t8fKudFYjwE9CNvDZu0F445MMa9lUSQUcoV0qDVJ74ITuH2vLzTXfY+5z1mWTHXmfAhCSgpCYmZw++Du5atdfZbk/6dXNo3YvrP1chKC1uYCwesErHweYKtMavUViUP9sVTpV1MinzJ9LYmjeG+z955QiXs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S31ebuYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S31ebuYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BD9C19423;
	Tue, 31 Mar 2026 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976562;
	bh=h8kHVF6NVB/hROKPM5hFSn19A67G//oTRuh/qI6JIwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S31ebuYVqhMm7iAwrQmDx4Q6pvssoA0+1IpvzUTAx1WdaQMM7GOD3T1E21DLFo5kJ
	 SW0r7IziSBOG6k+iY/mSBA81pF8klCeb6OzYpcD4SQGFrMwPMMBUTM/kJe1OrHNjFG
	 xDN9iJmB5VCSAFNmmMY1VcosQRSx8+pjqaOPAU98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/309] RDMA/irdma: Initialize free_qp completion before using it
Date: Tue, 31 Mar 2026 18:20:44 +0200
Message-ID: <20260331161758.664724336@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5d027c04dba6f..f53b8f0d7ca83 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1106,6 +1106,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 	spin_lock_init(&iwqp->sc_qp.pfpdu.lock);
 	iwqp->sig_all = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
 	rf->qp_table[qp_num] = iwqp;
+	init_completion(&iwqp->free_qp);
 
 	if (udata) {
 		/* GEN_1 legacy support with libi40iw does not have expanded uresp struct */
@@ -1130,7 +1131,6 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 		}
 	}
 
-	init_completion(&iwqp->free_qp);
 	return 0;
 
 error:
-- 
2.53.0




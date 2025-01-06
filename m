Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9F786332;
	Mon,  6 Jan 2025 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177763; cv=none; b=D5mKOISFkBNM9noaA6S7zp/sGd9fWWFXwmcK4CukXTAkuzDkehnLEtb4VQPgplKhh8U7fNswlHcynqhOEZ8ENhVY4XANRp3eY9EBRzfCk6v6lNyb10Pi4rPVFNbnkCjTkcwrDcL3BeDYYuEEKFf/602Zb8YlqN0YZsd18VjmlXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177763; c=relaxed/simple;
	bh=Ffe5/Msku3Jcj15suzpdo5FSn6JDtnYI80ROpey9qg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxRONJseFQ7GW6KNM3f+Env3BLLOdugii6drqFHG7whtnoVqF/+O3qNRFEA0AqpGdEgNFkZ97M6UOGTBP7aT1F9Pq0EoN7Y7OBtNOCE4t2LdGgX9qNLHDWrBtZIUXp4wsEmvzh+8U5ER/ykG+XPrxfB6590s8e+G3HyUkmHbT1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW8ZOQfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW8ZOQfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C76C4CED2;
	Mon,  6 Jan 2025 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177762;
	bh=Ffe5/Msku3Jcj15suzpdo5FSn6JDtnYI80ROpey9qg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW8ZOQfjwywfeJJc3d6flQsJpSBoEuKtfqNmOlHL0EkIpRivQRWhG7e927y/Qyxtn
	 mU5wXKGiwMT2JG+qlO0G4iDmD0aSUq4Bo4s9VKDjVJxYvLZay+dL64G5cK0afrfvm4
	 8l6aq5MDh3r7QVKiA8FMeOfhxFEre/0bNf6Awe5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/156] RDMA/bnxt_re: Avoid sending the modify QP workaround for latest adapters
Date: Mon,  6 Jan 2025 16:15:03 +0100
Message-ID: <20250106151142.392336791@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 064c22408a73b9e945139b64614c534cbbefb591 ]

The workaround to modify the UD QP from RTS to RTS is required
only for older adapters. Issuing this for latest adapters can caus
some unexpected behavior. Fix it

Fixes: 1801d87b3598 ("RDMA/bnxt_re: Support new 5760X P7 devices")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241204075416.478431-4-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 160096792224..390162018647 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2763,7 +2763,8 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 		wr = wr->next;
 	}
 	bnxt_qplib_post_send_db(&qp->qplib_qp);
-	bnxt_ud_qp_hw_stall_workaround(qp);
+	if (!bnxt_qplib_is_chip_gen_p5_p7(qp->rdev->chip_ctx))
+		bnxt_ud_qp_hw_stall_workaround(qp);
 	spin_unlock_irqrestore(&qp->sq_lock, flags);
 	return rc;
 }
@@ -2875,7 +2876,8 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 		wr = wr->next;
 	}
 	bnxt_qplib_post_send_db(&qp->qplib_qp);
-	bnxt_ud_qp_hw_stall_workaround(qp);
+	if (!bnxt_qplib_is_chip_gen_p5_p7(qp->rdev->chip_ctx))
+		bnxt_ud_qp_hw_stall_workaround(qp);
 	spin_unlock_irqrestore(&qp->sq_lock, flags);
 
 	return rc;
-- 
2.39.5




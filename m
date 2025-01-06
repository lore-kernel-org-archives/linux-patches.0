Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5731DACBB;
	Mon,  6 Jan 2025 15:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177430; cv=none; b=ghPUNWzu8h2Iy4V4e8tZpCroAaw+JIWXpE8BZDhgsBQvnrsbWBk8rOnONtu1AkUNODkCh/9lFJ0ltBDStIirrfCPJl07gyy+wU6sNciZwhabP2eaIbP+To/aeIGalsJ/UBrlv5hV+podOezIpkhW1R97a3SjUY0LQYIf6CCotb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177430; c=relaxed/simple;
	bh=SQj9LxqHhvbCb1QxE0pqoEeXUDLxTTo1ltJ4TfRKrME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGjxZZPRkvfKIBBg3dKDAMbznxklIb6cixRtKepY1BAM6QyrMp0+cqnyVXqT0sv0Kvx5QISAxD/lIYIoE5ZTnvEh7nXd9e5Xsf59Qdb3jMt4pXQueu/WiDJ5jV1juabAs7hzE2CEWqxnDtchpDniBaSKpWmvzrfsWh7gzZadsSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZLfHeEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZLfHeEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D03DC4CED6;
	Mon,  6 Jan 2025 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177430;
	bh=SQj9LxqHhvbCb1QxE0pqoEeXUDLxTTo1ltJ4TfRKrME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZLfHeEKn6ceVY/tYxNFyOfBVcDwBq9A9MFbe6BoIZgzSwa6eS+BgAyMw+qIzkgrp
	 YO87ICz51SyReOzQILLlWZscxMXDkwa0A72y4lUT4GdCpqvo5+abL2/4t5ro3iEEwJ
	 m34nH6GinliNcgu50HFwnktMqYRdQdotR/Ia3/J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/222] RDMA/bnxt_re: Avoid sending the modify QP workaround for latest adapters
Date: Mon,  6 Jan 2025 16:15:35 +0100
Message-ID: <20250106151155.728051333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df5897260601..fb6f15bb9d4f 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2710,7 +2710,8 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 		wr = wr->next;
 	}
 	bnxt_qplib_post_send_db(&qp->qplib_qp);
-	bnxt_ud_qp_hw_stall_workaround(qp);
+	if (!bnxt_qplib_is_chip_gen_p5_p7(qp->rdev->chip_ctx))
+		bnxt_ud_qp_hw_stall_workaround(qp);
 	spin_unlock_irqrestore(&qp->sq_lock, flags);
 	return rc;
 }
@@ -2822,7 +2823,8 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
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




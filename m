Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09CE153800;
	Tue,  3 Dec 2024 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240869; cv=none; b=gq7J5hdONERc8lUEhxFdptMF2SWNKddZlYgWFEmPUQCA16zJ1maAzvbMFj6BWXu02BR3QfkVMLFtWGbdY6oi9DS5JoEVdZYdpdS+N97xdoTpOorHW8oJfI2sgoL+1r1pyEcxc2U2O0s/ita/L0UqhMsECp+zsz9nqQPUEbdRX7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240869; c=relaxed/simple;
	bh=ep4Lr5KSZpg10xORlCSwfiTIwDDnYlpdUGCf1MPQ5rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIGXM8yWtfnSns1ZkS4gepmyxpGEL+M1ZgGeE/wUYDTUaVI5jS8+ZOmmqw5L/6NXfmbntPc/+6a2tYLqgl3UN/Dbv0QhJ47AygHWvWoSjyiKWctVbrXe3iUNmIaFHDCu/GGEGqICu2gMghWh9PLY5vjmXUbgoH9d04LbcxFNljg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKO9z3UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKO9z3UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FFFC4CECF;
	Tue,  3 Dec 2024 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240869;
	bh=ep4Lr5KSZpg10xORlCSwfiTIwDDnYlpdUGCf1MPQ5rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKO9z3UNB+PhcEWXn1VvioNe8OZIDXe7DWZ2EC/jDGI3nHxDMAzLEDIKjcWZHWjK7
	 Jne/mMPlVrkyuUbXGlDfvPFFUJzOwYVNotzebwBNjkdmzWZ+CRnjr3fV6FQF+95Ejb
	 KInNR8Mg2m8oJNiWXVI7xkTXTfyLlMZ5jeoRNOAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/826] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c
Date: Tue,  3 Dec 2024 15:39:46 +0100
Message-ID: <20241203144753.869216755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit 0fbc7a5027c6f7f2c785adae3dcec22b2f2b69b3 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: ab58a416c93f ("octeontx2-pf: cn10k: Get max mtu supported from admin function")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 87d5776e3b88e..7510a918d942c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1837,6 +1837,10 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 	if (!rc) {
 		rsp = (struct nix_hw_info *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			rc = PTR_ERR(rsp);
+			goto out;
+		}
 
 		/* HW counts VLAN insertion bytes (8 for double tag)
 		 * irrespective of whether SQE is requesting to insert VLAN
-- 
2.43.0




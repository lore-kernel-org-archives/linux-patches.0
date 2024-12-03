Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4C1F7560;
	Tue,  3 Dec 2024 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238462; cv=none; b=DXsSaZYxVZTx5JZkq2GnpaMP45pAHbDn2QmDGtHF3qHGDSLYlq1vJE8ztLW7nzcJA47RxxY/dcXQ2ebqj9TYNQoHNeKIyNWKhGuGzuC6bDexto/Qmeb11o0oJZJsE3qIcG9JweMqLHhmz7665c2RKXBsMG5ow8lbwxj842B8SIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238462; c=relaxed/simple;
	bh=jJPLmHiJKpiFjHo4qmHwNMrfUEpk+ujnxJXKB0vrVUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoQtFd0GAeqiTbntDuyoms8hmfmnzQl439ZvhhiM8rXjm9KIQJZBduDyfB3Akmw8M78aoRKdiKX1fOP8ukEBeOBZFxTfvf9TfRJ/a1wHaQqw/poveCKnaQbCEYy29P/TR61h2ZeuxSvdn8B0jO8/qEsXBhkcAZDh+qGLetdf4EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx1a5cgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx1a5cgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D9AC4CED8;
	Tue,  3 Dec 2024 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238462;
	bh=jJPLmHiJKpiFjHo4qmHwNMrfUEpk+ujnxJXKB0vrVUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wx1a5cgx8KySahvcRxLWIM3XPmCksr+95jve1wrjaOmSq19kXxPidojtc1Ml0Q5aF
	 XMgD/sqGSCKmS2MnfjSLJE3nERHPMpA7/8o89t4WwUlB4O6wwaVZxCVJuYsqz8mksK
	 0TqhAkEdWB/8Fc3/K1B2hGk3VCuWI1vWfqylM7rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 286/817] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c
Date: Tue,  3 Dec 2024 15:37:38 +0100
Message-ID: <20241203144006.973432080@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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




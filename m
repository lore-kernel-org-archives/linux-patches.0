Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33C10E0;
	Fri,  6 Dec 2024 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497142; cv=none; b=Rm8Ya9MueTdSoBXCaWmiubvml+GmmsSPdEepjKTx7wGMaH4yH398PtQJcVwDCEr8H9NzHEAxiU6XgtPtms33IcXwKt31MHSZ3/CZNUl5+JmE8XHSPeGiIriQg7G3fS3Q6dMysvHe8R04D9q4+rFPoQk57e2zY9lew0Zd5sspdZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497142; c=relaxed/simple;
	bh=itCJsCushDMHKpvD3tWPhjvQDvsmTvdBHkXebzpwB18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqAxpLNx4G3BO+eC3OFEdYfC9VABlDzTDsvAPOHrWrA8Qf2S1+4nUswWerjXyT7CzPMQZsovdzcSXGsXI/Tpx9AwF4Cp8sC9h2QNBT5JNowZjnni5m7ba09mJsgRHpCbCZ0dr6bU0eBAyFj1CPXxkUDzxRzYn2um21xFtsqlr04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwKbAOqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwKbAOqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80224C4CED1;
	Fri,  6 Dec 2024 14:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497142;
	bh=itCJsCushDMHKpvD3tWPhjvQDvsmTvdBHkXebzpwB18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwKbAOqKio5esSrZbujKOL7G45xGd/eee1hFN3Mu0QTT9SSk+nD/d/9UfctrLKm1F
	 0xiHXqy77ZxufM5qt7zHZ5WZo/HPmf4he92NQfNYZhoYh6evSYK/MNJaeUgHhCP3sG
	 Vl2ruLa8lFpw9WEoBvbCYh0LwPlglxvP/eHWLThU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/676] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c
Date: Fri,  6 Dec 2024 15:30:25 +0100
Message-ID: <20241206143701.389594471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b3064377510ed..47adccf7a7776 100644
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




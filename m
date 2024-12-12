Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D0E21639E;
	Thu, 12 Dec 2024 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022212; cv=none; b=cfM17efpI66k3lqm7vpa6sZNByllOp1um4WJabg76Zgnwfzh/iDsDVZkZ6a4MF+u5OXrDIQyXMacxf6/KcyOUGEa+kWxqTsx0+H96lWLnqBcvZAgbMNWpBFbclNInEhea1O4kkNfyrzRKJB+ughhPqm7KXsX/riYXlgfdJLbU/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022212; c=relaxed/simple;
	bh=8UhF/6x0FtJMt8oq/wWzaJ/cZ4U5ujSAnzI1HVp0ABA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFt7bEFsgvGCt4ZE2eoiwk6z+VRVzMnE+XNh2YQHWlNHze4dlRFjVhqSDqUxC1CJebp0tJ3TUuA2AqzL+VNgeP+RuwGkK39Y5vf4Lxy5MR8hjdOxyg0Dp+JctVaVSxNA2A14wMP75p2xgbaAa7r8VQ2SckNIYCHCLUgyQmhpOuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9F+9x2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9F+9x2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2B1C4CECE;
	Thu, 12 Dec 2024 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022211;
	bh=8UhF/6x0FtJMt8oq/wWzaJ/cZ4U5ujSAnzI1HVp0ABA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9F+9x2+jkUoVUJkMGx1FVGEA2b+1Q62i8r2VS0whsrWnDlpGajdomw8o4k1s2eYR
	 o4czmg6WvY3aiaLdDXoQP4k7lpQTb73pJepkTB+dNFE86YEANygrBb3YsS8ZjSeG02
	 TI24uNBW7kMJcBPby5AgN+X3YJKNl9jNxaH+ymfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/565] octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c
Date: Thu, 12 Dec 2024 15:56:13 +0100
Message-ID: <20241212144318.512280115@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit ac9183023b6a9c09467516abd8aab04f9a2f9564 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 2ca89a2c3752 ("octeontx2-pf: TC_MATCHALL ingress ratelimiting offload")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 95f21dfdba483..942ec8f394559 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -202,6 +202,11 @@ int cn10k_alloc_leaf_profile(struct otx2_nic *pfvf, u16 *leaf)
 
 	rsp = (struct  nix_bandprof_alloc_rsp *)
 	       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		rc = PTR_ERR(rsp);
+		goto out;
+	}
+
 	if (!rsp->prof_count[BAND_PROF_LEAF_LAYER]) {
 		rc = -EIO;
 		goto out;
-- 
2.43.0




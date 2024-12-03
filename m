Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253B1F75A8;
	Tue,  3 Dec 2024 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238474; cv=none; b=H0bBS3XIpLzX4fMTCnzRP8H2ZZ4W/zDDKWfnClwJnr3MJU27gwZNuNEVdHudrhvV4ykH2vOMtjwZ6CqTCmyw6D8LrUigcNBf9MjwKoYp9UTv4G8QkN10LmAz62T54jkk00+IO/FUpgOM2uCjeRkCqcvLM9aPr9/DETBAh+hWzWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238474; c=relaxed/simple;
	bh=VyG/aghmqzzHzFmY3prczraKv1lWsUiHuBESBZqRGoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loe/wqvzTqKGjJHSBr9UN2VPYWEjHUBj6XPEu4uT8EKZyRTO/cPt7E+p6P+vVMHj4RjFiNDnAdQGPEVuMlJ0s1ClYZJ7m8t64iomLlp/AQBNhfaWfrGkG1aHfKl2ovy23vdCgdcpRAF2wxpLukVeY552PlLXLcJdw7H/FWtxoXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyWds9dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyWds9dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EAFC4CED6;
	Tue,  3 Dec 2024 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238473;
	bh=VyG/aghmqzzHzFmY3prczraKv1lWsUiHuBESBZqRGoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyWds9dmiR/CrxBhW0FBIIq2ucJiAF0sTGd8uuYD9OV3mDcHjnbZo1Hhe56EGqwkB
	 Med1ukqz2B3tlgNT6UTHyJx0BjwzgAtVn0HxBkAWZIZ1TTdN7HhfrAIPeZ7Votvq3x
	 /ZP2r16oCQN9RPDPEsvjBXdnMxmxuZe4h2+MQf+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 289/817] octeontx2-pf: handle otx2_mbox_get_rsp errors in cn10k.c
Date: Tue,  3 Dec 2024 15:37:41 +0100
Message-ID: <20241203144007.090358978@linuxfoundation.org>
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
index c1c99d7054f87..7417087b6db59 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -203,6 +203,11 @@ int cn10k_alloc_leaf_profile(struct otx2_nic *pfvf, u16 *leaf)
 
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




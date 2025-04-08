Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43F02676FA;
	Tue,  8 Apr 2025 12:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115134; cv=none; b=h3LgG7CH43S/xauLa5cJ2WZWNONC5yZKi8gxs81kgGKNRYsB7eCk+uqQQEVdVtuIIKCccDS5Zd3Kf7qQbu9oNGwTT3GZPqRmE3vSAJfWYrxXkhGiG4bHNT2T1YrfoLE+dq4Nfsq1762vZUvrFbmXt+WezCJe+ezPdSU+4EIJuC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115134; c=relaxed/simple;
	bh=/GTc78TfoPry8OZHYL7SDWpcEQocDQSPwzZyK1MKd4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1YcAj8NOeWzlfvlHu5oJF0z309PQ4fUATD8ltGbfoRDC55iiaTjjG6GSUAtBauUfM5va3vR4+XMiBi+ZhNrXGpJ0ALk9YRUL4y4VJF1/DUWNEytck4yBmnwB1eWPltjEnLE2Pl4xwSFz7cw1B1JtK9I4Y4H2dXXJ97ZCXRu+zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOKSBXZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOKSBXZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C02C4CEE7;
	Tue,  8 Apr 2025 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115134;
	bh=/GTc78TfoPry8OZHYL7SDWpcEQocDQSPwzZyK1MKd4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOKSBXZ409o4AQg/2A9kHFpS7mq1+odVOG+LPQp2Ix3/gRtCiy7SI7XUvpoZ/+ptG
	 GKoJ7EYhhzuFM8TcYbLlmN0cownprCglIXMTZjGde5Rg0EVBjjAs7RzuoTY3hb25WB
	 Q9f7hFiOXEApbhRbKWrsiJ2S2OZ3d3g3+smngo+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 362/499] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:49:34 +0200
Message-ID: <20250408104900.258275344@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 8144e9c8f30fb23bb736a5d24d5c9d46965563c4 ]

Make sure we are not using DB's which were remapped for link status.

Fixes: f6e51c354b60 ("ntb: intel: split out the gen3 code")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen3.c b/drivers/ntb/hw/intel/ntb_hw_gen3.c
index ffcfc3e02c353..a5aa96a31f4a6 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen3.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen3.c
@@ -215,6 +215,9 @@ static int gen3_init_ntb(struct intel_ntb_dev *ndev)
 	}
 
 	ndev->db_valid_mask = BIT_ULL(ndev->db_count) - 1;
+	/* Make sure we are not using DB's used for link status */
+	if (ndev->hwerr_flags & NTB_HWERR_MSIX_VECTOR32_BAD)
+		ndev->db_valid_mask &= ~ndev->db_link_mask;
 
 	ndev->reg->db_iowrite(ndev->db_valid_mask,
 			      ndev->self_mmio +
-- 
2.39.5




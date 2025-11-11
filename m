Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8686126E158;
	Tue, 11 Nov 2025 01:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825384; cv=none; b=m5ZpWnb28Brbml5a5CH5fHWCYA80hEKt4rp1ZBlygAhfaXXboytW7YAszN6EjD9SNjuqhQajaNSlp2yBdxvi355CCoSzuKU8ElR30POhJpEaaeSltcW74UOpDBAZyGXGhqFpY7J2DJmKeIDWIN5bwXUHt25twDtT8Itf3W4un9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825384; c=relaxed/simple;
	bh=qA3nqPy6TBJIn1Sx803DJB/WvZ/DrPMiTRG3qMph09E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+5YcC2FlCSzcnf3TBxV73hNy7R+loOCnTKAwJ3+Fmw9s5r6+lvT0Egu37mTTOQEyuQmKOvTm2jmfdqL4wdZQwIzK8np/ag3SujJFCrqh85llrlD6R/9gW3NNztIWXKTr4/9aOQ46Pc3WTQ0JCpLeCUqN4XFhc2cXQBbzivFxWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuTV+42Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuTV+42Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB0CC116B1;
	Tue, 11 Nov 2025 01:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825384;
	bh=qA3nqPy6TBJIn1Sx803DJB/WvZ/DrPMiTRG3qMph09E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuTV+42ZBhpOUiqnGM4Ok9VhsOcm8HBdxFyGCUhMZIBmeV+C/cefYgT7YXcWGlg+Y
	 e62SFcMX8cks29kzZ9qT5Rz9L4aSTxkeoyZpYwGOW5ay7ppEWNsUWp3D0v8CATH8R3
	 QHN635duPfWD1IU7WOgxIw/ECL7P2J9lPoMyhUN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 779/849] octeontx2-pf: Fix devm_kcalloc() error checking
Date: Tue, 11 Nov 2025 09:45:49 +0900
Message-ID: <20251111004555.261726935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2e25935ed24daee37c4c2e8e29e478ce6e1f72c7 ]

The devm_kcalloc() function never return error pointers, it returns NULL
on failure.  Also delete the netdev_err() printk.  These allocation
functions already have debug output built-in some the extra error message
is not required.

Fixes: efabce290151 ("octeontx2-pf: AF_XDP zero copy receive support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aQYKkrGA12REb2sj@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index aff17c37ddde0..902d6abaa3ec1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1516,10 +1516,8 @@ int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
 		pool->xdp_cnt = numptrs;
 		pool->xdp = devm_kcalloc(pfvf->dev,
 					 numptrs, sizeof(struct xdp_buff *), GFP_KERNEL);
-		if (IS_ERR(pool->xdp)) {
-			netdev_err(pfvf->netdev, "Creation of xsk pool failed\n");
-			return PTR_ERR(pool->xdp);
-		}
+		if (!pool->xdp)
+			return -ENOMEM;
 	}
 
 	return 0;
-- 
2.51.0




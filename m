Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B63603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300970; cv=none; b=pJ6TpHz//HlllzBAcFWVBvd8cl3ZHQjfoZkfYjZmYTQ7BelKO1KW35cLOCionRo+4Dg0FXd6cpQSB8NTzNaPh2HLIxF6Z13Yo1HXeZtX1h4/w1QQ6BCyQMhoKhXrImOJ2tjR1STKWSQ5nn/w9qW/l+i1ftvVORz5PyVoOv4+Rxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300970; c=relaxed/simple;
	bh=rbgw5izTleVxv+iMLaezDmiKBi4xS3WfjILjsEfjiqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX5+LkFa/zcIuBARKwQsrkbxlF6CKyyUR3atKjQxZmcwx/4xgVWyP2MhqmadUOD49vuwDGF1i6UCYPJqLbeHvCimoO2giAJvuxC3/hIHzBHY7jwkUEk3Cn35oANVwJyDgzvjhbET1cKcx9qlAyj7quTpClqakk3y9J1bNxR94wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ezj2xZ/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ezj2xZ/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EC6C116D0;
	Sat, 28 Feb 2026 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300970;
	bh=rbgw5izTleVxv+iMLaezDmiKBi4xS3WfjILjsEfjiqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ezj2xZ/XynvPoeQ+OC2aC05B8rXYNBBp1Ye23avlkUYNcXG//AmZ61wNWbnF/D0Ao
	 Kh7kDj0ke1Trvy8czqgKOTvL9J/FzERpKa/QlQyDIQ1Dg0zl7/xgcPUqCUPHY+zy3s
	 tOhk+Fa7GZ52SB+GRzLQdDn3yx0rHRgCSH1YYLaiJ1WIHiJnfMhZu/LfGCM3OcFFqi
	 T+1Lm7Crqd3rCkPzugpu1IP2oUfNicyuz90bOZHBuiOAzsaRDebKCUPL9+I1W6P5Vj
	 Q7A2MeNZCUnYOp79vBuE5TkGKaj9qig0tD67ygZLbSO2l3f0KCdon8eRQT7pVB3/HC
	 i6paB/JvGy3pA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/752] firmware: arm_ffa: Unmap Rx/Tx buffers on init failure
Date: Sat, 28 Feb 2026 12:36:48 -0500
Message-ID: <20260228174750.1542406-97-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 9fda364cb78c8b9e1abe4029f877300c94655742 ]

ffa_init() maps the Rx/Tx buffers via ffa_rxtx_map() but on the
partition setup failure path it never unmaps them.

Add the missing ffa_rxtx_unmap() call in the error path so that
the Rx/Tx buffers are properly released before freeing the backing
pages.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Message-Id: <20251210031656.56194-1-lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index c501c3104b3a4..11a702e7f641c 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -2093,6 +2093,7 @@ static int __init ffa_init(void)
 
 	pr_err("failed to setup partitions\n");
 	ffa_notifications_cleanup();
+	ffa_rxtx_unmap(drv_info->vm_id);
 free_pages:
 	if (drv_info->tx_buffer)
 		free_pages_exact(drv_info->tx_buffer, rxtx_bufsz);
-- 
2.51.0

